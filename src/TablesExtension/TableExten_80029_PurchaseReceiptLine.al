/// <summary>
/// TableExtension NCT Purchase Rcpt. Line (ID 80029) extends Record Purch. Rcpt. Line.
/// </summary>
tableextension 80029 "NCT Purchase Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(80000; "NCT Qty. to Cancel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Cancel';

        }
        field(80001; "NCT Qty. to Cancel (Base)"; Decimal)
        {
            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Qty. to Cancel (Base)';
        }
        field(80002; "NCT Make Order By"; Code[50])
        {
            Caption = 'Make Order By';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80003; "NCT Make Order DateTime"; DateTime)
        {
            Caption = 'Make Order DateTime';
            Editable = false;
            DataClassification = SystemMetadata;
        }

        field(80004; "NCT Ref. PQ No."; Code[30])
        {
            Caption = 'Ref. PR No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "NCT Ref. PQ Line No."; Integer)
        {
            Caption = 'Ref. PR Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80007; "NCT Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80008; "NCT Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80009; "NCT Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;


        }
        field(80010; "NCT Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80011; "NCT Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

        }
        field(80012; "NCT Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80013; "NCT Head Office"; Boolean)
        {
            Caption = 'Tax Head Office';
            DataClassification = CustomerContent;

        }
        field(80014; "NCT Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;


        }
        field(80015; "NCT Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(80016; "NCT WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "NCT WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;

        }

        field(80018; "NCT Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80019; "NCT WHT %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT %';
        }
        field(80020; "NCT WHT Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Base';
        }
        field(80021; "NCT WHT Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Amount';
        }
        field(80022; "NCT WHT Option"; Enum "NCT WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }

    }
}