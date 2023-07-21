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
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the External Document No. field.';

            }
            field("NCT Document Invoice No."; rec."NCT Document Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoice No. field.';
            }
        }
        modify("Cost Amount (Expected)")
        {
            Visible = true;
        }
        modify("Sales Amount (Expected)")
        {
            Visible = true;
        }
        moveafter("Sales Amount (Actual)"; "Sales Amount (Expected)")
        moveafter("Cost Amount (Actual)"; "Cost Amount (Expected)")
        modify("Lot No.") { Visible = true; }
        addafter("Lot No.")
        {
            field("Bin Code"; Rec."NCT Bin Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Bin Code field.';
            }
        }
        modify("Serial No.") { Visible = true; }
        moveafter("Lot No."; "Serial No.")

    }
}