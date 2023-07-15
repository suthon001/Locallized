pageextension 80098 "NCT Transfer Order" extends "Transfer Order"
{
    actions
    {
        addafter("&Print")
        {
            action("Transfer Order Document")
            {
                Caption = 'Transfer Order';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'View which items are currently on inbound transfer orders.';
                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.Reset();
                    TransferHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"NCT Transfer Order", true, false, TransferHeader);
                end;

            }
        }
    }
}
