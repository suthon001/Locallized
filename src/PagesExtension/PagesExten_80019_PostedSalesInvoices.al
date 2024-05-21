/// <summary>
/// PageExtension NCT Posted Sales Invoices (ID 80019) extends Record Posted Sales Invoices.
/// </summary>
pageextension 80019 "NCT Posted Sales Invoices" extends "Posted Sales Invoices"
{
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
                ToolTip = 'Executes the AR Voucher action.';
                trigger OnAction()
                var
                    ARVoucher: Report "NCT AR Voucher";
                    SalesHeader: Record "Sales Invoice Header";
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
            action("Print_Sales_Invoice")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoice';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Invoice action.';
                trigger OnAction()
                var
                    SalesInvoiceReport: Report "NCT Report Sales Invoice";
                    SalesHeader: Record "Sales Invoice Header";
                begin
                    CLEAR(SalesInvoiceReport);
                    SalesHeader.reset();
                    SalesHeader.SetRange("No.", rec."No.");
                    if SalesHeader.FindFirst() then
                        SalesInvoiceReport.SetDataTable(SalesHeader);
                    SalesInvoiceReport.RunModal();
                    CLEAR(SalesInvoiceReport);
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
                ToolTip = 'Executes the Debit Note action.';
                trigger OnAction()
                var
                    SalesDebitNoteReport: Report "NCT Debit Note";
                    SalesHeader: Record "Sales Invoice Header";
                begin
                    CLEAR(SalesDebitNoteReport);
                    SalesHeader.reset();
                    SalesHeader.SetRange("No.", rec."No.");
                    if SalesHeader.FindFirst() then
                        SalesDebitNoteReport.SetDataTable(SalesHeader);
                    SalesDebitNoteReport.RunModal();
                    CLEAR(SalesDebitNoteReport);
                end;
            }
        }
    }
}
