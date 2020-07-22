tableextension 2020805 "NotifyForWasteMgtHeaderWMR" extends "Waste Management Header WMR"
{
    fields
    {
        modify("Business-with No.")
        {
            trigger OnBeforeValidate()
            begin
                PopulateNotifyFields();
            end;
        }
        modify("Task Site No.")
        {
            trigger OnBeforeValidate()
            begin
                PopulateNotifyFields();
            end;
        }
        field(2020800; "ActivateNotification"; Boolean)
        {
            Caption = 'Activate Notification';
            InitValue = false;

        }
        field(2020801; "NotifyInterface"; Enum "Notify Interface WMR")
        {
            Caption = 'Notification Interface';

        }
        field(2020803; NotifyContactNo; Code[20])
        {
            Caption = 'Contract No. (Notification)';
            TableRelation = Contact."No.";
        }
    }
    procedure SendNotifyRequest()
    var
        NotifyMgt: Codeunit "Notify Management WMR";
    begin
        if NotifyMgt.CheckDocumentNotifyPossible(Rec) then
            NotifyMgt.SendDocumentForNotify(Rec);
    end;

    local procedure PopulateNotifyFields()
    var
        BusPartner: Record "Business Partner WMR";
        TaskSite: Record "Task Site WMR";
    begin
        If "Task Site No." <> '' then begin
            TaskSite.Get("Task Site No.");
            if TaskSite.NotifyContactNo <> '' then begin
                NotifyContactNo := TaskSite.NotifyContactNo;
                NotifyInterface := TaskSite.NotifyInterface;
                exit;
            end;
        end;

        if "Business-with No." <> '' then begin
            BusPartner.Get("Business-with No.");
            if BusPartner.NotifyContactNo <> '' then begin
                NotifyContactNo := BusPartner.NotifyContactNo;
                NotifyInterface := BusPartner.NotifyInterface;
            end;
        end;
    end;

    trigger OnModify()
    begin



    end;
}