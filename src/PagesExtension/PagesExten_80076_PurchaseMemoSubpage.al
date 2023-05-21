pageextension 80076 "Purch. Credit Memo Subpage" extends "Purch. Cr. Memo Subform"
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

        addafter("VAT Prod. Posting Group")
        {
            field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            {
                ApplicationArea = All;
                Caption = 'WHT Product Posting Group';
            }
        }
    }
}