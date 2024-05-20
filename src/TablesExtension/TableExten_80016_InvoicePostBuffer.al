/// <summary>
/// TableExtension NCT Invoice Post. Buffer (ID 80016) extends Record Invoice Post. Buffer.
/// </summary>
tableextension 80016 "NCT Invoice Post. Buffer" extends "Invoice Post. Buffer"
{
    fields
    {
        field(80000; "NCT Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = SystemMetadata;
        }
        field(80001; "NCT Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = SystemMetadata;
        }
        field(80002; "NCT Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = SystemMetadata;

        }
        field(80003; "NCT Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = SystemMetadata;
        }
        field(80004; "NCT Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(80005; "NCT Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = SystemMetadata;
        }
        field(80006; "NCT Description Line"; Text[150])
        {
            Caption = 'Description Line';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = SystemMetadata;

        }
        field(80008; "NCT VAT Branch Code"; Code[5])
        {
            Caption = 'Tax Branch No.';
            DataClassification = SystemMetadata;

        }
        field(80009; "NCT Vat Registration No."; Text[20])
        {
            Caption = 'Tax Branch No.';
            DataClassification = SystemMetadata;

        }
        field(80010; "NCT Line No."; Integer)
        {
            Caption = 'Tax Line No.';
            DataClassification = SystemMetadata;

        }
        field(80011; "NCT Address"; Text[100])
        {
            Caption = 'Address';
            DataClassification = SystemMetadata;
        }
        field(80012; "NCT City"; Text[50])
        {
            Caption = 'City';
            DataClassification = SystemMetadata;
        }
        field(80013; "NCT Post Code"; Code[30])
        {
            Caption = 'Post Code';
            DataClassification = SystemMetadata;
        }
        field(80014; "NCT Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }

        field(80015; "NCT Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80016; "NCT Address 2"; Text[100])
        {
            Caption = 'Address 2';
            DataClassification = SystemMetadata;

        }
        field(80017; "NCT Ref. Document No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ref. Document No.';
            Editable = false;
        }

    }
}