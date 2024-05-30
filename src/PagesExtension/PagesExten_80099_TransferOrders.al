/// <summary>
/// PageExtension NCT Transfer Orders (ID 80099) extends Record Transfer Orders.
/// </summary>
pageextension 80099 "NCT Transfer Orders" extends "Transfer Orders"
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

