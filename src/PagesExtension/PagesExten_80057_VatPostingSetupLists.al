/// <summary>
/// PageExtension VatPostingSetupLists (ID 80057) extends Record VAT Posting Setup.
/// </summary>
pageextension 80057 "NCT VatPostingSetupLists" extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
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