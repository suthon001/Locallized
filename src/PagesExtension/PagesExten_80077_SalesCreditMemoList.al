/// <summary>
/// PageExtension Sales Creidt Lists (ID 80077) extends Record Sales Credit Memos.
/// </summary>
pageextension 80077 "NCT Sales Creidt Lists" extends "Sales Credit Memos"
{

    layout
    {
        addbefore(Status)
        {
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the customer''s VAT registration number for customers.';
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
            action("AR CN Voucher")
            {
                Caption = 'AR CN Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the AR CN Voucher action.';
                trigger OnAction()
                var
                    ARVoucher: Report "NCT AR CN Voucher";
                    SalesHeader: Record "Sales Header";
                begin
                    CLEAR(ARVoucher);
                    SalesHeader.reset();
                    SalesHeader.SetRange("Document Type", rec."Document Type");
                    SalesHeader.SetRange("No.", rec."No.");
                    if SalesHeader.FindFirst() then
                        ARVoucher.SetDataTable(SalesHeader);
                    ARVoucher.RunModal();
                    CLEAR(ARVoucher);
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
                ToolTip = 'Executes the Sales Credit Memo action.';
                trigger OnAction()
                var
                    SalesCreditMemoReport: Report "NCT Report Sales Credit Memo";
                    SalesHeader: Record "Sales Header";
                begin
                    CLEAR(SalesCreditMemoReport);
                    SalesHeader.reset();
                    SalesHeader.SetRange("Document Type", rec."Document Type");
                    SalesHeader.SetRange("No.", rec."No.");
                    SalesCreditMemoReport.SetTableView(SalesHeader);
                    if SalesHeader.FindFirst() then
                        SalesCreditMemoReport.SetDataTable(SalesHeader);
                    SalesCreditMemoReport.RunModal();
                    CLEAR(SalesCreditMemoReport);
                end;
            }
        }
    }
}