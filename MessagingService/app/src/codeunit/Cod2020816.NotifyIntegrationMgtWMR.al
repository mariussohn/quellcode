codeunit 2020816 "Notify Integration Mgt. WMR"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        NotifyEventLib: Codeunit "Notify Event Library WMR";
    begin
        NotifyEventLib.CreateEventsLibrary();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        NotifyEventLib: Codeunit "Notify Event Library WMR";
    begin
        NotifyEventLib.AddEventPredecessors(EventFunctionName);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, false)]
    local procedure OnAddWorkflowResponsesToLibrary()
    var
        NotifyResponseLib: Codeunit "Notify Response Library WMR";
    begin
        NotifyResponseLib.CreateResponsesLibrary();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        NotifyResponseLib: Codeunit "Notify Response Library WMR";
    begin
        NotifyResponseLib.AddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, false)]
    local procedure OnExecuteWorkflowResponse(var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        NotifyResponseLib: Codeunit "Notify Response Library WMR";
    begin
        NotifyResponseLib.ExecuteWorkflowResponse(ResponseExecuted, Variant, xVariant, ResponseWorkflowStepInstance)
    end;

}