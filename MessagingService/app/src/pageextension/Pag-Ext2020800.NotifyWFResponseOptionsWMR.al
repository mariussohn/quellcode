pageextension 2020800 "Notify WF Response Options WMR" extends "Workflow Response Options"
{
    layout
    {
        addlast(Control5)
        {
            group(NotifySendEntryWMR)
            {
                ShowCaption = false;
                Visible = "Response Option Group" = 'GROUP 2020800';
                field(NotifyMessageFieldWMR; NotifyMessageTextWMR)
                {
                    ApplicationArea = Suite;
                    Caption = 'Message';
                    ToolTip = 'Specifies the message that will be send via interface.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true)
                    end;
                }
            }

        }
    }
}