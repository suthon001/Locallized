tableextension 80031 "ExtenPurchase Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {

        field(80000; "Qty. to Cancel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Cancel';
            Editable = false;
        }
        field(80001; "Qty. to Cancel (Base)"; Decimal)
        {
            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Qty. to Cancel (Base)';
        }
        field(80002; "Make Order By"; Code[30])
        {
            Caption = 'Make Order By';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80003; "Make Order DateTime"; DateTime)
        {
            Caption = 'Make Order DateTime';
            Editable = false;
            DataClassification = SystemMetadata;
        }

        field(80004; "Ref. PQ No."; Code[30])
        {
            Caption = 'Ref. PR No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "Ref. PQ Line No."; Integer)
        {
            Caption = 'Ref. PR Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80007; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80008; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80009; "Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;


        }
        field(80010; "Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80011; "Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

        }
        field(80012; "Tax Invoice Name"; Text[150])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80013; "Head Office"; Boolean)
        {
            Caption = 'Tax Head Office';
            DataClassification = CustomerContent;



        }
        field(80014; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;

        }
        field(80015; "Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(80016; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80019; "Select Vendor No."; Code[20])
        {
            Caption = 'Select Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(80020; "Select By"; Code[30])
        {
            Caption = 'Select By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80021; "Make to PO Qty."; Decimal)
        {
            Caption = 'Make to PO Qty.';
            DataClassification = CustomerContent;

        }

    }

}