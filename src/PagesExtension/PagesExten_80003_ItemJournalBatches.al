pageextension 80003 "ExtenItem Journal Batches" extends "Item Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; rec."Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. Series field.';
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
                ToolTip = 'Specifies the value of the Default Entry Type field.';
            }
            field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
            }
        }
    }

}