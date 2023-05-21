tableextension 80026 "Vat Entry" extends "VAT Entry"
{
    fields
    {
        field(80001; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80002; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80003; "Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;

        }
        field(80004; "Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80005; "Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            //TableRelation = Vendor."No.";
        }
        field(80006; "Tax Invoice Name"; Text[150])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80007; "Description Line"; Text[250])
        {
            Caption = 'Description Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80009; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;

        }
        field(80010; "Tax Line No."; Integer)
        {
            Caption = 'Tax Line No.';
            DataClassification = SystemMetadata;

        }
        field(80011; "Tax Invoice Address"; Text[150])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = SystemMetadata;

        }
        field(80012; "Tax Invoice City"; Text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = SystemMetadata;

        }
        field(80013; "Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = SystemMetadata;

        }
        field(80014; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
    }
}