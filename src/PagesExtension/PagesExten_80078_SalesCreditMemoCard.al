pageextension 80078 "Sales Credit Memo Card" extends "Sales Credit Memo"
{
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Credit Memo,Request Approval,Navigate';
    layout
    {
        addafter(Status)
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
        modify("No.")
        {
            Visible = true;
        }
        modify("Sell-to Customer No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        moveafter("External Document No."; "Salesperson Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
    }
    actions
    {
        addlast(Reporting)
        {
            action("AR CN Voucher")
            {
                Caption = 'AR CN Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ARCNVoucher: Report "AR CN Voucher";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.reset;
                    SalesHeader.Copy(Rec);
                    ARCNVoucher."SetGLEntry"(SalesHeader);
                    ARCNVoucher.RunModal();
                end;
            }
            action("Print_Sales_CreditMemo")
            {
                ApplicationArea = All;
                Caption = 'Sales Credit Memo';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET;
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"Report Sales Credit Memo", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }
}