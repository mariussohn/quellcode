codeunit 2020813 "Notify Response Library WMR"
{
    var
        CreateNotifyEntryDescrTxt: Label 'Create an Notify Entry from waste mgt. document';
        SendNotifyEntryViaInterfaceDescrTxt: Label 'Send Notification via Interface.';
        DeleteNotifyEntryDescrTxt: Label 'Delete an entry from table Notify Entry.';
        NotSupportedSourceForNotifyEntryErr: Label 'Cannot initialize a Notify Entry from %1', Comment = '%1 = Tablecaption';

    procedure CreateResponsesLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        with WorkflowResponseHandling do begin
            AddResponseToLibrary(CreateNotifyEntryFromWasteDocumentCode, 0, CreateNotifyEntryDescrTxt, 'GROUP 0');
            AddResponseToLibrary(SendNotifyEntryViaInterfaceCode, 0, SendNotifyEntryViaInterfaceDescrTxt, 'GROUP 2020800');
            AddResponseToLibrary(DeleteNotifyEntryCode, 0, DeleteNotifyEntryDescrTxt, 'GROUP 0');
        end;

    end;

    procedure AddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        EventLib: Codeunit "Notify Event Library WMR";
    begin
        With WorkflowResponseHandling do
            case ResponseFunctionName of
                CreateNotifyEntryFromWasteDocumentCode:
                    AddResponsePredecessor(CreateNotifyEntryFromWasteDocumentCode, EventLib.RunWorkflowOnSendDocumentForNotificationCode);
                SendNotifyEntryViaInterfaceCode:
                    AddResponsePredecessor(SendNotifyEntryViaInterfaceCode, EventLib.RunWorkflowOnCarryOutNotifyEntryCode);
                DeleteNotifyEntryCode:
                    begin
                        AddResponsePredecessor(DeleteNotifyEntryCode, EventLib.RunWorkflowOnDisablesNotificationCode);
                        AddResponsePredecessor(DeleteNotifyEntryCode, EventLib.RunWorkflowOnCarryOutNotifyEntryCode);
                    end;
            end;
    end;

    procedure ExecuteWorkflowResponse(var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                CreateNotifyEntryFromWasteDocumentCode():
                    begin
                        CreateNotifyEntry(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;

                SendNotifyEntryViaInterfaceCode:
                    begin
                        CarryOutNotifyEntry(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;

                DeleteNotifyEntryCode:
                    begin
                        DeleteNotifyEntry(Variant);
                        ResponseExecuted := true;
                    end;
            end;
    end;

    local procedure DeleteNotifyEntry(var Variant: Variant)
    var
        NotifyEntry: Record "Notify Entry WMR";
    begin
        GetNotifyEntryFromVariant(Variant, NotifyEntry);
        NotifyEntry.Delete(true);
    end;

    local procedure CreateNotifyEntry(var Variant: Variant;
    WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecRef: RecordRef;
        NotifyEntry: Record "Notify Entry WMR";
    begin
        RecRef.GetTable(Variant);
        PopulateNotifyEntryArgument(RecRef, WorkflowStepInstance, NotifyEntry);
        CheckNotifyEntry(NotifyEntry);
        NotifyEntry.Insert(true);
    end;

    local procedure PopulateNotifyEntryArgument(RecRef: RecordRef;
    WorkflowStepInstance: Record "Workflow Step Instance"; var NotifyEntry: Record "Notify Entry WMR")
    var
        WasteHeader: Record "Waste Management Header WMR";
        Handled: Boolean;
    begin
        NotifyEntry.Init();
        NotifyEntry."Table ID" := RecRef.Number;
        NotifyEntry."Source Record ID" := RecRef.RecordId;
        NotifyEntry."Workflow Step Instance ID" := WorkflowStepInstance.ID;

        case RecRef.Number of
            Database::"Waste Management Header WMR":
                begin
                    RecRef.SetTable(WasteHeader);
                    NotifyEntry."Contact No." := WasteHeader.NotifyContactNo;
                    NotifyEntry."Expiration Date/Time" := CreateDateTime(WasteHeader."Task Date", 100000T);
                    NotifyEntry."Message Interface" := WasteHeader.NotifyInterface;
                    NotifyEntry."No. of Messages Send" := 0;
                    NotifyEntry."Time until Expiration" := NotifyEntry."Expiration Date/Time" - System.CurrentDateTime;
                    NotifyEntry."Order No." := WasteHeader."No.";
                    if NotifyEntry."Time until Expiration" > HoursToDuration(34) then begin
                        NotifyEntry."Current Step" := NotifyEntry."Current Step"::"order confirmation";
                    end;
                    if (NotifyEntry."Time until Expiration" < HoursToDuration(34)) and (NotifyEntry."Time until Expiration" > HoursToDuration(10))
                    then begin
                        NotifyEntry."Current Step" := NotifyEntry."Current Step"::memory;
                    end;
                    if (NotifyEntry."Time until Expiration" < HoursToDuration(10)) and (NotifyEntry."Time until Expiration" > HoursToDuration(0))
                    then begin
                        NotifyEntry."Current Step" := NotifyEntry."Current Step"::"memory at task date";
                    end;
                    if NotifyEntry."Time until Expiration" < HoursToDuration(0) then begin
                        NotifyEntry."Current Step" := NotifyEntry."Current Step"::"finished";
                    end;
                end;
            else begin
                    Handled := false;
                    OnPopulateNotifyEntryArgument(Handled, RecRef, NotifyEntry);
                    if not Handled then
                        error(NotSupportedSourceForNotifyEntryErr, RecRef.Caption);
                end;
        end;
    end;

    local procedure CheckNotifyEntry(NotifyEntry: Record "Notify Entry WMR")
    var
        IMessageInterface: Interface "INotifyMessageInterfaceWMR";
    begin
        IMessageInterface := NotifyEntry."Message Interface";
        IMessageInterface.CheckData(NotifyEntry);
    end;

    local procedure CarryOutNotifyEntry(var Variant: Variant;
    WorkflowStepInstance: Record "Workflow Step Instance")
    var
        NotifyEntry: Record "Notify Entry WMR";
        IMessageInterface: Interface INotifyMessageInterfaceWMR;
        SMS: Codeunit "Notify SMS Interface WMR";
    begin
        GetNotifyEntryFromVariant(Variant, NotifyEntry);
        IMessageInterface := NotifyEntry."Message Interface";
        IMessageInterface.SendNotify(
            NotifyEntry,
            BuildMessage(GetMessageFromWorkflowStep(WorkflowStepInstance), NotifyEntry));
        NotifyEntry."No. of Messages Send" := NotifyEntry."No. of Messages Send" + 1;
        case NotifyEntry."Current Step" of
            NotifyEntry."Current Step"::"order confirmation":
                begin
                    NotifyEntry."Current Step" := NotifyEntry."Current Step"::memory;
                end;
            NotifyEntry."Current Step"::"memory":
                begin
                    NotifyEntry."Current Step" := NotifyEntry."Current Step"::"memory at task date";
                end;
            NotifyEntry."Current Step"::"memory at task date":
                begin
                    NotifyEntry."Current Step" := NotifyEntry."Current Step"::finished;
                end;
        end;
        NotifyEntry.Modify();
    end;

    local procedure GetMessageFromWorkflowStep(WorkflowStepInstance: Record "Workflow Step Instance") MessageText: Text
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        WorkflowStepArgument.Get(WorkflowStepInstance.Argument);
        MessageText := WorkflowStepArgument.NotifyMessageTextWMR;
    end;

    local procedure BuildMessage(MessageTemplateText: Text; NotifyEntry: Record "Notify Entry WMR") MessageText: Text;
    begin
        exit(MessageTemplateText);
    end;

    local procedure GetNotifyEntryFromVariant(var Variant: Variant; var NotifyEntry: Record "Notify Entry WMR")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        if (RecRef.Number = Database::"Notify Entry WMR") then
            RecRef.SetTable(NotifyEntry)
        else
            NotifyEntry.GetBySourceRecord(RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPopulateNotifyEntryArgument(var Handled: Boolean; RecRef: RecordRef; var NotifyEntry: Record "Notify Entry WMR")
    begin
    end;

    procedure CreateNotifyEntryFromWasteDocumentCode(): Code[128]
    begin
        exit(UpperCase('CreateNotifyEntryFromWasteDocumentCodeWMR'));
    end;

    procedure SendNotifyEntryViaInterfaceCode(): Code[128]
    begin
        exit(UpperCase('SendNotifyEntryViaInterfaceWMR'));
    end;

    procedure DeleteNotifyEntryCode(): Code[128]
    begin
        exit(UpperCase('DeleteNotifyEntryCodeWMR'));
    end;

    local procedure HoursToDuration(Hours: Integer): Duration
    begin
        exit(3600000 * Hours);
    end;


}