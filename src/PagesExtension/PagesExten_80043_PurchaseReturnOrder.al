pageextension 80043 "PurchaseReturnOrderCard" extends "Purchase Return Order"

{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            Importance = Standard;
        }
        modify("Posting Date")
        {
            Importance = Standard;
        }
        modify("Document Date")
        {
            Importance = Standard;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        addlast(General)
        {
            field("Return Shipment No. Series"; Rec."Return Shipment No. Series")
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {
        addlast(Reporting)
        {
            action("Purchase Return Order")
            {
                Caption = 'Purchase Return Order';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Category10;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset;
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"PurchaseReturnOrder", true, true, PurchaseHeader);
                end;
            }
        }
    }
}