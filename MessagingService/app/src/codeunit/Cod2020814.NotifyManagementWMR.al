codeunit 2020814 "Notify Management WMR"
{
    var
        NoWorkflowEnabledErr: Label 'No notify workflow for this document is enabled.';

    procedure CheckDocumentNotifyPossible(var WasteHeader: Record "Waste Management Header WMR"): Boolean
    begin
        if not IsDocumentNotifyWorkflowEnabled(WasteHeader) then
            Error(NoWorkflowEnabledErr);

        exit(true)
    end;

    procedure IsDocumentNotifyWorkflowEnabled(var WasteHeader: Record "Waste Management Header WMR"): Boolean
    var
        NotifyWorkflowMgt: Codeunit "Notify Event Library WMR";
    begin
        exit(NotifyWorkflowMgt.CanExecuteNotifyWorkflow(WasteHeader));
    end;

    procedure SendDocumentForNotify(var WasteHeader: Record "Waste Management Header WMR")
    var
        NotifyWorkflowMgt: Codeunit "Notify Event Library WMR";
    begin
        NotifyWorkflowMgt.ExecuteNotifyWorkflow(WasteHeader);
    end;

    procedure CarryOutNotification(var NotifyEntry: Record "Notify Entry WMR")
    var
        NotifyWorkflowMgt: Codeunit "Notify Event Library WMR";
    begin
        NotifyEntry."Time until Expiration" := NotifyEntry."Expiration Date/Time" - System.CurrentDateTime;
        NotifyEntry.Modify();

        NotifyWorkflowMgt.ExecuteNotification(NotifyEntry);
    end;

    procedure DisableNotification(Rec: Variant)
    var
        DataTypeMgt: Codeunit "Data Type Management";
        NotifyWorkflowMgt: Codeunit "Notify Event Library WMR";
        RecRef: RecordRef;
        NotifyEntry: Record "Notify Entry WMR";
    begin
        DataTypeMgt.GetRecordRef(Rec, RecRef);
        if RecRef.Number = Database::"Notify Entry WMR" then
            RecRef.SetTable(NotifyEntry)
        else
            NotifyEntry.GetBySourceRecord(Rec);

        NotifyWorkflowMgt.ExecuteDisableNotification(NotifyEntry);
    end;

}