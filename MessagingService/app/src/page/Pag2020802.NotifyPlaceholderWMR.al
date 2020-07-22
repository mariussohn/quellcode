page 2020802 "Notify Placeholder WMR"
{
    PageType = ListPart;
    Caption = 'Notify Placeholders';
    SourceTable = "Notify Placeholder WMR";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            repeater("Placeholder for WhatsApp Messaging")
            {
                ShowCaption = false;
                field("Placeholder"; "Placeholder")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Beschreibung"; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '';
                }
            }

        }
    }

    trigger OnOpenPage()
    begin
        //InsertIfNotExists();
    end;

}
