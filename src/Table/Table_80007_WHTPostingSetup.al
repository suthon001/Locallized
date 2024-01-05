/// <summary>
/// Table NCT WHT Posting Setup (ID 80007).
/// </summary>
table 80007 "NCT WHT Posting Setup"
{
    Caption = 'WHT Posting Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "WHT Bus. Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(2; "WHT Prod. Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "NCT WHT Product Posting Group";
            DataClassification = CustomerContent;
        }
        field(3; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(8; "WHT Report Line No. Series"; Code[20])
        {
            Caption = 'WHT Report Line No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "WHT Bus. Posting Group", "WHT Prod. Posting Group")
        {
            Clustered = true;
        }
    }
}

