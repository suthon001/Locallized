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
                ToolTip = 'Specifies the date when the order was created.';
            }
        }
        addafter("Shipment Date")
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
            }
        }
        addafter("Due Date")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s reference. The content will be printed on sales documents.';
            }
        }
        addafter("Location Code")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
            }
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s VAT registration number for customers.';
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
                ToolTip = 'Executes the Sales Return Order action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                // SalesReturnOrder: Report "Sales Return Order";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"Sales Return Order", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}