/// <summary>
/// PageExtension NCT Posted Sales Credit Memos (ID 80096) extends Record Posted Sales Credit Memos.
/// </summary>
pageextension 80096 "NCT Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
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
                    SalesHeader: Record "Sales Cr.Memo Header";
                begin
                    CLEAR(ARVoucher);
                    SalesHeader.reset();
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
                    SalesHeader: Record "Sales Cr.Memo Header";
                begin
                    CLEAR(SalesCreditMemoReport);
                    SalesHeader.reset();
                    SalesHeader.SetRange("No.", rec."No.");
                    if SalesHeader.FindFirst() then
                        SalesCreditMemoReport.SetDataTable(SalesHeader);
                    SalesCreditMemoReport.RunModal();
                    CLEAR(SalesCreditMemoReport);
                end;
            }
        }
    }
}