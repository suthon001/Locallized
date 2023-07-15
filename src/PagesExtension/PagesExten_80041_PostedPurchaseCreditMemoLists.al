/// <summary>
/// PageExtension NCT ExtenPostPurchCreditLists (ID 80041) extends Record Posted Purchase Credit Memos.
/// </summary>
pageextension 80041 "NCT ExtenPostPurchCreditLists" extends "Posted Purchase Credit Memos"
{
    layout
    {

        modify("No. Printed")
        {
            Visible = false;
        }
        modify(Cancelled)
        {
            Visible = false;
        }
        modify(Paid)
        {
            Visible = false;
        }

        modify(Corrective)
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Document Date")
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


        moveafter("No."; "Posting Date", "Document Date", "Due Date", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name",
        "Currency Code", "Location Code", Amount, "Amount Including VAT", "Remaining Amount")

    }
    actions
    {
        modify("&Navigate")
        {
            Promoted = true;
            PromotedCategory = Category5;
        }
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
                ToolTip = 'Executes the AP Voucher action.';
                trigger OnAction()
                var
                    APVoucher: Report "NCT AP CN Voucher (Post)";
                    PurchaseHeader: Record "Purch. Cr. Memo Hdr.";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.Copy(Rec);
                    APVoucher."SetGLEntry"(PurchaseHeader);
                    APVoucher.RunModal();
                end;
            }
        }
    }
}