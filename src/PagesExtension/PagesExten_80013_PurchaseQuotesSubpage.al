/// <summary>
/// PageExtension Purchase Quotes Subpage (ID 80013) extends Record Purchase Quote Subform.
/// </summary>
pageextension 80013 "NCT Purchase Quotes Subpage" extends "Purchase Quote Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        modify("Qty. to Assign") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        modify("Expected Receipt Date") { Visible = false; }
        modify("Item Reference No.") { Visible = false; }
        modify("VAT Bus. Posting Group") { Visible = true; }
        modify("VAT Prod. Posting Group") { Visible = true; }
        modify("Gen. Bus. Posting Group") { Visible = true; }
        modify("Gen. Prod. Posting Group") { Visible = true; }
        moveafter(Description; "Description 2")
        movefirst(Control1; Type, "No.", Description, "Description 2", "Location Code", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group", Quantity, "Unit of Measure Code", "Direct Unit Cost", "Line Discount %", "Line Discount Amount", "Line Amount",
        "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)
        addafter(Quantity)
        {
            field("NCT Qty. to Cancel"; rec."NCT Qty. to Cancel")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Qty. to Cancel field.';
            }
        }

    }
}