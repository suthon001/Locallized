/// <summary>
/// PageExtension NCT Sales Quote Card (ID 80017) extends Record Sales Quote.
/// </summary>
pageextension 80017 "NCT Sales Quote Card" extends "Sales Quote"
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
            field("Branch Code"; Rec."NCT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the customer''s VAT registration number for customers.';
            }
            field("Sales Order No."; Rec."NCT Sales Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Make Order No. Series"; Rec."NCT Make Order No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Make Order No. Series field.';
                trigger OnAssistEdit()
                var
                    SalesSetup: Record "Sales & Receivables Setup";
                    Noseriesmgt: Codeunit NoSeriesManagement;
                begin
                    SalesSetup.get();
                    SalesSetup.TestField("Order Nos.");
                    Noseriesmgt.SelectSeries(SalesSetup."Order Nos.", Rec."No. Series", Rec."NCT Make Order No. Series");
                end;
            }
        }
        modify("No.")
        {
            Visible = true;
        }
        modify("Sell-to Customer No.")
        {
            Importance = Standard;
        }

        modify(Status)
        {
            Importance = Promoted;
        }
        modify("Document Date")
        {
            Importance = Standard;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }

        moveafter("External Document No."; "Salesperson Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        moveafter("Make Order No. Series"; "VAT Bus. Posting Group")
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }
        }
        addbefore("Document Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the date when the sales document was posted.';
            }
        }
        addafter("Sell-to City")
        {
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the telephone number of the contact person that the sales document will be sent to.';
            }
        }
        addafter(Status)
        {
            field("Completely Shipped"; rec."Completely Shipped")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Caption = 'Completely';
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
                PromotedCategory = Category9;
                ToolTip = 'Executes the Sales Quotes action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Report Sales Quotes", TRUE, TRUE, RecSalesHeader);
                end;
            }

        }

    }
    trigger OnDeleteRecord(): Boolean
    var
        Handled: Boolean;
    begin
        Handled := false;
        "OnBeforeDeleteRecord"(Rec, Handled);
        if not Handled then
            ERROR('Cannot Delete Record');
    end;


    /// <summary>
    /// OnBeforeDeleteRecord.
    /// </summary>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="Handled">VAR Boolean.</param>
    [IntegrationEvent(false, false)]
    procedure "OnBeforeDeleteRecord"(var SalesHeader: Record "Sales Header"; var Handled: Boolean)
    begin
    end;
}