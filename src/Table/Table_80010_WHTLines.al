/// <summary>
/// Table NCT WHT Line (ID 80010).
/// </summary>
table 80010 "NCT WHT Line"
{
    Caption = 'WHT Line';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "WHT No."; Code[20])
        {
            Caption = 'WHT No.';
            DataClassification = SystemMetadata;

        }
        field(2; "WHT Line No."; Integer)
        {
            Caption = 'WHT Line No.';
            DataClassification = SystemMetadata;

        }
        field(3; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Code';
            TableRelation = "NCT WHT Business Posting Group";
            DataClassification = CustomerContent;
        }
        field(4; "WHT Certificate No."; Code[20])
        {
            Caption = 'WHT Certificate No.';
            DataClassification = SystemMetadata;
        }
        field(5; "WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = SystemMetadata;

        }
        field(6; "WHT Source Type"; Option)
        {
            OptionMembers = Vendor,Customer;
            OptionCaption = 'Vendor,Customer';
            Caption = 'WHT Source Type';
            DataClassification = SystemMetadata;
        }
        field(7; "WHT Source No."; Code[20])
        {
            Caption = 'WHT Source No.';
            TableRelation = IF ("WHT Source Type" = CONST(Vendor)) Vendor else
            IF ("WHT Source Type" = CONST(Customer)) Customer;
            DataClassification = SystemMetadata;

        }
        field(8; "WHT Name"; Text[160])
        {
            Caption = 'WHT Name';
            DataClassification = SystemMetadata;
        }
        field(9; "WHT Name 2"; Text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = SystemMetadata;
        }
        field(10; "WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = SystemMetadata;
        }
        field(11; "WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = SystemMetadata;
        }
        field(12; "WHT Address 3"; Text[50])
        {
            Caption = 'WHT Address 3';
            DataClassification = SystemMetadata;
        }
        field(13; "WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = SystemMetadata;
        }
        field(14; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = SystemMetadata;
        }
        field(15; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "Vat Branch Code" := '';
            end;
        }
        field(16; "VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = SystemMetadata;
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
        field(17; "Gen. Journal Template Code"; Code[20])
        {
            Caption = 'Gen. Journal Template Code';
            DataClassification = SystemMetadata;
        }
        field(18; "Gen. Journal Batch Code"; Code[20])
        {
            Caption = 'Gen. Journal Batch Code';
            DataClassification = SystemMetadata;
        }
        field(19; "Gen. Journal Line No."; Integer)
        {
            Caption = 'Gen. Journal Line No.';
            DataClassification = SystemMetadata;
        }
        field(20; "Gen. Journal Document No."; Code[20])
        {
            Caption = 'Gen. Journal Document No.';
            DataClassification = SystemMetadata;
        }
        field(21; "WHT Type"; Enum "NCT WHT Type")
        {

            Caption = 'WHT Type';
            DataClassification = SystemMetadata;

        }
        field(22; "WHT Product Posting Group"; Code[20])
        {
            TableRelation = "NCT WHT Product Posting Group";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                WHTSetup: Record "NCT WHT Posting Setup";
            begin
                GetWhtHeader();
                TransferFromHeader();
                IF NOT WHTSetup.GET("WHT Business Posting Group", "WHT Product Posting Group") THEN
                    WHTSetup.init();
                rec."WHT %" := WHTSetup."WHT %";

            end;
        }
        field(23; "WHT Option"; Enum "NCT WHT Option")
        {

            Caption = 'WHT Option';
            DataClassification = SystemMetadata;
        }
        field(24; "WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "WHT Amount" := ROUND("WHT Base" * "WHT %" / 100, 0.01);
            end;
        }
        field(25; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = SystemMetadata;
            Editable = false;
            trigger OnValidate()
            begin
                "GetWhtHeader"();

            end;
        }
        field(26; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "GetWhtHeader"();

            end;

        }
        field(27; "Vat No."; Code[20])
        {
            Caption = 'Vat No.';
            DataClassification = SystemMetadata;

        }
        field(28; "Posted"; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(29; "WHT Post Code"; Text[30])
        {
            Caption = 'WHT Post Code';
            DataClassification = SystemMetadata;

        }
        field(30; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(31; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
            DataClassification = SystemMetadata;
        }
        field(32; "Get to WHT"; Boolean)
        {
            Caption = 'Get to WHT';
            DataClassification = SystemMetadata;
        }

    }
    keys
    {
        key(PK; "WHT No.", "WHT Line No.")
        {
            Clustered = true;
            SumIndexFields = "WHT Base", "WHT Amount";

        }


    }
    /// <summary> 
    /// Description for GetWhtHeader.
    /// </summary>
    local procedure "GetWhtHeader"()
    var
        WhtHeader: Record "NCT WHT Header";
    begin
        if not WhtHeader.get("WHT No.") then
            WhtHeader.init();
        WhtHeader.TestField("WHT Certificate No.");
    end;

    /// <summary> 
    /// Description for TransferFromHeader.
    /// </summary>
    procedure TransferFromHeader()
    var
        WhtHeader: Record "NCT WHT Header";
    begin
        if not WhtHeader.get("WHT No.") then
            WhtHeader.Init();
        "WHT Business Posting Group" := WHTHeader."WHT Business Posting Group";
        "WHT Certificate No." := WHTHeader."WHT Certificate No.";
        "WHT Date" := WHTHeader."WHT Date";
        "WHT Source Type" := WHTHeader."WHT Source Type";
        "WHT Source No." := WHTHeader."WHT Source No.";
        "WHT Name" := WHTHeader."WHT Name";
        "WHT Name 2" := WHTHeader."WHT Name 2";
        "WHT Address" := WHTHeader."WHT Address";
        "WHT Address 2" := WHTHeader."WHT Address 2";
        "WHT City" := WHTHeader."WHT City";
        "WHT Post Code" := WHTHeader."WHT Post Code";
        "VAT Registration No." := WHTHeader."VAT Registration No.";
        "Head Office" := WhtHeader."Head Office";
        "Vat Branch Code" := WHTHeader."Vat Branch Code";
        "Gen. Journal Template Code" := WHTHeader."Gen. Journal Template Code";
        "Gen. Journal Batch Code" := WHTHeader."Gen. Journal Batch Code";
        "Gen. Journal Line No." := WHTHeader."Gen. Journal Line No.";
        "Gen. Journal Document No." := WHTHeader."Gen. Journal Document No.";
        "WHT Type" := WHTHeader."WHT Type";
        "WHT Option" := WHTHeader."WHT Option";
        OnafterTransferFomHeader(WhtHeader, rec)
    end;


    [IntegrationEvent(true, false)]

    procedure OnafterTransferFomHeader(WHTHeader: Record "NCT WHT Header"; var WhtLine: Record "NCT WHT Line")
    begin

    end;

}