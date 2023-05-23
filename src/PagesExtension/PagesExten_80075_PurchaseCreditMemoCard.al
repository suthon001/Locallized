pageextension 80075 "Purchase Credit Memo Card" extends "Purchase Credit Memo"
{
    PromotedActionCategories = 'New,Process,Print,Approve,Request Approval,Credit Memo,Release,Posting,Navigate';
    layout
    {
        addbefore(Status)
        {
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
                Caption = 'Branch Code';
                ToolTip = 'Specifies the value of the Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
            field("Return Shipment No. Series"; Rec."Return Shipment No. Series")
            {
                ApplicationArea = all;
                Caption = 'Return Shipment No. Series';
                ToolTip = 'Specifies the value of the Return Shipment No. Series field.';
            }
        }
        modify("No.")
        {
            Visible = true;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        moveafter("Vendor Cr. Memo No."; "Purchaser Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        movebefore("Vendor Cr. Memo No."; "Posting Description")

    }
    actions
    {
        addlast(Reporting)
        {
            action("APCNVoucher")
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
                    APCNVoucher: Report "AP CN Voucher";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.Copy(Rec);
                    APCNVoucher."SetGLEntry"(PurchaseHeader);
                    APCNVoucher.RunModal();
                end;
            }
        }
    }
}