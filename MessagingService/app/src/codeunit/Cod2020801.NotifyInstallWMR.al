codeunit 2020801 "Notify Install WMR"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Workflow: Record Workflow;
        NotifyWorkflowMgt: Codeunit "Notify Workflow Mgt. WMR";
    begin
        RecreateLibraries;

        Workflow.SetRange(Template, true);
        if not Workflow.IsEmpty then begin
            NotifyWorkflowMgt.RemoveWorkflowTemplates();
            NotifyWorkflowMgt.InitWorkflowModule();
        end;
    end;

    local procedure RecreateLibraries()
    var
        WFEvent: Record "Workflow Event";
        WFResponse: Record "Workflow Response";
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowTableRelation: Record "Workflow - Table Relation";
    begin
        WFEvent.DeleteAll(true);
        WFResponse.DeleteAll(true);

        WorkflowSetup.InitWorkflow;

        WorkflowTableRelation.SetRange("Table ID", 2020805);
        WorkflowTableRelation.DeleteAll();
        WorkflowTableRelation.Reset();
        WorkflowTableRelation.SetRange("Related Table ID", 2020805);
        WorkflowTableRelation.DeleteAll();
    end;

}