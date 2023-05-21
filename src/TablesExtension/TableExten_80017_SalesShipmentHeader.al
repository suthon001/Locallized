tableextension 80017 "ExtenSalesShipmentHeader" extends "Sales Shipment Header"
{
    fields
    {

        field(80000; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;


        }
        field(80002; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            TableRelation = "Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Sell-to Customer No."));
            DataClassification = CustomerContent;


        }
        field(80003; "Ref. Tax Invoice Date"; Date)
        {
            Caption = 'Ref. Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80004; "Ref. Tax Invoice No."; Code[20])
        {
            Caption = 'Ref. Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80005; "Ref. Tax Invoice Amount"; Decimal)
        {
            Caption = 'Ref. Tax Invoice Amount';
            DataClassification = CustomerContent;
        }

        field(80006; "Create By"; Code[30])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }

    }
}