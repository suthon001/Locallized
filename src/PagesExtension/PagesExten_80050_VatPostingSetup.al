/// <summary>
/// PageExtension NCT VatPostingSetup (ID 80050) extends Record VAT Posting Setup Card.
/// </summary>
pageextension 80050 "NCT VatPostingSetup" extends "VAT Posting Setup Card"
{
    layout
    {
        addlast(General)
        {
            field("NCT Allow to Purch. Vat"; rec."NCT Allow to Purch. Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Purch. Vat Report field.';
            }
            field("NCT Allow to Sales Vat"; rec."NCT Allow to Sales Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Sales Vat Report field.';
            }
        }
    }
}