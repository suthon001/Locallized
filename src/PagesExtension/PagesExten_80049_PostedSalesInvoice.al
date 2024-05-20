/// <summary>
/// PageExtension NCT Posted Sales Invoice (ID 80049) extends Record Posted Sales Invoice.
/// </summary>
pageextension 80049 "NCT Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addlast(General)
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
            field("NCT Ref. Tax Invoice No."; rec."NCT Ref. Tax Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice No. field.';
            }
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

        modify("VAT Registration No.")
        {
            Visible = true;
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;

        }
        modify("Posting Date")
        {
            Visible = true;
        }


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
                    RecSalesHeader: Record "Sales Invoice Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Sales Invoice (Post)", TRUE, TRUE, RecSalesHeader);
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
                    RecSalesHeader: Record "Sales Invoice Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Debit Note (Post)", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }
}
