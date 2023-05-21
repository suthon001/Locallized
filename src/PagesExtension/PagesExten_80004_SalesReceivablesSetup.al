pageextension 80004 "ExtenSales&ReceSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Sale Billing Nos."; Rec."Sale Billing Nos.")
            {
                ApplicationArea = all;
            }
            field("Sale Receipt Nos."; Rec."Sale Receipt Nos.")
            {
                ApplicationArea = all;
            }
            field("Sales VAT Nos."; rec."Sales VAT Nos.")
            {
                ApplicationArea = all;
            }

        }
    }
}