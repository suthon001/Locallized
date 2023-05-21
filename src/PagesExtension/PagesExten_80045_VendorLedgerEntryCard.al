pageextension 80045 "VendorLedgerCard" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Due Date")
        {
            field("Aging Due Date"; Rec."Aging Due Date")
            {
                ApplicationArea = all;
            }
        }
    }
}