tableextension 80016 "ExtenInvoice Post. Buffer" extends "Invoice Post. Buffer"
{
    fields
    {
        field(80000; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = SystemMetadata;
        }
        field(80001; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = SystemMetadata;
        }
        field(80002; "Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = SystemMetadata;

        }
        field(80003; "Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = SystemMetadata;
        }
        field(80004; "Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(80005; "Tax Invoice Name"; Text[150])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = SystemMetadata;
        }
        field(80006; "Description Line"; Text[250])
        {
            Caption = 'Description Line';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = SystemMetadata;

        }
        field(80008; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch No.';
            DataClassification = SystemMetadata;

        }
        field(80009; "Vat Registration No."; Text[20])
        {
            Caption = 'Tax Branch No.';
            DataClassification = SystemMetadata;

        }
        field(80010; "Line No."; Integer)
        {
            Caption = 'Tax Line No.';
            DataClassification = SystemMetadata;

        }
        field(80011; "Address"; Text[160])
        {
            Caption = 'Address';
            DataClassification = SystemMetadata;
        }
        field(80012; "City"; Text[50])
        {
            Caption = 'City';
            DataClassification = SystemMetadata;
        }
        field(80013; "Post Code"; Code[30])
        {
            Caption = 'Post Code';
            DataClassification = SystemMetadata;
        }
        field(80014; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
        field(80015; "Vendor Invoice No."; Code[30])
        {
            Caption = 'Vendor Invoice No.';
            DataClassification = SystemMetadata;
        }

    }
}