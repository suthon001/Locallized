pageextension 80082 "Product Posting Groups" extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Direct VAT"; Rec."Direct VAT")
            {
                ApplicationArea = all;
                Caption = 'Direct VAT';
                ToolTip = 'Specifies the value of the Direct VAT field.';
            }

        }
    }
}