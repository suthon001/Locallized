pageextension 80071 "Purchase Invoice Card" extends "Purchase Invoice"
{
    PromotedActionCategories = 'New,Process,Print,Approve,Invoice,Posting,View,Request Approval,Incoming Document,Release,Navigate';
    layout
    {
        addbefore(Status)
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Bus. Posting Group';
            }

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
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
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