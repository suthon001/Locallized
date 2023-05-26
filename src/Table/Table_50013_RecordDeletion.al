/// <summary>
/// Table Record Deletion Table (ID 50013).
/// </summary>
table 50013 "Record Deletion Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = true;
            TableRelation = AllObj."Object ID" where("Object Type" = filter(Table));
            trigger OnValidate()
            var
                ALLObject: Record AllObj;
            begin
                if not ALLObject.GET(ALLObject."Object Type"::Table, "Table ID") then
                    ALLObject.init();
                "Table Name" := ALLObject."Object Name";
            end;

        }
        field(2; "Table Name"; Text[250])
        {
            Editable = false;
            Caption = 'Table Name';
        }
        field(3; "Delete Records"; Boolean)
        {
            Caption = 'Delete Records';
        }
        field(4; "LastTime Clean Transection"; DateTime)
        {
            Caption = 'LastTime Clean Transection';
            Editable = false;
        }
        field(5; "LastTime Clean By"; Code[50])
        {
            Caption = 'Last Time Clean By';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Table ID")
        {
        }
    }

}