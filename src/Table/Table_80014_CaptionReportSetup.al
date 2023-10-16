/// <summary>
/// Table NCT Caption Report Setup (ID 80014).
/// </summary>
table 80014 "NCT Caption Report Setup"
{
    Caption = 'Caption Report Setup';
    LookupPageId = "NCT Caption Report List";
    DrillDownPageId = "NCT Caption Report List";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Name (Thai)"; Text[50])
        {
            Caption = 'Name (Thai)';
            DataClassification = CustomerContent;
        }
        field(3; "Name (Eng)"; Text[50])
        {
            Caption = 'Name (Eng)';
            DataClassification = CustomerContent;
        }
        field(4; "Document Type"; Enum "NCT Document Type Report")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document Type", "Entry No.")
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "Name (Thai)", "Name (Eng)") { }
    }
}
