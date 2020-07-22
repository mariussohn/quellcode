page 2020806 "Notify Entries WMR"
{

    PageType = List;
    SourceTable = "Notify Entry WMR";
    Caption = 'Notify Entries';
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {

                }
                field("Contact No."; "Contact No.")
                {

                }
                field("Message Interface"; "Message Interface")
                {

                }
                field("Expiration Date/Time"; "Expiration Date/Time")
                {

                }
                field("No. of Messages Send"; "No. of Messages Send")
                {

                }
                field("Current Step"; "Current Step")
                {

                }
                field("Time until Expiration"; "Time until Expiration")
                {

                }
                field("Order No."; "Order No.")
                {

                }
            }

        }
    }
    actions
    {

        area(Processing)
        {
            action(CarryOut)
            {
                Caption = 'Carry-out Notification';
                Visible = true;
                Image = SendMail;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    NotifyMgt: Codeunit "Notify Management WMR";
                begin
                    NotifyMgt.CarryOutNotification(Rec);
                end;
            }
            action("Disable")
            {
                Caption = 'Disable Notification';
                Image = Cancel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    NotifyMgt: Codeunit "Notify Management WMR";
                begin
                    NotifyMgt.DisableNotification(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    var
        NotifyMgt: Codeunit "Notify Management WMR";
        WasteHeader: Record "Waste Management Header WMR";
        IsWorkflowEnabled: Boolean;
        EventLib: Codeunit "Notify Event Library WMR";

        sendSMS: Codeunit "Notify SMS Interface WMR";

    trigger OnOpenPage()
    var
        Entry: Record "Notify Entry WMR";
        NotifyManagement: Codeunit "Notify Management WMR";
    begin
        if not Entry.IsEmpty then begin
            if Entry.FindSet(true, false) then
                repeat

                    Entry."Time until Expiration" := Entry."Expiration Date/Time" - System.CurrentDateTime;
                    Entry.Modify;

                    if Entry."Time until Expiration" < 0 then begin
                        Entry.Delete();
                    end;
                    if Entry."No. of Messages Send" > 2 then begin
                        Entry.Delete();
                    end;
                until Entry.Next = 0;
        end;
    end;

}
