/// <summary>
/// PageExtension VendorLedgerCard (ID 80045) extends Record Vendor Ledger Entries.
/// </summary>
pageextension 80045 "NCT VendorLedgerCard" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Due Date")
        {
            field("Aging Due Date"; Rec."NCT Aging Due Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Aging Due Date field.';
            }
        }
    }
}