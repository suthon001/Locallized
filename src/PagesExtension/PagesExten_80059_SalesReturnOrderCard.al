/// <summary>
/// PageExtension NCT SalesReturnOrder (ID 80059) extends Record Sales Return Order.
/// </summary>
pageextension 80059 "NCT SalesReturnOrder" extends "Sales Return Order"
{
    layout
    {
        modify("No.")
        {
            Visible = true;
        }
        modify("Sell-to Customer No.")
        {
            Importance = Standard;
        }

        modify(Status)
        {
            Importance = Promoted;
        }
        modify("Document Date")
        {
            Importance = Standard;
        }

    }
    actions
    {
        addlast(Reporting)
        {

            action("Print Return Order")
            {
                ApplicationArea = All;
                Caption = 'Sales Return Order';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Return Order action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                // SalesReturnOrder: Report "Sales Return Order";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Sales Return Order", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}