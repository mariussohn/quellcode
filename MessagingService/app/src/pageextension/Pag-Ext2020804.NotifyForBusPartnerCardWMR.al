pageextension 2020804 "NotifyForBusPartnerCardWMR" extends "Business Partner Card WMR"
{
    layout
    {
        addlast(content)
        {
            group(NotifyWMR)
            {
                Caption = 'enwis.Notify';
                field(NotifyContactNo; NotifyContactNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a Contact that will be informed by the enwis.Notify functionality';
                }
                field(NotifyInterface; NotifyInterface)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default comunication interface which is used by the enwis.Notify functionality.';
                }
            }
        }
    }
}