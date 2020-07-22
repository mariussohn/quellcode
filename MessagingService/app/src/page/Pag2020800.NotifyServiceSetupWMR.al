page 2020800 "Notify Service Setup WMR"
{
    PageType = Card;
    SourceTable = "Notify Service Setup WMR";
    Caption = 'Notify Service Setup';
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
    ShowFilter = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Username"; "Username")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field(Password; Password)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Password';
                    Editable = EditableByNotEnabled;
                    ExtendedDatatype = Masked;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the password that is used for your company''s login to the Notify service.';

                    trigger OnValidate()
                    begin
                        Rec.SavePassword("Password Key", Password);
                        if Password <> '' then
                            CheckEncryption;
                    end;
                }
                field(AuthorizationKey; AuthorizationKey)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Authorization Key';
                    Editable = EditableByNotEnabled;
                    ExtendedDatatype = Masked;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the authorization key that is used for your company''s login to the OCR service.';

                    trigger OnValidate()
                    begin
                        SavePassword("Authentication Token Key", AuthorizationKey);
                        if AuthorizationKey <> '' then
                            CheckEncryption;
                    end;
                }
                field("Enabled"; "Enabled")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    var
                        entry: Record "Notify Entry WMR";
                    begin
                        UpdateBasedOnEnable();

                        if Enabled = false then begin
                            if entry.FindSet(true, false) then
                                repeat
                                    if entry.Get() then
                                        entry.DeleteAll();

                                until entry.Next() = 0;
                        end
                        else begin
                            exit;
                        end;
                    end;

                }
            }
            group(Service)
            {
                Caption = 'Service';

                field("Service URL"; "Service URL")
                {
                    ApplicationArea = Basic, Suite;

                    Editable = true;

                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Generate Token")
            {
                Image = Change;
                Visible = true;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()

                var
                    NotifyServiceSetup: Codeunit "Notify Service Setup WMR";
                begin
                    CurrPage.SaveRecord();
                    NotifyServiceSetup.sendPostRequest();
                end;
            }
            action(TestSendMessage)
            {
                Visible = true;
                Image = Alerts;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SendSMS: Codeunit "Notify SMS Interface WMR";
                    notifyEntry: Record "Notify Entry WMR";
                begin
                    SendSMS.SendNotify('4915252415889', 'Hallo Tegos da');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateBasedOnEnable();
        UpdateEncryptedField("Password Key", Password);
        UpdateEncryptedField("Authentication Token Key", AuthorizationKey);
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert(true);
        end;
        UpdateBasedOnEnable();
    end;

    var
        Password: Text[50];
        AuthorizationKey: Text[50];
        EditableByNotEnabled: Boolean;
        CheckedEncryption: Boolean;
        EncryptionIsNotActivatedQst: Label 'Data encryption is not activated. It is recommended that you encrypt data. \Do you want to open the Data Encryption Management window?';


    local procedure UpdateBasedOnEnable()
    begin
        EditableByNotEnabled := (not Enabled) and CurrPage.Editable;
    end;

    local procedure UpdateEncryptedField(InputGUID: Guid; var Text: Text[50])
    begin
        if IsNullGuid(InputGUID) then
            Text := ''
        else
            Text := '*************';
    end;

    local procedure CheckEncryption()
    begin
        if not CheckedEncryption and not EncryptionEnabled then begin
            CheckedEncryption := true;
            if not EncryptionEnabled then
                if Confirm(EncryptionIsNotActivatedQst) then
                    PAGE.Run(PAGE::"Data Encryption Management");
        end;
    end;
}
