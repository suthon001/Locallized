pageextension 80041 "ExtenPostPurchCreditLists" extends "Posted Purchase Credit Memos"
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
    }
}