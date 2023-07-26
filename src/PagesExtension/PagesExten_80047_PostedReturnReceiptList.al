/// <summary>
/// PageExtension NCT PostedReturnReceipt (ID 80047) extends Record Posted Return Receipts.
/// </summary>
pageextension 80047 "NCT PostedReturnReceipt" extends "Posted Return Receipts"
{
    PromotedActionCategories = 'New,Process,Print';
    layout
    {
        addafter("No.")
        {
            field("Return Order No."; rec."Return Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number of the return order that will post a return shipment.';
            }
        }
    }
    actions
    {
        addlast(Reporting)
        {

            action("Print Return Receipt")
            {
                ApplicationArea = All;
                Caption = 'Sales Return Receipt';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Return Receipt action.';
                trigger OnAction()
                var
                    ReturnHeader: Record "Return Receipt Header";
                begin
                    ReturnHeader.RESET();
                    ReturnHeader.SetRange("Return Order No.", rec."No.");
                    Report.Run(Report::"NCT Sales Return Receipt", TRUE, TRUE, ReturnHeader);
                end;
            }
        }
    }
}