pageextension 80073 "Purchase Invoice Subpage" extends "Purch. Invoice Subform"
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
                Caption = 'WHT Business Posting Group';
                ApplicationArea = all;
            }

        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Gen. Bus. Posting Group"; "Gen. Prod. Posting Group")

        addlast(PurchDetailLine)
        {
            field("Tax Invoice Date"; Rec."Tax Invoice Date")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Date';
            }
            field("Tax Invoice No."; Rec."Tax Invoice No.")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice No.';
            }
            field("Tax Vendor No."; Rec."Tax Vendor No.")
            {
                ApplicationArea = all;
                Caption = 'Tax Vendor No.';
            }
            field("Tax Invoice Name"; Rec."Tax Invoice Name")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Name';
            }
            field("Tax Invoice Base"; Rec."Tax Invoice Base")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Base';
            }

            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
                Caption = 'Branch Code';
            }
            field("Vat Registration No."; Rec."Vat Registration No.")
            {
                ApplicationArea = all;
                Caption = 'Vat Registration No.';
            }
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("VAT Bus. Posting Group"; "VAT Prod. Posting Group")
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
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