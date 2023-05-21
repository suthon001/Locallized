pageextension 80065 "Sales Invoice Lists" extends "Sales Invoice List"
{
    PromotedActionCategories = 'New,Process,Print,Request Approval,Credit Memo,Release,Posting,Navigate';
    layout
    {
        addbefore(Status)
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
        modify(Status)
        {
            Visible = true;
        }
        moveafter("No."; Status)
    }
    actions
    {

        addlast(Reporting)
        {
            action("AR Voucher")
            {
                Caption = 'AR Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ARVoucher: Report "AR Voucher";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.reset;
                    SalesHeader.Copy(Rec);
                    ARVoucher."SetGLEntry"(SalesHeader);
                    ARVoucher.RunModal();
                end;
            }
            action("Print_Sales_Invoice")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoice';
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
                    Report.Run(Report::"Report Sales Invoice", TRUE, TRUE, RecSalesHeader);
                end;
            }
            action("Print_DebitNote")
            {
                ApplicationArea = All;
                Caption = 'Debit Note';
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
                    Report.Run(Report::"Debit Note", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }
}