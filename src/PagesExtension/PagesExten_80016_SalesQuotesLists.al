pageextension 80016 "Sales Quotes Lists" extends "Sales Quotes"
{
    layout
    {

        modify("Bill-to Customer No.")
        {
            Visible = true;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify(Status)
        {
            Visible = true;
        }
        modify("Sell-to Contact")
        {
            Visible = false;
        }

        moveafter("No."; Status, "Sell-to Customer No.", "Bill-to Customer No.", "Sell-to Customer Name", "External Document No.", "Posting Date", "Document Date", "Due Date",
        "Quote Valid Until Date", Amount)
        modify("Your Reference")
        {
            Visible = true;
        }
        moveafter("Quote Valid Until Date"; "Your Reference")

        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
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
                ToolTip = 'Specifies value of the field.';

            }
            field("Sales Order No."; rec."Sales Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }

    }
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addlast(Reporting)
        {

            action("Print_Sales_Quotes")
            {
                ApplicationArea = All;
                Caption = 'Sales Quotes';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category6;
                ToolTip = 'Show Report';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"Report Sales Quotes", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}