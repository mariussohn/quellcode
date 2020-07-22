page 2020804 "Notify Placeholder Card WMR"
{
    PageType = Card;
    SourceTable = "Notify Placeholder WMR";
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Notify Placeholder Card';

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
                }
            }

        }
    }
}
