
/// <summary>
/// Table NCT Read Table Field (ID 80015).
/// </summary>
table 80015 "NCT Read Table Field"
{
    Caption = 'Read Table Field';
    TableType = Temporary;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(2; "Table Name"; Text[50])
        {
            Caption = 'Table Name';
            DataClassification = CustomerContent;
        }
        field(3; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            DataClassification = CustomerContent;
        }
        field(4; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
            DataClassification = CustomerContent;
        }
        field(5; "Data Type"; Text[50])
        {
            Caption = 'Data Type';
            DataClassification = CustomerContent;
        }
        field(6; Remark; Text[250])
        {
            Caption = 'Remark';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Table ID", "Field ID")
        {
            Clustered = true;
        }
    }
}
