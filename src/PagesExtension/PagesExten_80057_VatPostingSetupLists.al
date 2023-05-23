pageextension 80057 "VatPostingSetupLists" extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
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