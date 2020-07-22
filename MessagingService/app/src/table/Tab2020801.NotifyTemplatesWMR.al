table 2020801 "Notify Templates WMR"
{
    DataClassification = ToBeClassified;
    Caption = 'Notify Templates';
    DrillDownPageID = "Notify Templates List WMR";
    LookupPageID = "Notify Templates List WMR";
    fields
    {
        field(1; "Id"; Integer)
        {
            Caption = 'Id';
            AutoIncrement = true;
            Editable = false;
        }
        field(10; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(20; "Text"; Text[500])
        {
            Caption = 'Text';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Text)
        {
        }
    }
}