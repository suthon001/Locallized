/// <summary>
/// Table WHT Applied Entry (ID 50012).
/// </summary>
table 50012 "WHT Applied Entry"
{
    Caption = 'WHT Applied Entry';
    fields
    {
        field(1; "Vendor Ledger Entry No."; Integer)
        {
            Caption = 'Vendor Ledget Entry No.';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entryr Type';
            OptionMembers = Initial,Applied;
            OptionCaption = 'Initial,Applied';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(5; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(6; "WHT Bus. Posting Group"; Code[20])
        {
            Caption = 'WHT Bus. Posting Group';
        }
        field(7; "WHT Prod. Posting Group"; Code[20])
        {
            Caption = 'WHT Prod. Posting Group';
        }
        field(8; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
        }
        field(9; "WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
        }
        field(10; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
        }
        field(11; "WHT Name"; Text[150])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(12; "WHT Name 2"; Text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(13; "WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(14; "WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(15; "WHT Address 3"; Text[50])
        {
            Caption = 'WHT Address 3';
            DataClassification = CustomerContent;
        }
        field(16; "WHT City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(17; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(18; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
        }
        field(19; "VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
        }
        field(20; "WHT Post Code"; Text[30])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;

        }
        field(21; "WHT Option"; Option)
        {
            OptionMembers = "1","2","3","4";
            OptionCaption = '1,2,3,4';
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "Vendor Ledger Entry No.", "Entry Type", "Line No.", "Document No.", "Document Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry Type", "Document No.", "Document Line No.")
        {
        }
        key(Key3; "Vendor Ledger Entry No.", "Line No.")
        {
            SumIndexFields = "WHT Base", "WHT Amount";
        }
    }
}