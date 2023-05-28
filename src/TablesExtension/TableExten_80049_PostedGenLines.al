/// <summary>
/// TableExtension ExtenPostedGenLines (ID 80050) extends Record Posted Gen. Journal Line.
/// </summary>
tableextension 80050 "ExtenPostedGenLines" extends "Posted Gen. Journal Line"
{
    fields
    {
        field(80001; "Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
        }
        field(80002; "Sales Receipt No."; Code[20])
        {
            Caption = 'Sales Receipt No.';
            DataClassification = CustomerContent;
        }
        field(80003; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80004; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80005; "Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;


        }
        field(80006; "Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80007; "Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor/Cutomer No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Gen. Posting Type" = filter(Purchase)) Vendor."no."
            else
            IF ("Gen. Posting Type" = filter(Sale)) Customer."No."
            else
            IF ("Gen. Posting Type" = filter(" "), "Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";


        }
        field(80008; "Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80009; "Description Line"; Text[150])
        {
            Caption = 'Description Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80010; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80011; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;


        }
        field(80012; "Description Voucher"; Text[250])
        {
            Caption = 'Description Voucher';
            DataClassification = CustomerContent;
        }
        field(80013; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80014; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'Product Posting Group';
            TableRelation = "WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80015; "WHT Name"; text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(80016; "WHT Name 2"; text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(80017; "WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(80018; "WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(80019; "WHT Post Code"; Code[20])
        {
            Caption = 'WHT Post Code';
            DataClassification = CustomerContent;
        }
        field(80020; "WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(80021; "WHT County"; Text[50])
        {
            Caption = 'WHT County';
            DataClassification = CustomerContent;
        }
        field(80022; "WHT Country Code"; Code[10])
        {
            Caption = 'WHT Country Code';
            DataClassification = CustomerContent;
        }
        field(80023; "WHT Registration No."; Text[20])
        {
            Caption = 'WHT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80024; "WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;

        }
        field(80025; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = CustomerContent;
        }
        field(80026; "WHT Revenue Type"; Code[10])
        {
            Caption = 'WHT Revenue Type';
            DataClassification = CustomerContent;
        }
        field(80027; "WHT Revenue Description"; Text[50])
        {
            Caption = 'WHT Revenue Description';
            DataClassification = CustomerContent;
        }
        field(80028; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(80029; "WHT Document No."; Code[30])
        {
            Caption = 'WHT Document No.';
            DataClassification = CustomerContent;
        }
        field(80030; "WHT Option"; Enum "WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80031; "WHT No. Series"; Code[10])
        {
            Caption = 'WHT No. Series';
            DataClassification = CustomerContent;
        }
        field(80032; "WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(80033; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;

        }
        field(80034; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;

        }
        field(80035; "Bank Account No."; text[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80036; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;

        }
        field(80037; "Cheque No."; Text[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;


        }
        field(80038; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;

        }
        field(80039; "Pay Name"; Text[100])
        {
            Caption = 'Pay Name';
            DataClassification = CustomerContent;

        }

        field(80040; "WHT Vendor No."; Code[20])
        {
            Caption = 'WHT Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

        }
        field(80041; "Tax Invoice Address"; Code[100])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = CustomerContent;
        }
        field(80042; "Tax Invoice City"; text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = CustomerContent;
        }
        field(80043; "Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = CustomerContent;
        }
        field(80044; "Require Screen Detail"; Enum "Require Screen Detail")
        {
            Caption = 'Require Screen Detail';
            DataClassification = CustomerContent;


        }
        field(80045; "Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;


        }
        field(80046; "Cheque Name"; Text[100])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;

        }
        field(80047; "Journal Description"; Text[250])
        {

            Caption = 'Journal Description';
            DataClassification = CustomerContent;
        }
        field(80048; "WHT Cust/Vend No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(80049; "Tax Invoice Name 2"; text[50])
        {
            DataClassification = CustomerContent;
        }

        field(80050; "Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80051; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80052; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80053; "Tax Invoice Address 2"; text[50])
        {
            DataClassification = CustomerContent;
        }

        field(80054; "Template Source Type"; Enum "Gen. Journal Template Type")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Gen. Journal Template".Type where(Name = field("Journal Template Name")));
            Caption = 'Template Source Type';
        }
    }
}