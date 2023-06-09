/// <summary>
/// Table NCT WHT Product Posting Group (ID 80008).
/// </summary>
table 80008 "NCT WHT Product Posting Group"
{
    DrillDownPageID = "NCT WHT Product Posting Group";
    LookupPageID = "NCT WHT Product Posting Group";
    Caption = 'WHT Product Posting Group';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Sequence"; Integer)
        {
            Caption = 'Sequence';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }


    }
    fieldgroups
    {
        fieldgroup("DropDown"; "Code", "Description") { }
    }

}

