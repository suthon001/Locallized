/// <summary>
/// Table WHT Applied Entry (ID 50012).
/// </summary>
table 50012 "WHT Applied Entry"
{
    Caption = 'WHT Applied Entry';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entryr Type';
            OptionMembers = Initial,Applied;
            OptionCaption = 'Initial,Applied';
            DataClassification = CustomerContent;
        }
        field(5; "WHT Bus. Posting Group"; Code[20])
        {
            Caption = 'WHT Bus. Posting Group';
            DataClassification = CustomerContent;
        }
        field(6; "WHT Prod. Posting Group"; Code[20])
        {
            Caption = 'WHT Prod. Posting Group';
            DataClassification = CustomerContent;
        }
        field(7; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(8; "WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;
        }
        field(9; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = CustomerContent;
        }
        field(10; "WHT Name"; Text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(11; "WHT Name 2"; Text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(12; "WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(13; "WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(14; "WHT Address 3"; Text[50])
        {
            Caption = 'WHT Address 3';
            DataClassification = CustomerContent;
        }
        field(15; "WHT City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(16; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(17; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
        }
        field(18; "Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(19; "WHT Post Code"; Text[30])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(20; "WHT Option"; Enum "WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(21; "Description"; Text[100])
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }
}