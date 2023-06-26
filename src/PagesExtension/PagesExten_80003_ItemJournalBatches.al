/// <summary>
/// PageExtension ExtenItem Journal Batches (ID 80003) extends Record Item Journal Batches.
/// </summary>
pageextension 80003 "NCT ExtenItem Journal Batches" extends "Item Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; rec."NCT Document No. Series")
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
            field("Default Entry Type"; rec."NCT Default Entry Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Default Entry Type field.';
            }
            field("Shortcut Dimension 1 Code"; rec."NCT Shortcut Dimension 1 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
            }
        }
    }

}