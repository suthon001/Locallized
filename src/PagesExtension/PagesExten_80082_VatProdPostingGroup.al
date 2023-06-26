/// <summary>
/// PageExtension Product Posting Groups (ID 80082) extends Record VAT Product Posting Groups.
/// </summary>
pageextension 80082 "NCT Product Posting Groups" extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Direct VAT"; Rec."NCT Direct VAT")
            {
                ApplicationArea = all;
                Caption = 'Direct VAT';
                ToolTip = 'Specifies the value of the Direct VAT field.';
            }

        }
    }
}