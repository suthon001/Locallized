pageextension 80079 "Sales Credit Memo Subpage" extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")
        addafter("Location Code")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Bus. Posting Group';
            }

            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'VAT Bus. Posting Group';
            }
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                ApplicationArea = all;
                Caption = 'WHT Business Posting Group';
            }
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Gen. Bus. Posting Group"; "Gen. Prod. Posting Group")

        modify("Return Reason Code")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("VAT Bus. Posting Group"; "VAT Prod. Posting Group")
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
    }
}