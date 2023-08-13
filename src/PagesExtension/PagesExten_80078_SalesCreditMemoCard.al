/// <summary>
/// PageExtension NCT Sales Credit Memo Card (ID 80078) extends Record Sales Credit Memo.
/// </summary>
pageextension 80078 "NCT Sales Credit Memo Card" extends "Sales Credit Memo"
{
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Credit Memo,Request Approval,Navigate';
    layout
    {
        addbefore(Status)
        {
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }

        }
        modify("VAT Registration No.")
        {
            Visible = true;
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
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
        addafter("Applies-to ID")
        {
            field("NCT Ref. Tax Invoice Date"; rec."NCT Ref. Tax Invoice Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice Amount field.';
            }
            field("NCT Ref. Tax Invoice Amount"; rec."NCT Ref. Tax Invoice Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice Amount field.';
            }

        }
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
                ToolTip = 'Show Report';
                trigger OnAction()
                var
                    ARCNVoucher: Report "NCT AR CN Voucher";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.RESET();
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
                ToolTip = 'Show Report';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Report Sales Credit Memo", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }
}