/// <summary>
/// TableExtension NCT ExtenItem Journal Batch (ID 80008) extends Record Item Journal Batch.
/// </summary>
tableextension 80008 "NCT ExtenItem Journal Batch" extends "Item Journal Batch"
{
    fields
    {
        field(80000; "NCT Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Default Entry Type"; Enum "Item Ledger Entry Type")
        {
            Caption = 'Default Entry Type';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }

    }
}