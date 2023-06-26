/// <summary>
/// Table NCT WHT Header (ID 80009).
/// </summary>
table 80009 "NCT WHT Header"
{
    Caption = 'WHT Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "WHT No."; Code[20])
        {
            Caption = 'WHT No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "NCT WHT Business Posting Group";

        }
        field(3; "WHT Certificate No."; Code[20])
        {
            Caption = 'WHT Certificate No';
            DataClassification = CustomerContent;
        }
        field(4; "WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(5; "WHT Source Type"; Option)
        {
            OptionMembers = Vendor,Customer;
            OptionCaption = 'Vendor,Customer';
            Caption = 'WHT Source Type';
            DataClassification = CustomerContent;

        }
        field(6; "WHT Source No."; Code[20])
        {
            Caption = 'WHT Source No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("WHT Source Type" = CONST(Vendor)) Vendor else
            IF ("WHT Source Type" = CONST(Customer)) Customer;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
                Customer: Record Customer;
                whtBusPostingGroup: Record "NCT WHT Business Posting Group";
            begin
                IF "WHT Source Type" = "WHT Source Type"::Vendor THEN BEGIN
                    IF Vendor.GET("WHT Source No.") THEN BEGIN
                        "WHT Source No." := Vendor."No.";
                        "WHT Name" := Vendor.Name;
                        "WHT Name 2" := Vendor."Name 2";
                        "WHT Address" := Vendor.Address;
                        "WHT Address 2" := Vendor."Address 2";
                        "VAT Registration No." := Vendor."VAT Registration No.";
                        "Head Office" := Vendor."NCT Head Office";
                        "Vat Branch Code" := Vendor."NCT Branch Code";
                        "WHT Business Posting Group" := Vendor."WHT Business Posting Group";
                        if NOT whtBusPostingGroup.GET(Vendor."WHT Business Posting Group") then
                            whtBusPostingGroup.init();
                        "WHT Type" := whtBusPostingGroup."WHT Type";
                        "WHT City" := Vendor.City;
                        "WHT Post Code" := Vendor."Post Code";
                    END;
                END ELSE
                    IF Customer.GET("WHT Source No.") THEN BEGIN
                        "WHT Source No." := Customer."No.";
                        "WHT Name" := Customer.Name;
                        "WHT Name 2" := Customer."Name 2";
                        "WHT Address" := Customer.Address;
                        "WHT Address 2" := Customer."Address 2";
                        "VAT Registration No." := Customer."VAT Registration No.";
                        "Head Office" := Customer."NCT Head Office";
                        "Vat Branch Code" := Customer."NCT Branch Code";
                        "WHT Business Posting Group" := Customer."WHT Business Posting Group";
                        if NOT whtBusPostingGroup.GET(Customer."WHT Business Posting Group") then
                            whtBusPostingGroup.init();
                        "WHT Type" := whtBusPostingGroup."WHT Type";
                        "WHT City" := Customer.City;
                        "WHT Post Code" := Customer."Post Code";
                    END;

            end;
        }
        field(7; "WHT Name"; Text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(8; "WHT Name 2"; Text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(9; "WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(10; "WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(11; "WHT Address 3"; Text[50])
        {
            Caption = 'WHT Address 3';
            DataClassification = CustomerContent;
        }
        field(12; "WHT City"; Text[30])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(13; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(14; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "Vat Branch Code" := '';
            end;
        }
        field(15; "VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("WHT Source Type" = CONST(Vendor)) "NCT Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = FILTER(Vendor), "Source No." = FIELD("WHT Source No.")) ELSE
            IF ("WHT Source Type" = CONST(Customer)) "NCT Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = FILTER(Customer), "Source No." = FIELD("WHT Source No."));
            ValidateTableRelation = true;
            trigger OnValidate()
            begin
                if "Vat Branch Code" <> '' then begin
                    if StrLen("Vat Branch Code") < 5 then
                        Error('Branch Code must be 5 characters');
                    "Head Office" := false;
                end;
                if "Vat Branch Code" = '00000' then begin
                    "Head Office" := TRUE;
                    "Vat Branch Code" := '';
                end;
            end;

        }
        field(16; "Gen. Journal Template Code"; Code[10])
        {
            Caption = 'Gen. Journal Template Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Gen. Journal Batch Code"; Code[10])
        {
            Caption = 'Gen. Journal Batch Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(18; "Gen. Journal Line No."; Integer)
        {
            Caption = 'Gen. Journal Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "Gen. Journal Document No."; Code[20])
        {
            Caption = 'Gen. Journal Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "WHT Type"; Enum "NCT WHT Type")
        {
            Caption = 'WHT Type';
            DataClassification = CustomerContent;

        }
        field(21; "WHT Option"; Enum "NCT WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(22; "WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("NCT WHT Line"."WHT Base" where("WHT No." = field("WHT No.")));

        }
        field(23; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("NCT WHT Line"."WHT Amount" where("WHT No." = field("WHT No.")));

        }
        field(24; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = SystemMetadata;
        }
        field(25; "Posted"; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(26; "Wht Post Code"; Text[20])
        {
            Caption = 'Wht Post Code';
            DataClassification = CustomerContent;

        }
        field(27; "Get to WHT"; Boolean)
        {
            Caption = 'Get to WHT';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "WHT No.")
        {
            Clustered = true;
        }
    }
    /// <summary> 
    /// Description for AssistEditCertificate.
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    procedure AssistEditCertificate(): Boolean
    var

        WHTBus: Record "NCT WHT Business Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewSeries: Code[20];
    begin

        WHTBus.GET("WHT Business Posting Group");
        WHTBus.TESTFIELD("WHT Certificate No. Series");
        IF NoSeriesMgt.SelectSeries(WHTBus."WHT Certificate No. Series", "No. Series", NewSeries) THEN
            "WHT Certificate No." := NoSeriesMgt.GetNextNo(NewSeries, Today, TRUE);

    end;


    /// <summary> 
    /// Description for SetWHT.
    /// </summary>
    /// <param name="GenLine">Parameter of type Record "Gen. Journal Line".</param>
    procedure "SetWHT"(GenLine: Record "Gen. Journal Line")
    begin
        Genlines.reset();
        Genlines.copy(GenLine);
        Genlines.FindFirst();
    end;

    trigger OnDelete()
    var
        WHTLine: Record "NCT WHT Line";
        ltGenJournalLine: Record "Gen. Journal Line";
    begin

        WHTLine.RESET();
        WHTLine.SETRANGE("WHT No.", "WHT No.");
        IF WHTLine.FindFirst() THEN
            WHTLine.DELETEALL(TRUE);
        if ltGenJournalLine.GET(rec."Gen. Journal Template Code", rec."Gen. Journal Batch Code", rec."Gen. Journal Line No.") then
            ltGenJournalLine.Delete(true);
    end;

    var
        Genlines: Record "Gen. Journal Line";
}
