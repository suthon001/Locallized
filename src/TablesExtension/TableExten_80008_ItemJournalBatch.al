tableextension 80008 "ExtenItem Journal Batch" extends "Item Journal Batch"
{
    fields
    {
        field(80000; "Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(80001; "Default Entry Type"; Enum "Item Ledger Entry Type")
        {
            Caption = 'Default Entry Type';
            DataClassification = CustomerContent;
        }
        field(80002; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }

    }
}