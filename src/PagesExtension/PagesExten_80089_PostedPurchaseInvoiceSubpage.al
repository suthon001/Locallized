pageextension 80089 "Posted Purch. Invoice Subpage" extends "Posted Purch. Invoice Subform"
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
            field("Location Code"; rec."Location Code")
            {
                ApplicationArea = all;
                Caption = 'Location Code';
            }

            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Bus. Posting Group';
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Prod. Posting Group';
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'VAT Bus. Posting Group';
            }
            field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
            {
                ApplicationArea = all;
            }
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                Caption = 'WHT Business Posting Group';
                ApplicationArea = all;
            }
            field("WHT Product Posting Group"; rec."WHT Product Posting Group")
            {
                ApplicationArea = all;
            }

        }
        addlast(Control1)
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

        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
    }

}