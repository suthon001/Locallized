pageextension 80047 "PostedReturnReceipt" extends "Posted Return Receipts"
{
    PromotedActionCategories = 'New,Process,Print';
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
                trigger OnAction()
                var
                    ReturnHeader: Record "Return Receipt Header";
                // SalesReturnOrder: Report "Sales Return Order";
                begin
                    ReturnHeader.RESET;
                    ReturnHeader.SetRange("Return Order No.", rec."No.");
                    Report.Run(Report::"Sales Return Receipt", TRUE, TRUE, ReturnHeader);
                end;
            }
        }
    }
}