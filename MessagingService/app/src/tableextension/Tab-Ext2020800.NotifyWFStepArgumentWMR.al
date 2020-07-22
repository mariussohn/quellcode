tableextension 2020800 "Notify WF Step Argument WMR" extends "Workflow Step Argument"
{
    fields
    {
        field(2020800; NotifyMessageTextWMR; Text[500])
        {
            Caption = 'Message';
            TableRelation = "Notify Templates WMR".Text;
        }
    }

}