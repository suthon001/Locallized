pageextension 80074 "Purchase Credit MemosLists" extends "Purchase Credit Memos"
{
    PromotedActionCategories = 'New,Process,Print,Request Approval,Credit Memo,Release,Posting,Navigate';
    layout
    {

        modify(Status)
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Vendor Cr. Memo No.")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Currency Code")
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
        modify("Document Date")
        {
            Visible = true;
        }
        moveafter("No."; Status, "Posting Date", "Document Date", "Buy-from Vendor No.", "Buy-from Vendor Name", "Pay-to Vendor No.", "Pay-to Name",
         Amount, "Due Date", "Currency Code")
        addafter("Pay-to Name")
        {

            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
                Caption = 'Posting Description"';
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
        addafter("Currency Code")
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
            action("AP CN Voucher")
            {
                Caption = 'AP CN Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    APCNVoucher: Report "AP CN Voucher";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset;
                    PurchaseHeader.Copy(Rec);
                    APCNVoucher."SetGLEntry"(PurchaseHeader);
                    APCNVoucher.RunModal();
                end;
            }
        }
    }
}