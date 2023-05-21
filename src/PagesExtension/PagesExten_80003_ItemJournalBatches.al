pageextension 80003 "ExtenItem Journal Batches" extends "Item Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; rec."Document No. Series")
            {
                ApplicationArea = all;
            }

        }
        modify("No. Series")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Default Entry Type"; rec."Default Entry Type")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = all;
            }
        }
    }

}