pageextension 80044 "PurchaseReturnOrderLists" extends "Purchase Return Order List"

{
    layout
    {
        modify("Document Date")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = true;
        }
        modify("Pay-to Name")
        {
            Visible = true;
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Ship-to Code")
        {
            Visible = true;
        }
        modify("Ship-to Name")
        {
            Visible = true;
        }
        modify("Purchaser Code")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }

        moveafter("No."; Status, "Posting Date", "Document Date", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name", "Ship-to Code", "Ship-to Name", "Location Code",
        "Assigned User ID", "Purchaser Code", "Currency Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", Amount, "Amount Including VAT")
        addafter("Amount Including VAT")
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
            }
        }

    }
    actions
    {
        addlast(Reporting)
        {
            action("Purchase Return Order")
            {
                Caption = 'Purchase Return Order';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Category10;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset;
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"PurchaseReturnOrder", true, true, PurchaseHeader);
                end;
            }
        }
    }
}