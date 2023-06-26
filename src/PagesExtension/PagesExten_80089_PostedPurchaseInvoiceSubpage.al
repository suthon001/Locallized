/// <summary>
/// PageExtension NCT Posted Purch. Invoice Sub (ID 80089) extends Record Posted Purch. Invoice Subform.
/// </summary>
pageextension 80089 "NCT Posted Purch. Invoice Sub" extends "Posted Purch. Invoice Subform"
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
                ToolTip = 'Specifies value of the field.';
            }
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
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Business Posting Group"; Rec."NCT WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("WHT Product Posting Group"; rec."NCT WHT Product Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
        addlast(Control1)
        {
            field("Tax Invoice Date"; Rec."NCT Tax Invoice Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Invoice No."; Rec."NCT Tax Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Vendor No."; Rec."NCT Tax Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Invoice Name"; Rec."NCT Tax Invoice Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Invoice Base"; Rec."NCT Tax Invoice Base")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }

            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Branch Code"; Rec."NCT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Vat Registration No."; Rec."NCT Vat Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
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