/// <summary>
/// PageExtension NCT Purch. Credit Memo Subpage (ID 80076) extends Record Purch. Cr. Memo Subform.
/// </summary>
pageextension 80076 "NCT Purch. Credit Memo Subpage" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")

        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Product Posting Group"; Rec."NCT WHT Product Posting Group")
            {
                ApplicationArea = All;
                Caption = 'WHT Product Posting Group';
                ToolTip = 'Specifies value of the field.';
            }
        }
        movebefore("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")

    }
}