/// <summary>
/// PageExtension PostedPurchCreditMemoCard (ID 80042) extends Record Posted Purchase Credit Memo.
/// </summary>
pageextension 80042 "NCT PostedPurchCreditMemoCard" extends "Posted Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Bus. Posting Group';
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }

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
                ToolTip = 'Specifies the name of the vendor who delivered the items.';
            }
        }
        addafter("Buy-from Contact")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Posting Description field.';
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
                ToolTip = 'Executes the AP Voucher action.';
                trigger OnAction()
                var
                    APCNVoucher: Report "NCT AP CN Voucher";
                    PurchaseHeader: Record "Purch. Cr. Memo Hdr.";
                begin
                    clear(APCNVoucher);
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("No.", rec."No.");
                    if PurchaseHeader.FindFirst() then
                        APCNVoucher.SetDataTable(PurchaseHeader);
                    APCNVoucher.RunModal();
                    clear(APCNVoucher);
                end;

            }
        }
    }
}