pageextension 80033 "SalesOrderLists" extends "Sales Return Order List"

{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = true;
        }
        modify("Bill-to Customer No.")
        {
            Visible = true;
        }
        modify("Salesperson Code")
        {
            Visible = true;

        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        moveafter("No."; Status, "Sell-to Customer No.", "Bill-to Customer No.", "Sell-to Customer Name", "External Document No.", "Salesperson Code",
        "Shipment Date", "Due Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", Amount, "Amount Including VAT")

        addafter("Salesperson Code")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipment Date")
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Due Date")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Code")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(Reporting)
        {

            action("Print Return Order")
            {
                ApplicationArea = All;
                Caption = 'Sales Return Order';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                // SalesReturnOrder: Report "Sales Return Order";
                begin
                    RecSalesHeader.RESET;
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"Sales Return Order", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}