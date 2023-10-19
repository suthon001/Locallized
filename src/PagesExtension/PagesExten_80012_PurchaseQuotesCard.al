/// <summary>
/// PageExtension Purchase Quote Card (ID 80012) extends Record Purchase Quote.
/// </summary>
pageextension 80012 "NCT Purchase Quote Card" extends "Purchase Quote"
{
    layout
    {
        addbefore(Status)
        {

            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
            field("Purchase Order No."; rec."NCT Purchase Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Order No. field.';
            }
            field("NCT Make PO No. Series"; rec."NCT Make PO No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the NCT Make PO No. Series field.';
            }
        }
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Expected Receipt Date")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Visible = true;
        }
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
            }
        }
        moveafter("Purchaser Code"; "Currency Code")
        moveafter("Currency Code"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        moveafter("NCT Make PO No. Series"; "Expected Receipt Date", "Location Code")
        addafter(Status)
        {
            field("Completely Received"; rec."Completely Received")
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
            action("Purchase Quote")
            {
                Caption = 'Purchase Quote';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Purchase Quote action.';
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"NCT PurchaseQuotes", true, true, PurchaseHeader);
                end;
            }
        }
    }
}