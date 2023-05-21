pageextension 80058 "PostedReturnReceiptCard" extends "Posted Return Receipt"
{

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
                PromotedCategory = Category4;
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