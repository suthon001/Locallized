tableextension 80044 "FixedAsset" extends "Fixed Asset"
{
    fields
    {
        field(80000; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "WHT Product Posting Group";
        }
        field(80001; "Purchase Order No."; Code[30])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
        }
        field(80002; "Purchase Invoice No."; Code[30])
        {
            Caption = 'Purchase Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80003; "Tax Invoice No."; Code[30])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80004; "Sale Invoice No."; Code[30])
        {
            Caption = 'Sale Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80005; "Price Exclude Vat"; Decimal)
        {
            Caption = 'Price Exclude Vat';
            DataClassification = CustomerContent;

        }
        field(80006; "Acq. Date"; Code[30])
        {
            Caption = 'Acq. Date';
            DataClassification = CustomerContent;
        }
        field(80007; "Ref. Image Entry No."; Integer)
        {
            Caption = 'Ref. Image Entry No.';
            DataClassification = CustomerContent;
        }

        field(80008; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(80009; "Price per Unit"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price per Unit';
        }
        field(80010; "Remark Real Location"; Text[250])
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
                    Falocation.init;
                "Remark Real Location" := Falocation."Location Detail";
            end;
        }
    }
}