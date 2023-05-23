pageextension 80056 "SalesBlanketCard" extends "Blanket Sales Order"
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
                    Report.Run(Report::"Report Sales Blanket", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}