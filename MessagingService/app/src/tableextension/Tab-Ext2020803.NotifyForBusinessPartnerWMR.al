tableextension 2020803 "NotifyForBusinessPartnerWMR" extends "Business Partner WMR"
{
    fields
    {
        field(2020800; NotifyContactNo; Code[20])
        {
            Caption = 'Contract No. (Notification)';
            TableRelation = Contact."No.";
        }
        field(2020801; "NotifyInterface"; Enum "Notify Interface WMR")
        {
            Caption = 'Notification Interface';
        }
    }
}