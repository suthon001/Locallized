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
        addafter("Quote Valid Until Date")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
            }


        }
        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
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
                Caption = 'VAT Registration No.';
            }
            field("Sales Order No."; rec."Sales Order No.")
            {
                ApplicationArea = all;
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
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET;
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"Report Sales Quotes", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }
    }
}