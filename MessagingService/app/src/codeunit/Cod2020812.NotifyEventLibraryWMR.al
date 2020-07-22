codeunit 2020812 "Notify Event Library WMR"
{
    var
        RequestNotificationEventDescrTxt: Label 'Notification is requested.';
        CarryOutNotifyEventDescrTxt: Label 'A Notify Entry is carried out.';
        DisableNotifyDescrText: Label 'Disable Notification.';

    procedure CreateEventsLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        with WorkflowEventHandling do begin

            AddEventToLibrary(
                RunWorkflowOnSendDocumentForNotificationCode, Database::"Waste Management Header WMR",
                RequestNotificationEventDescrTxt, 0, false);
            AddEventToLibrary(
                RunWorkflowOnCarryOutNotifyEntryCode, Database::"Notify Entry WMR", CarryOutNotifyEventDescrTxt, 0, false);
            AddEventToLibrary(
                RunWorkflowOnDisablesNotificationCode, Database::"Notify Entry WMR", DisableNotifyDescrText, 0, false);
        end;
    end;

    procedure AddEventPredecessors(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        with WorkflowEventHandling do
            case EventFunctionName of
                RunWorkflowOnCarryOutNotifyEntryCode:
                    AddEventPredecessor(RunWorkflowOnCarryOutNotifyEntryCode, RunWorkflowOnSendDocumentForNotificationCode);
                RunWorkflowOnDisablesNotificationCode:
                    AddEventPredecessor(RunWorkflowOnDisablesNotificationCode, RunWorkflowOnSendDocumentForNotificationCode);
            end;
    end;

    procedure ExecuteNotifyWorkflow(var WasteHeader: Record "Waste Management Header WMR");
    var
        WorkflowMgt: Codeunit "Workflow Management";
    begin
        WorkflowMgt.HandleEvent(RunWorkflowOnSendDocumentForNotificationCode, WasteHeader);
    end;

    procedure CanExecuteNotifyWorkflow(WasteHeader: Record "Waste Management Header WMR"): Boolean
    var
        WorkflowMgt: Codeunit "Workflow Management";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(WasteHeader, RunWorkflowOnSendDocumentForNotificationCode));
    end;

    procedure ExecuteNotification(var NotifyEntry: Record "Notify Entry WMR")
    var
        WorkflowMgt: Codeunit "Workflow Management";
    begin
        WorkflowMgt.HandleEventOnKnownWorkflowInstance(
            RunWorkflowOnCarryOutNotifyEntryCode,
            NotifyEntry,
            NotifyEntry."Workflow Step Instance ID");
    end;

    procedure ExecuteDisableNotification(var NotifyEntry: Record "Notify Entry WMR")
    var
        WorkflowMgt: Codeunit "Workflow Management";
    begin
        WorkflowMgt.HandleEventOnKnownWorkflowInstance(
            RunWorkflowOnDisablesNotificationCode,
            NotifyEntry, NotifyEntry."Workflow Step Instance ID");
    end;

    procedure RunWorkflowOnSendDocumentForNotificationCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowRequestWasteMgtDocumentNotificationWMR'))
    end;

    procedure RunWorkflowOnCarryOutNotifyEntryCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowCarryOutNotifyEntryWMR'));
    end;

    procedure RunWorkflowOnDisablesNotificationCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDisableNotificationCode'));
    end;

}