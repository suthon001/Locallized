pageextension 80018 "BWK Sales Quotes Subpage" extends "Sales Quote Subform"
{
    layout
    {
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

        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        // ASB2003-0109_Jar_31032020
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
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
        modify(ShortcutDimCode3)
        {
            Visible = true;
        }
        modify(ShortcutDimCode4)
        {
            Visible = true;
        }
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        modify(ShortcutDimCode6)
        {
            Visible = true;
        }
        modify(ShortcutDimCode7)
        {
            Visible = true;
        }
        modify(ShortcutDimCode8)
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


        moveafter("Gen. Bus. Posting Group"; "VAT Prod. Posting Group")
        moveafter("VAT Prod. Posting Group"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        moveafter(Quantity; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Unit Price")
        moveafter("Unit Price"; "Line Discount %")
        moveafter("Line Discount %"; "Line Discount Amount")
        moveafter("Line Discount Amount"; "Line Amount")
        addafter("Line Amount")
        {
            field(Amount; Rec.Amount)
            {
                ApplicationArea = all;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
            }

        }
        moveafter("Amount Including VAT"; ShortcutDimCode3)
        moveafter(ShortcutDimCode3; ShortcutDimCode4)
        moveafter(ShortcutDimCode4; ShortcutDimCode5)
        moveafter(ShortcutDimCode5; ShortcutDimCode6)
        moveafter(ShortcutDimCode6; ShortcutDimCode7)
        moveafter(ShortcutDimCode7; ShortcutDimCode8)
    }
}