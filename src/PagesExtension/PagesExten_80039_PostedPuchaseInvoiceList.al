/// <summary>
/// PageExtension PostedInvoiceList (ID 80039) extends Record Posted Purchase Invoices.
/// </summary>
pageextension 80039 "NCT PostedInvoiceList" extends "Posted Purchase Invoices"
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
        modify(Closed)
        {
            Visible = false;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = true;
        }
        modify("Pay-to Name")
        {
            Visible = true;
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
        modify("Payment Method Code")
        {
            Visible = true;
        }
        modify("Payment Terms Code")
        {
            Visible = true;
        }
        moveafter("No."; "Posting Date", "Document Date", "Due Date", "Vendor Invoice No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name",
        "Currency Code", "Location Code", "Payment Method Code", "Payment Terms Code", Amount, "Amount Including VAT", "Remaining Amount")
        addafter("Remaining Amount")
        {
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
        }
    }
    actions
    {
        modify(Navigate)
        {
            Promoted = true;
            PromotedCategory = Category8;
        }

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
                ToolTip = 'Executes the AP Voucher action.';
                trigger OnAction()
                var
                    APVoucher: Report "NCT AP Voucher (Post)";
                    PurchaseHeader: Record "Purch. Inv. Header";
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