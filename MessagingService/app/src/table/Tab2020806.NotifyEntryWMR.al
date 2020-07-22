table 2020806 "Notify Entry WMR"
{
    Caption = 'Notify Entry';
    LookupPageId = "Notify Entries WMR";
    DrillDownPageId = "Notify Entries WMR";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(10; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact."No.";
        }
        field(20; "Message Interface"; Enum "Notify Interface WMR")
        {
            Caption = 'Message Interface';
        }
        field(30; "Expiration Date/Time"; DateTime)
        {
            Caption = 'Expiration Date/Time';
        }

        field(32; "No. of Messages Send"; Integer)
        {
            Caption = 'No. of Messages Send';
            BlankZero = false;
            MinValue = 0;
            Editable = false;
        }
        field(33; "Time until Expiration"; Duration)
        {
            Caption = 'Time until Expiration';
            Editable = false;
        }
        field(40; "Source Record ID"; RecordID)
        {
            Caption = 'Source Record ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(41; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(50; "Workflow Step Instance ID"; Guid)
        {
            Caption = 'Workflow Step Instance ID';
        }
        field(60; "Current Step"; Option)
        {
            Caption = 'Current Step';
            OptionMembers = "order confirmation","memory","memory at task date","delay","finished";
            OptionCaption = '"order confirmation","memory","memory at task date","delay","finished"';
        }
        field(70; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Waste Management Header WMR"."No.";
        }


    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        ExpiresBeforeStartErr: Label '%1 must be later than %2.', Comment = '%1 = Expiration Date, %2=Start date';

    [TryFunction]
    procedure GetBySourceRecord(SourceRecord: Variant)
    var
        RecRef: RecordRef;
        DataTypeMgt: Codeunit "Data Type Management";
        NotifyEntry: Record "Notify Entry WMR";
        TempNotifyEntry: Record "Notify Entry WMR" temporary;
    begin
        DataTypeMgt.GetRecordRef(SourceRecord, RecRef);
        if not IsTemporary then begin
            NotifyEntry.SetRange("Source Record ID", RecRef.RecordId);
            NotifyEntry.FindFirst();
            Rec := NotifyEntry;
        end else begin
            TempNotifyEntry.Copy(Rec, true);
            TempNotifyEntry.Reset;
            TempNotifyEntry.SetRange("Source Record ID", RecRef.RecordId);
            TempNotifyEntry.FindFirst();
            Rec := TempNotifyEntry;
        end;
    end;


    local procedure LookupDateTime(InitDateTime: DateTime; EarliestDateTime: DateTime; LatestDateTime: DateTime): DateTime
    var
        DateTimeDialog: Page "Date-Time Dialog";
        NewDateTime: DateTime;
    begin
        NewDateTime := InitDateTime;
        if InitDateTime < EarliestDateTime then
            InitDateTime := EarliestDateTime;
        if (LatestDateTime <> 0DT) and (InitDateTime > LatestDateTime) then
            InitDateTime := LatestDateTime;

        DateTimeDialog.SetDateTime(RoundDateTime(InitDateTime, 1000));

        if DateTimeDialog.RunModal = ACTION::OK then
            NewDateTime := DateTimeDialog.GetDateTime;
        exit(NewDateTime);
    end;

    procedure IsExpired(AtDateTime: DateTime): Boolean
    begin
        exit((AtDateTime <> 0DT) and ("Expiration Date/Time" <> 0DT) and ("Expiration Date/Time" < AtDateTime));
    end;


}