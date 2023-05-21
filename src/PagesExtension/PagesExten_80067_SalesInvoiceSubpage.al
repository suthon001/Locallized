pageextension 80067 "Sales Invoice Subpage" extends "Sales Invoice Subform"
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
                Visible = false;
            }

            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'VAT Bus. Posting Group';
                Visible = false;
            }
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                ApplicationArea = all;
                Visible = false;
                Caption = 'WHT Business Posting Group';
            }

        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Gen. Bus. Posting Group"; "Gen. Prod. Posting Group")

        modify("Depr. until FA Posting Date")
        {
            Visible = true;
        }
        moveafter(Quantity; "Depr. until FA Posting Date")
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
        moveafter("VAT Bus. Posting Group"; "VAT Prod. Posting Group")
    }


}