pageextension 80034 "SalesReturnOrder Lines" extends "Sales Return Order Subform"
{
    layout
    {
        modify("Tax Group Code")
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
        moveafter(Type; "No.", Description, "VAT Prod. Posting Group", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Return Reason Code", "Location Code", Quantity,
        "Reserved Quantity", "Unit of Measure Code", "Unit Price", "Line Discount %", "Line Discount Amount", "Line Amount", "Return Qty. to Receive", "Return Qty. Received", "Quantity Invoiced",
         ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)


        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")
        addafter("Description 2")
        {

            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }

        }
        addafter("Line Amount")
        {
            field("Qty. to Cancel"; Rec."Qty. to Cancel")
            {
                ApplicationArea = all;
            }
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}