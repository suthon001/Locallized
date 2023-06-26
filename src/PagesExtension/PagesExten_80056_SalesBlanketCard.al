/// <summary>
/// PageExtension NCT SalesBlanketCard (ID 80056) extends Record Blanket Sales Order.
/// </summary>
pageextension 80056 "NCT SalesBlanketCard" extends "Blanket Sales Order"
{
    actions
    {
        addlast(Reporting)
        {

            action("Print_Blanket_Sales_Order")
            {
                ApplicationArea = All;
                Caption = 'Blanket Sales Order';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category6;
                ToolTip = 'Executes the Blanket Sales Order action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Report Sales Blanket", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}