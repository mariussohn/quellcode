codeunit 2020802 "Notify Workflow Mgt. WMR"
{
    var
        NotifyCategoryDescrTxt: Label 'Notification';
        ServiceAnouncementWorkflowDescTxt: Label 'Service Anouncement Workflow - Waste Mgt.';
        DocumentHeaderCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Waste Management Header WMR">%1</DataItem><DataItem name="Waste Management Line WMR">%2</DataItem></DataItems></ReportParameters>', Locked = true;
        NotifyEntriesCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Notify Entry WMR">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        ServiceAnouncementEnabledMsg: Label 'Service notification was enabled.';
        ServiceAnouncementDisabledMsg: Label 'Service notification was removed.';

    procedure InitWorkflowModule()
    var
        NotifyEventLib: Codeunit "Notify Event Library WMR";
        NotifyResponseLib: Codeunit "Notify Response Library WMR";
    begin
        NotifyEventLib.CreateEventsLibrary();
        NotifyResponseLib.CreateResponsesLibrary();
        InsertNotifyTableRelations();

        AddWorkflowCategoriesToLibrary();
        InsertWorkflowTemplates();
    end;

    local procedure InsertNotifyTableRelations()
    var
        NotifyEntry: Record "Notify Entry WMR";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Waste Management Header WMR", 0,
          DATABASE::"Notify Entry WMR", NotifyEntry.FieldNo("Source Record ID"));
    end;

    local procedure AddWorkflowCategoriesToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertWorkflowCategory(NotifyCategoryCode, NotifyCategoryDescrTxt);
    end;

    local procedure InsertWorkflowTemplates()
    begin
        InsertNotifyWorkflowTemplate();
    end;

    local procedure InsertNotifyWorkflowTemplate()
    var
        Workflow: Record Workflow;
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        if GetWorkflow(Workflow, ServiceAnouncementWorkflowCode) then
            exit;

        WorkflowSetup.SetCustomTemplateToken(WorkflowTemplateTokenCode);
        WorkflowSetup.InsertWorkflowTemplate(Workflow, ServiceAnouncementWorkflowCode, ServiceAnouncementWorkflowDescTxt, NotifyCategoryCode);
        InsertNotifyWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertNotifyWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowStepArgument: Record "Workflow Step Argument";
        NotifyEventLib: Codeunit "Notify Event Library WMR";
        NotifyResponseLib: Codeunit "Notify Response Library WMR";
        EnableServiceAnouncementEventID: Integer;
        CreateNotifyEntryResponseID: Integer;
        OnFirstCarryOutEventID: Integer;
        OnSecondCarryOutEventID: Integer;
        OnLastCarryOutEventID: Integer;
        OnDisableNotificationEventID: Integer;
        ShowMessageResponseID: integer;
        DeleteNotifyEntryResponseID: Integer;
        RejectAllApprovalsResponseID: Integer;
    begin
        EnableServiceAnouncementEventID := WorkflowSetup.InsertEntryPointEventStep(Workflow,
        NotifyEventLib.RunWorkflowOnSendDocumentForNotificationCode());
        WorkflowSetup.InsertEventArgument(EnableServiceAnouncementEventID, BuildDocumentHeaderCondition());
        CreateNotifyEntryResponseID := WorkflowSetup.InsertResponseStep(Workflow,
        NotifyResponseLib.CreateNotifyEntryFromWasteDocumentCode, EnableServiceAnouncementEventID);
        ShowMessageResponseID := InsertShowMessageResponse(Workflow,
        WorkflowResponseHandling.ShowMessageCode, CreateNotifyEntryResponseID, ServiceAnouncementEnabledMsg);

        OnFirstCarryOutEventID := InsertEventStep(Workflow, NotifyEventLib.RunWorkflowOnCarryOutNotifyEntryCode,
        ShowMessageResponseID, BuildFirstCarryOutConditions);
        WorkflowSetup.InsertResponseStep(Workflow, NotifyResponseLib.SendNotifyEntryViaInterfaceCode, OnFirstCarryOutEventID);


        OnSecondCarryOutEventID := InsertEventStep(Workflow, NotifyEventLib.RunWorkflowOnCarryOutNotifyEntryCode,
        ShowMessageResponseID, BuildSecondCarryOutConditions);
        WorkflowSetup.InsertResponseStep(Workflow, NotifyResponseLib.SendNotifyEntryViaInterfaceCode, OnSecondCarryOutEventID);

        OnLastCarryOutEventID := InsertEventStep(Workflow, NotifyEventLib.RunWorkflowOnCarryOutNotifyEntryCode,
        ShowMessageResponseID, BuildLastCarryOutConditions);
        WorkflowSetup.InsertResponseStep(Workflow, NotifyResponseLib.SendNotifyEntryViaInterfaceCode, OnLastCarryOutEventID);

        OnDisableNotificationEventID := InsertEventStep(Workflow, NotifyEventLib.RunWorkflowOnDisablesNotificationCode,
        ShowMessageResponseID, '');
        DeleteNotifyEntryResponseID := WorkflowSetup.InsertResponseStep(Workflow, NotifyResponseLib.DeleteNotifyEntryCode,
        OnDisableNotificationEventID);
        InsertShowMessageResponse(Workflow, WorkflowResponseHandling.ShowMessageCode, DeleteNotifyEntryResponseID,
        ServiceAnouncementDisabledMsg);
    end;

    local procedure InsertEventStep(var Workflow: Record Workflow; FunctionName: Code[128]; PreviousStepID: Integer; Condition: Text) EventID: Integer
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        EventID := WorkflowSetup.InsertEventStep(Workflow, FunctionName, PreviousStepID);
        if (Condition <> '') then
            WorkflowSetup.InsertEventArgument(EventID, Condition);
    end;

    local procedure InsertShowMessageResponse(var Workflow: Record Workflow; FunctionName: Code[128]; PreviousStepID: Integer; MessageText: Text) StepID: Integer
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        StepID := WorkflowSetup.InsertResponseStep(Workflow, FunctionName, PreviousStepID);
        InsertMessageArgument(StepID, MessageText);
    end;

    local procedure InsertMessageArgument(WorkflowStepID: Integer; Message: Text[250])
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument, WorkflowStepID);

        WorkflowStepArgument.Message := Message;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure InsertStepArgument(var WorkflowStepArgument: Record "Workflow Step Argument"; WorkflowStepID: Integer)
    var
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.SetRange(ID, WorkflowStepID);
        WorkflowStep.FindFirst;

        if WorkflowStepArgument.Get(WorkflowStep.Argument) then
            exit;

        WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
        WorkflowStepArgument.Validate("Response Function Name", WorkflowStep."Function Name");
        WorkflowStepArgument.Insert(true);

        WorkflowStep.Argument := WorkflowStepArgument.ID;
        WorkflowStep.Modify(true);
    end;


    local procedure BuildDocumentHeaderCondition(): Text
    var
        WasteHeader: Record "Waste Management Header WMR";
        WasteLine: Record "Waste Management Line WMR";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WasteHeader.SetRange("Document Type", WasteHeader."Document Type"::Order);
        exit(StrSubstNo(DocumentHeaderCondnTxt, WorkflowSetup.Encode(WasteHeader.GetView(false)), WorkflowSetup.Encode(WasteLine.GetView(false))));
    end;

    local procedure BuildFirstCarryOutConditions(): Text
    var
        NotifyEntry: Record "Notify Entry WMR";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        NotifyEntry.SetRange("No. of Messages Send", 0);
        NotifyEntry.SetFilter("Time until Expiration", '>%1', DaysToDuration(2));
        exit(StrSubstNo(NotifyEntriesCondnTxt, WorkflowSetup.Encode(NotifyEntry.GetView(false))));
    end;

    local procedure BuildSecondCarryOutConditions(): Text
    var
        NotifyEntry: Record "Notify Entry WMR";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        NotifyEntry.SetFilter("Time until Expiration", '<=%1&>%2', DaysToDuration(2), DaysToDuration(1));
        exit(StrSubstNo(NotifyEntriesCondnTxt, WorkflowSetup.Encode(NotifyEntry.GetView(false))));
    end;

    local procedure BuildLastCarryOutConditions(): Text
    var
        NotifyEntry: Record "Notify Entry WMR";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        NotifyEntry.SetFilter("Time until Expiration", '<=%1', DaysToDuration(1));
        exit(StrSubstNo(NotifyEntriesCondnTxt, WorkflowSetup.Encode(NotifyEntry.GetView(false))));
    end;

    local procedure DaysToDuration(Days: Integer): Duration
    begin
        exit(86400000 * Days);
    end;

    procedure RemoveWorkflowTemplates()
    begin
        RemoveTemplate(ServiceAnouncementWorkflowCode);
    end;

    local procedure RemoveTemplate(WorkflowCode: Code[20])
    var
        Workflow: Record Workflow;
        WorkflowStep: Record "Workflow Step";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowRule: Record "Workflow Rule";
    begin
        if not GetWorkflow(Workflow, WorkflowCode) then
            exit;
        Workflow.TestField(Template, true);

        WorkflowStep.SetRange("Workflow Code", Workflow.Code);
        if WorkflowStep.FindSet() then
            repeat
                if WorkflowStepArgument.Get(WorkflowStep.Argument) then
                    WorkflowStepArgument.Delete();

                WorkflowRule.SetRange("Workflow Code", WorkflowStep."Workflow Code");
                WorkflowRule.SetRange("Workflow Step ID", WorkflowStep.ID);
                WorkflowRule.DeleteAll();

                WorkflowStep.Delete();
            until WorkflowStep.Next() = 0;

        Workflow.Delete();
    end;

    local procedure GetWorkflow(var Workflow: Record Workflow; WorkflowCode: Code[17]): Boolean
    begin
        exit(Workflow.Get(GetWorkflowTemplateCode(WorkflowCode)));
    end;

    local procedure GetWorkflowTemplateCode(WorkflowCode: Code[17]): Code[20]
    begin
        exit(WorkflowTemplateTokenCode + WorkflowCode);
    end;

    local procedure WorkflowTemplateTokenCode(): Code[3]
    begin
        exit(UpperCase('tg-'));
    end;

    local procedure ServiceAnouncementWorkflowCode(): Code[17]
    begin
        exit(UpperCase('SAWFWMR'))
    end;

    local procedure NotifyCategoryCode(): Code[20]
    begin
        exit(UpperCase('NotifyWMR'));
    end;





}