/// <summary>
/// PageExtension NCT VatEntry (ID 80014) extends Record VAT Entries.
/// </summary>
pageextension 80014 "NCT VatEntry" extends "VAT Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("Tax Invoice Base"; Rec."NCT Tax Invoice Base")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Base';
                ToolTip = 'Specifies the value of the Tax Invoice Base field.';
            }
            field("Tax Invoice Amount"; Rec."NCT Tax Invoice Amount")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Amount';
                ToolTip = 'Specifies the value of the Tax Invoice Amount field.';
            }
            field("Tax Invoice Date"; Rec."NCT Tax Invoice Date")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Date';
                ToolTip = 'Specifies the value of the Tax Invoice Date field.';
            }
            field("Tax Invoice No."; Rec."NCT Tax Invoice No.")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice No.';
                ToolTip = 'Specifies the value of the Tax Invoice No. field.';
            }
            field("Tax Vendor No."; Rec."NCT Tax Vendor No.")
            {
                ApplicationArea = all;
                Caption = 'Tax Vendor No.';
                ToolTip = 'Specifies the value of the Tax Vendor No. field.';
            }
            field("Tax Invoice Name"; Rec."NCT Tax Invoice Name")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Name';
                ToolTip = 'Specifies the value of the Tax Invoice Name field.';
            }
            field("Tax Invoice Address"; Rec."NCT Tax Invoice Address")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Address';
                ToolTip = 'Specifies the value of the Tax Invoice Address field.';
            }
            field("Tax Invoice City"; Rec."NCT Tax Invoice City")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice City';
                ToolTip = 'Specifies the value of the Tax Invoice City field.';
            }
            field("Tax Invoice Post Code"; Rec."NCT Tax Invoice Post Code")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Post Code';
                ToolTip = 'Specifies the value of the Tax Invoice Post Code field.';
            }
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("Branch Code"; Rec."NCT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'Branch Code';
                ToolTip = 'Specifies the value of the Branch Code field.';
            }

        }
        modify("VAT Registration No.")
        {
            Visible = true;
        }
        moveafter("Branch Code"; "VAT Registration No.")
    }
}