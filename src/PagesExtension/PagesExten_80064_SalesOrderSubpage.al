pageextension 80064 "Sales Order Subpage" extends "Sales Order Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        moveafter(Type; "No.", Description, "VAT Prod. Posting Group", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", Quantity,
        "Reserved Quantity", "Unit of Measure Code", "Unit Price", "Line Discount %", "Line Discount Amount", "Line Amount",
        "Qty. to Ship", "Quantity Shipped", "Quantity Invoiced", "Planned Shipment Date", "Shipment Date",
        ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")
        addafter("Description 2")
        {
            field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addafter("Quantity Invoiced")
        {

            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = all;
                Caption = 'Outstanding Quantity';
            }
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
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

    }
}