/// <summary>
/// TableExtension NCT FixedAsset (ID 80044) extends Record Fixed Asset.
/// </summary>
tableextension 80044 "NCT FixedAsset" extends "Fixed Asset"
{
    fields
    {
        field(80000; "NCT WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "NCT WHT Product Posting Group";
        }
        field(80001; "NCT Purchase Order No."; Code[30])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Purchase Invoice No."; Code[30])
        {
            Caption = 'Purchase Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80003; "NCT Tax Invoice No."; Code[30])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT Sale Invoice No."; Code[30])
        {
            Caption = 'Sale Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT Price Exclude Vat"; Decimal)
        {
            Caption = 'Price Exclude Vat';
            DataClassification = CustomerContent;

        }
        field(80006; "NCT Acq. Date"; Code[30])
        {
            Caption = 'Acq. Date';
            DataClassification = CustomerContent;
        }
        field(80007; "NCT Ref. Image Entry No."; Integer)
        {
            Caption = 'Ref. Image Entry No.';
            DataClassification = CustomerContent;
        }

        field(80008; "NCT Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(80009; "NCT Price per Unit"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price per Unit';
        }
        field(80010; "NCT Remark Real Location"; Text[250])
        {

            //  CalcFormula = lookup ("FA Location"."Location Detail" where(Code = field("FA Location Code")));
            DataClassification = CustomerContent;
            Caption = 'Remark Real Location';
        }
        modify("FA Location Code")
        {
            trigger OnAfterValidate()
            var
                Falocation: Record "FA Location";
            begin
                if not Falocation.GET("FA Location Code") then
                    Falocation.init();
                "NCT Remark Real Location" := Falocation."NCT Location Detail";
            end;
        }
        modify("FA Subclass Code")
        {
            trigger OnAfterValidate()
            var
                FASubclass: Record "FA Subclass";
            begin
                if FASubclass.get("FA Subclass Code") then
                    IF FASubclass."Default FA Posting Group" <> '' THEN
                        VALIDATE("FA Posting Group", FASubclass."Default FA Posting Group");
            end;
        }
    }
}