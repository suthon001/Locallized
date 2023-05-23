pageextension 80053 "ItemLedgerEntry" extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Vendor/Customer Name"; Rec."Vendor/Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor/Customer Name field.';
            }
        }
        addafter("Lot No.")
        {
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Bin Code field.';
            }
        }
    }
}