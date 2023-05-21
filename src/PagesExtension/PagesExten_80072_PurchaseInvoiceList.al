pageextension 80072 "Purchase Invoice Lists" extends "Purchase Invoices"
{
    PromotedActionCategories = 'New,Process,Print,Request Approval,Credit Memo,Release,Posting,Navigate';
    layout
    {
        modify(Status)
        {
            Visible = true;
        }
        modify("Vendor Invoice No.")
        {
            Visible = false;
        }
        modify("Pay-to Name")
        {
            Visible = true;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Document Date")
        {
            Visible = true;
        }
        moveafter("No."; Status, "Posting Date", "Document Date", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name",
        Amount, "Location Code", "Purchaser Code", "Assigned User ID")
        addafter("Pay-to Name")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
                Caption = 'Posting Description';
            }
        }
        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
                Caption = 'Amount Including VAT';
            }
        }
        addafter("Assigned User ID")
        {
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
    }
    actions
    {
        addlast(Reporting)
        {
            action("AP Voucher")
            {
                Caption = 'AP Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    APVoucher: Report "AP Voucher";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset;
                    PurchaseHeader.Copy(Rec);
                    APVoucher."SetGLEntry"(PurchaseHeader);
                    APVoucher.RunModal();
                end;
            }
        }
    }
}