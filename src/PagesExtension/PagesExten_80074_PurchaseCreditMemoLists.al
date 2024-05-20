/// <summary>
/// PageExtension NCT Purchase Credit MemosLists (ID 80074) extends Record Purchase Credit Memos.
/// </summary>
pageextension 80074 "NCT Purchase Credit MemosLists" extends "Purchase Credit Memos"
{

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
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
            }

        }

        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
                Caption = 'Amount Including VAT';
                ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
            }
        }
        addafter("Currency Code")
        {
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
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
                ToolTip = 'Executes the AP CN Voucher action.';
                trigger OnAction()
                var
                    APCNVoucher: Report "NCT AP CN Voucher";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    if PurchaseHeader.FindFirst() then
                        APCNVoucher.SetDataTable(PurchaseHeader);
                    APCNVoucher.RunModal();
                end;
            }
        }
    }
}