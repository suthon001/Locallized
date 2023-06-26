/// <summary>
/// PageExtension CustLedgEntry (ID 80052) extends Record Customer Ledger Entries.
/// </summary>
pageextension 80052 "NCT CustLedgEntry" extends "Customer Ledger Entries"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }
    }
}