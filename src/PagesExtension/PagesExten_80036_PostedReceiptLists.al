pageextension 80036 "PostedReceiptList" extends "Posted Purchase Receipts"
{

    layout
    {
        modify("Pay-to Name")
        {
            Visible = true;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = true;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        moveafter("no."; "Posting Date", "Document Date", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name")
        addafter("Document Date")
        {
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = all;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Pay-to Name")
        {
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = all;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
            }
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(Reporting)
        {
            action("Purchase Receipt")
            {
                Caption = 'Purchase Receipt';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Category5;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PurchaseRecripet: Record "Purch. Rcpt. Header";
                begin
                    PurchaseRecripet.reset;
                    PurchaseRecripet.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"Good Receipt Note", true, true, PurchaseRecripet);
                end;
            }
        }
    }
}