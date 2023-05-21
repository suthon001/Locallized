pageextension 80057 "VatPostingSetupLists" extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Include Purch. Vat Report"; Rec."Generate Purch. Vat Report")
            {
                ApplicationArea = all;
            }
            field("Include Sales Vat Report"; Rec."Generate Sales Vat Report")
            {
                ApplicationArea = all;
            }
        }
    }
}