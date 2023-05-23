pageextension 80050 "VatPostingSetup" extends "VAT Posting Setup Card"
{
    layout
    {
        addlast(General)
        {
            field("Allow Generate to Purch. Vat"; rec."Allow Generate to Purch. Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Purch. Vat Report field.';
            }
            field("Allow Generate to Sales Vat"; rec."Allow Generate to Sales Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Sales Vat Report field.';
            }
        }
    }
}