pageextension 80042 "PostedPurchCreditMemoCard" extends "Posted Purchase Credit Memo"

{
    layout
    {
        addlast(General)
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Bus. Posting Group';
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
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
            }
        }
        modify(Cancelled)
        {
            Visible = false;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
        modify(Corrective)
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
            }
        }
        addafter("Buy-from Contact")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
            }
        }
    }
}