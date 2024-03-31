/// <summary>
/// PageExtension NCT Sales Order Card (ID 80063) extends Record Sales Order.
/// </summary>
pageextension 80063 "NCT Sales Order Card" extends "Sales Order"
{
    layout
    {
        addbefore(Status)
        {
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Shipping No. Series"; Rec."Shipping No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }

        }
        modify("VAT Registration No.")
        {
            Visible = true;
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("No.")
        {
            Visible = true;
        }
        modify("Sell-to Customer No.")
        {
            Visible = true;
            ApplicationArea = all;
            Importance = Promoted;

        }


        modify("Salesperson Code")
        {
            Visible = true;
            Importance = Standard;
        }
        modify(Status)
        {
            Importance = Promoted;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Importance = Standard;
        }


        moveafter("Due Date"; "Shipment Date")
        moveafter("External Document No."; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Salesperson Code")
        moveafter("Posting Date"; "Document Date")


    }
    actions
    {

        addlast(Reporting)
        {

            action("Print_Sales_Order")
            {
                ApplicationArea = All;
                Caption = 'Sales Order';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Order action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Report Sales Order", TRUE, TRUE, RecSalesHeader);
                end;
            }
            action("SalesShipment")
            {
                ApplicationArea = All;
                Caption = 'Sales Shipment';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Shipment action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Shipment Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetCurrentKey("Order No.");
                    RecSalesHeader.SetRange("ORder No.", rec."No.");
                    if RecSalesHeader.FindLast() then
                        Report.Run(Report::"NCT Sales Shipment", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}