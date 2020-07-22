pageextension 2020805 "NotifyForTaskSiteCardWMR" extends "Task Site Card WMR"
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