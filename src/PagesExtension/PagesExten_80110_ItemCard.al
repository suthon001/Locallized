/// <summary>
/// PageExtension NCT Item Card (ID 80110) extends Record Item Card.
/// </summary>
pageextension 80110 "NCT Item Card" extends "Item Card"
{
    layout
    {
        addafter("Base Unit of Measure")
        {
            field("NCT WHT Product Posting Group"; rec."NCT WHT Product Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT Product Posting Group field.';
            }
        }
    }
}
