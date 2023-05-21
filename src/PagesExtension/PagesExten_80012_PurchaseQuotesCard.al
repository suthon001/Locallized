pageextension 80012 "Purchase Quote Card" extends "Purchase Quote"
{
    layout
    {
        addbefore(Status)
        {

            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
            }
            field("Purchase Order No."; rec."Purchase Order No.")
            {
                ApplicationArea = all;
            }
            field("Make PO No.Series No."; rec."Make PO No.Series No.")
            {
                ApplicationArea = all;
            }
        }
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Expected Receipt Date")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Visible = true;
        }
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Purchaser Code"; "Currency Code")
        moveafter("Currency Code"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        moveafter("Make PO No.Series No."; "Expected Receipt Date", "Location Code")
    }
    actions
    {
        addlast(Reporting)
        {
            action("Purchase Quote")
            {
                Caption = 'Purchase Quote';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Category6;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset;
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"PurchaseQuotes", true, true, PurchaseHeader);
                end;
            }
        }
    }
}