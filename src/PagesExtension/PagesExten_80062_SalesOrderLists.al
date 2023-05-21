pageextension 80062 "Sales Order Lists" extends "Sales Order List"
{

    layout
    {
        modify("Bill-to Customer No.")
        {
            Visible = true;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Ship-to Name")
        {
            Visible = false;
        }
        modify("Sell-to Customer Name")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Completely Shipped")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = true;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY)")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY) Base")
        {
            Visible = false;
        }


        moveafter("No."; Status, "Posting Date", "Sell-to Customer No.", "Bill-to Customer No.",
        "Sell-to Customer Name", "External Document No.", "Document Date", "Due Date", "Quote No.", Amount, "Amount Including VAT")
        addafter("Quote No.")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
                Caption = 'Your Reference';
            }
        }
        addafter("Amount Including VAT")
        {
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
                Caption = 'Branch Code';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
            }
        }

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
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET;
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"Report Sales Order", TRUE, TRUE, RecSalesHeader);
                end;
            }
            action("Sales Shipment")
            {
                ApplicationArea = All;
                Caption = 'Sales Shipment';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Shipment Header";
                begin
                    RecSalesHeader.RESET;
                    RecSalesHeader.SetCurrentKey("Order No.");
                    RecSalesHeader.SetRange("Order No.", rec."No.");
                    if RecSalesHeader.FindLast() then
                        Report.Run(Report::"Sales Shipment", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}