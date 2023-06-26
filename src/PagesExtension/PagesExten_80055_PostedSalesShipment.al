/// <summary>
/// PageExtension NCT PostedSalesShipment (ID 80055) extends Record Posted Sales Shipment.
/// </summary>
pageextension 80055 "NCT PostedSalesShipment" extends "Posted Sales Shipment"
{
    PromotedActionCategories = 'New,Process,Report,Print/Send,Shipment';
    actions
    {
        addlast(Reporting)
        {

            action("Sales Shipment")
            {
                ApplicationArea = All;
                Caption = 'Sales Shipment';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Sales Shipment action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Shipment Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Sales Shipment", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}