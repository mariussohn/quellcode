page 2020801 "Notify Templates List WMR"
{
    PageType = List;
    SourceTable = "Notify Templates WMR";
    Caption = 'Notify Templates';
    CardPageID = "Notify Template Card WMR";
    Editable = false;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Id"; "Id")
                {
                    Editable = false;
                }
                field("Beschreibung"; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '';
                }
            }
        }
    }
}
