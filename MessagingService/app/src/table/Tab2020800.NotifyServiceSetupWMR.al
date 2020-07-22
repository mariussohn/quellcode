table 2020800 "Notify Service Setup WMR"
{
    DataClassification = ToBeClassified;
    Caption = 'Notify Service Setup';
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(10; "Username"; Text[50])
        {
            Caption = 'Username';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; "Password Key"; Guid)
        {
            Caption = 'Password';
        }
        field(12; "Authentication Token Key"; Guid)
        {
            Editable = false;
            Caption = 'Authentication Token';
        }
        field(14; "Service URL"; Text[250])
        {
            Caption = 'Service-URL';
            ExtendedDatatype = URL;

            trigger OnValidate()
            var
                HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
            begin
                if "Service URL" = '' then
                    exit;
            end;
        }
        field(15; "Enabled"; Boolean)
        {
            Caption = 'Enabled';

        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    procedure SavePassword(var PasswordKey: Guid; PasswordText: Text)
    var
        IsolatedStorageManagement: Codeunit "Isolated Storage Management";
    begin
        if IsNullGuid(PasswordKey) then begin
            PasswordKey := CreateGuid;
            Modify;
        end;

        IsolatedStorageManagement.Set(PasswordKey, PasswordText, DATASCOPE::Company);
    end;

    procedure GetPassword(PasswordKey: Guid): Text
    var
        IsolatedStorageManagement: Codeunit "Isolated Storage Management";
        Value: Text;
    begin
        IsolatedStorageManagement.Get(PasswordKey, DATASCOPE::Company, Value);
        exit(Value);
    end;

    procedure GetToken(Token: Guid): Text
    var
        IsolatedStorageManagement: Codeunit "Isolated Storage Management";
        Value: Text;
    begin
        IsolatedStorageManagement.Get(Token, DATASCOPE::Company, Value);
        exit(Value);
    end;

    local procedure DeletePassword(PasswordKey: Guid)
    var
        IsolatedStorageManagement: Codeunit "Isolated Storage Management";
    begin
        IsolatedStorageManagement.Delete(PasswordKey, DATASCOPE::Company);
    end;

    procedure HasPassword(PasswordKey: Guid): Boolean
    var
        IsolatedStorageManagement: Codeunit "Isolated Storage Management";
        Value: Text;
    begin
        IsolatedStorageManagement.Get(PasswordKey, DATASCOPE::Company, Value);
        exit(Value <> '');
    end;
}