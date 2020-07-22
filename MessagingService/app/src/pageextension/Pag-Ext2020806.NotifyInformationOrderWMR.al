pageextension 2020806 "NotifyInformationOrderWMR" extends "Waste Mgt. Order WMR"
{
    layout
    {
        addlast(content)
        {
            group("Sending Notifications")
            {
                field("Activate Notification"; "ActivateNotification")
                {
                    ApplicationArea = all;

                    Editable = true;

                    trigger OnValidate()
                    var
                        NotifyManagement: Codeunit "Notify Management WMR";
                    begin
                        if ActivateNotification = true then begin
                            SendNotifyRequest();
                        end
                        else begin
                            NotifyManagement.DisableNotification(Rec)
                        end;

                    end;

                }
                field(NotifyContactNo; NotifyContactNo)
                {
                    ApplicationArea = all;
                }
                field("NotifyInterface"; "NotifyInterface")
                {

                }
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action(NotifyEnableNotification)
            {
                Caption = 'Enable Notification';
                Visible = true;
                Image = Alerts;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SendNotifyRequest();
                end;
            }
        }
    }

    var
        myInt: Integer;

}