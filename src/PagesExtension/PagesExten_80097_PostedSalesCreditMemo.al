/// <summary>
/// PageExtension NCT Posted Sales Credit Memo (ID 80097) extends Record Posted Sales Credit Memo.
/// </summary>
pageextension 80097 "NCT Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
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
        addafter("Applies-to Doc. No.")
        {
            field("NCT Applies-to ID"; rec."NCT Applies-to ID")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Applies-to ID. field.';
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
                ToolTip = 'Executes the AR CN Voucher action.';
                trigger OnAction()
                var
                    ARCNVoucher: Report "NCT AR CN Voucher (Post)";
                    SalesHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesHeader.reset();
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
                ToolTip = 'Executes the Sales Credit Memo action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Cr.Memo Header";
                begin
                    RecSalesHeader.RESET();

                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Sales Credit Memo (Post)", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }


}
