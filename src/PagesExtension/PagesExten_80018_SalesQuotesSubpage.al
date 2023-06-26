/// <summary>
/// PageExtension Sales Quotes Subpage (ID 80018) extends Record Sales Quote Subform.
/// </summary>
pageextension 80018 "NCT Sales Quotes Subpage" extends "Sales Quote Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2", "Location Code")

        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }

        modify("Unit Price")
        {
            Visible = true;
        }
        modify("Line Discount Amount")
        {
            Visible = true;
        }
        modify("Line Amount")
        {
            Visible = true;
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }

        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        moveafter(Quantity; "Unit of Measure Code", "Unit Price", "Line Discount %", "Line Discount Amount", "Line Amount", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
        ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)


    }
}