pageextension 80037 "PostedReceiptCard" extends "Posted Purchase Receipt"
{

    layout
    {
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }

    }
    actions
    {
        addlast(Reporting)
        {
            action("Purchase Receipt")
            {
                Caption = 'Purchase Receipt';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Category5;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Purchase Receipt action.';
                trigger OnAction()
                var
                    PurchaseRecripet: Record "Purch. Rcpt. Header";
                begin
                    PurchaseRecripet.reset();
                    PurchaseRecripet.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"Good Receipt Note", true, true, PurchaseRecripet);
                end;
            }
        }
    }

}