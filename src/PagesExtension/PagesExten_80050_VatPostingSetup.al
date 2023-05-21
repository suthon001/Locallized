pageextension 80050 "VatPostingSetup" extends "VAT Posting Setup Card"
{
    layout
    {
        addlast(General)
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