page 2020803 "Notify Template Card WMR"
{
    PageType = Card;
    SourceTable = "Notify Templates WMR";
    RefreshOnActivate = true;
    Caption = 'Notify Template Card';
    Editable = true;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Id"; "Id")
                {
                    Editable = false;
                }
                field("Description"; Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(MessageText)
            {
                Caption = 'Message Text';

                field("Text"; "Text")
                {
                    MultiLine = true;
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(FactBoxes)
        {
            part(Placeholder; "Notify Placeholder WMR")
            {
                ApplicationArea = All;

            }
        }
    }
}




