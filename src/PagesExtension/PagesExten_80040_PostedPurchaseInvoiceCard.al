/// <summary>
/// PageExtension PostedInvoiceCard (ID 80040) extends Record Posted Purchase Invoice.
/// </summary>
pageextension 80040 "NCT PostedInvoiceCard" extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Bus. Posting Group';
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
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
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
        }

        modify(Corrective)
        {
            Visible = false;
        }
        modify(Cancelled)
        {
            Visible = false;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the identifier of the vendor that you bought the items from.';
            }
        }
    }
}