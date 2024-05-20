/// <summary>
/// PageExtension NCT Purchase Invoice Card (ID 80071) extends Record Purchase Invoice.
/// </summary>
pageextension 80071 "NCT Purchase Invoice Card" extends "Purchase Invoice"
{

    layout
    {
        addbefore(Status)
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
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
            }
        }
        modify("No.")
        {
            Visible = true;
        }
        moveafter("Purchaser Code"; "Currency Code")
        modify("Buy-from Vendor No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify(Status)
        {
            Importance = Standard;
        }
        modify("Posting Date")
        {
            Importance = Standard;
        }
        modify("Document Date")
        {
            Importance = Standard;
        }
        modify("Posting Description")
        {
            Visible = true;
        }
        moveafter("Currency Code"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        moveafter("Gen. Bus. Posting Group"; "VAT Bus. Posting Group")
        moveafter("Buy-from Contact"; "Posting Description")
        moveafter("Vendor Invoice No."; "Payment Terms Code", "Payment Method Code")




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
                ToolTip = 'Executes the AP Voucher action.';
                trigger OnAction()
                var
                    APVoucher: Report "NCT AP Voucher";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    clear(APVoucher);
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    if PurchaseHeader.FindFirst() then
                        APVoucher."SetDataTable"(PurchaseHeader);
                    APVoucher.RunModal();
                    clear(APVoucher);
                end;
            }
        }
    }

}