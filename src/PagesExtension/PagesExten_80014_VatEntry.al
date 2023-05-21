pageextension 80014 VatEntry extends "VAT Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("Tax Invoice Base"; Rec."Tax Invoice Base")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Base';

            }
            field("Tax Invoice Amount"; Rec."Tax Invoice Amount")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Amount';
            }
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
            field("Tax Invoice Address"; Rec."Tax Invoice Address")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Address';
            }
            field("Tax Invoice City"; Rec."Tax Invoice City")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice City';
            }
            field("Tax Invoice Post Code"; Rec."Tax Invoice Post Code")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Post Code';
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

        }
        modify("VAT Registration No.")
        {
            Visible = true;
        }
        moveafter("Branch Code"; "VAT Registration No.")
    }
}