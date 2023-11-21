/// <summary>
/// TableExtension NCT ExtenPostedGenLines (ID 80050) extends Record Posted Gen. Journal Line.
/// </summary>
tableextension 80050 "NCT ExtenPostedGenLines" extends "Posted Gen. Journal Line"
{
    fields
    {
        field(80001; "NCT Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
        }

        field(80003; "NCT Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;
        }
        field(80006; "NCT Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80007; "NCT Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor/Cutomer No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Gen. Posting Type" = filter(Purchase)) Vendor."no."
            else
            IF ("Gen. Posting Type" = filter(Sale)) Customer."No."
            else
            IF ("Gen. Posting Type" = filter(" "), "NCT Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";




        }
        field(80008; "NCT Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }

        field(80010; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;


        }
        field(80011; "NCT VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;


        }
        field(80012; "NCT Description Voucher"; Text[250])
        {
            Caption = 'Description Voucher';
            DataClassification = CustomerContent;
        }
        field(80013; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80014; "NCT WHT Product Posting Group"; Code[10])
        {
            Caption = 'Product Posting Group';
            TableRelation = "NCT WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80015; "NCT WHT Name"; text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(80016; "NCT WHT Name 2"; text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(80017; "NCT WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(80018; "NCT WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(80019; "NCT WHT Post Code"; Code[20])
        {
            Caption = 'WHT Post Code';
            DataClassification = CustomerContent;
        }
        field(80020; "NCT WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(80021; "NCT WHT County"; Text[50])
        {
            Caption = 'WHT County';
            DataClassification = CustomerContent;
        }
        field(80022; "NCT WHT Country Code"; Code[10])
        {
            Caption = 'WHT Country Code';
            DataClassification = CustomerContent;
        }
        field(80023; "NCT WHT Registration No."; Text[20])
        {
            Caption = 'WHT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80024; "NCT WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;

        }
        field(80025; "NCT WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = CustomerContent;
        }
        field(80026; "NCT WHT Revenue Type"; Code[10])
        {
            Caption = 'WHT Revenue Type';
            DataClassification = CustomerContent;
        }
        field(80027; "NCT WHT Revenue Description"; Text[50])
        {
            Caption = 'WHT Revenue Description';
            DataClassification = CustomerContent;
        }
        field(80028; "NCT WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(80029; "NCT WHT Document No."; Code[30])
        {
            Caption = 'WHT Document No.';
            DataClassification = CustomerContent;
        }
        field(80030; "NCT WHT Option"; Enum "NCT WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80031; "NCT WHT No. Series"; Code[10])
        {
            Caption = 'WHT No. Series';
            DataClassification = CustomerContent;
        }
        field(80032; "NCT WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(80033; "NCT Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;


        }
        field(80034; "NCT Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;

        }
        field(80035; "NCT Bank Account No."; text[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80036; "NCT Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;

        }
        field(80037; "NCT Cheque No."; Text[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;

        }
        field(80038; "NCT Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;

        }
        field(80039; "NCT Pay Name"; Text[100])
        {
            Caption = 'Pay Name';
            DataClassification = CustomerContent;
        }

        field(80040; "NCT WHT Vendor No."; Code[20])
        {
            Caption = 'WHT Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

        }
        field(80041; "NCT Tax Invoice Address"; Code[100])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = CustomerContent;
        }
        field(80042; "NCT Tax Invoice City"; text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = CustomerContent;
        }
        field(80043; "NCT Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = CustomerContent;
        }
        field(80044; "NCT Require Screen Detail"; Enum "NCT Require Screen Detail")
        {
            Caption = 'Require Screen Detail';
            DataClassification = CustomerContent;


        }
        field(80045; "NCT Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("NCT Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";


        }


        field(80046; "NCT Cheque Name"; Text[100])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;

        }
        field(80047; "NCT Journal Description"; Text[250])
        {

            Caption = 'Journal Description';
            DataClassification = CustomerContent;
        }
        field(80048; "NCT WHT Cust/Vend No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Cust/Vend No.';
        }
        field(80049; "NCT Tax Invoice Name 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Name 2';
        }

        field(80050; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80051; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80052; "NCT Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80053; "NCT Tax Invoice Address 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Address 2';
        }

        field(80054; "NCT Template Source Type"; Enum "Gen. Journal Template Type")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Gen. Journal Template".Type where(Name = field("Journal Template Name")));
            Caption = 'Template Source Type';
        }
        field(80055; "Ref. Billing & Receipt No."; code[30])
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Ref. Billing & Receipt No.';

        }
    }
}