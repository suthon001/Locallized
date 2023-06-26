/// <summary>
/// PageExtension ItemLedgerEntry (ID 80053) extends Record Item Ledger Entries.
/// </summary>
pageextension 80053 "NCT ItemLedgerEntry" extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Vendor/Customer Name"; Rec."NCT Vendor/Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor/Customer Name field.';
            }
        }
        addafter("Lot No.")
        {
            field("Bin Code"; Rec."NCT Bin Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Bin Code field.';
            }
        }
    }
}