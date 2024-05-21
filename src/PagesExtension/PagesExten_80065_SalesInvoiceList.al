/// <summary>
/// PageExtension NCT Sales Invoice Lists (ID 80065) extends Record Sales Invoice List.
/// </summary>
pageextension 80065 "NCT Sales Invoice Lists" extends "Sales Invoice List"
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
                    SalesHeader: Record "Sales Header";
                begin
                    CLEAR(SalesInvoiceReport);
                    SalesHeader.reset();
                    SalesHeader.SetRange("Document Type", rec."Document Type");
                    SalesHeader.SetRange("No.", rec."No.");
                    SalesInvoiceReport.SetTableView(SalesHeader);
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
                    SalesInvoiceReport: Report "NCT Debit Note";
                    SalesHeader: Record "Sales Header";
                begin
                    CLEAR(SalesInvoiceReport);
                    SalesHeader.reset();
                    SalesHeader.SetRange("Document Type", rec."Document Type");
                    SalesHeader.SetRange("No.", rec."No.");
                    SalesInvoiceReport.SetTableView(SalesHeader);
                    if SalesHeader.FindFirst() then
                        SalesInvoiceReport.SetDataTable(SalesHeader);
                    SalesInvoiceReport.RunModal();
                    CLEAR(SalesInvoiceReport);
                end;
            }
        }
    }
}