/// <summary>
/// TableExtension NCT Purchase Inv. Header (ID 80030) extends Record Purch. Inv. Header.
/// </summary>
tableextension 80030 "NCT Purchase Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(80000; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
            TableRelation = "NCT Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Buy-from Vendor No."));
            DataClassification = CustomerContent;
        }
        field(80003; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "NCT Purchase Order No."; Code[30])
        {
            Caption = 'Purchase Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "NCT Make PO No.Series No."; Code[20])
        {
            Caption = 'Make PO No.Series No.';
            DataClassification = CustomerContent;

        }
    }
}