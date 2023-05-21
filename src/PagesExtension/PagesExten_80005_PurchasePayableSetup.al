pageextension 80005 "ExtenPurchaPayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Purchase Billing Nos."; Rec."Purchase Billing Nos.")
            {
                ApplicationArea = all;
            }
            field("Purchase Receipt Nos."; Rec."Purchase Receipt Nos.")
            {
                ApplicationArea = all;
            }
            field("Purchase VAT Nos."; rec."Purchase VAT Nos.")
            {
                ApplicationArea = all;
            }
            field("WHT03 Nos."; rec."WHT03 Nos.")
            {
                ApplicationArea = all;
            }
            field("WHT53 Nos."; rec."WHT53 Nos.")
            {
                ApplicationArea = all;
            }
        }
    }
}