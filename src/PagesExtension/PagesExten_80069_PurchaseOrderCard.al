/// <summary>
/// PageExtension NCT Purchase Order Card (ID 80069) extends Record Purchase Order.
/// </summary>
pageextension 80069 "NCT Purchase Order Card" extends "Purchase Order"
{

    layout
    {
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        addbefore(Status)
        {
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
        }
        modify("No.")
        {
            Visible = true;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = true;
            Importance = Standard;
        }
        modify(General)
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Invoice Details")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Shipping and Payment")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Foreign Trade")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify(Prepayment)
        {
            Editable = Rec.Status = Rec.Status::Open;
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
        movebefore(Status; "Expected Receipt Date", "Location Code")
        moveafter("Posting Date"; "Document Date", "Due Date")
        modify("Vendor Cr. Memo No.") { Editable = true; }

    }
    actions
    {

        modify(Post)
        {
            Visible = false;
        }
        modify("Post and &Print")
        {
            Visible = false;
        }
        modify("Post &Batch")
        {
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
        }
        addlast(Reporting)
        {
            action("Purchase Order")
            {
                Caption = 'Purchase Order';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Purchase Order action.';
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"NCT PurchaseOrder", true, true, PurchaseHeader);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        PurchaseReceipt: Record "Purch. Rcpt. Header";
        CheckbeforDelete: Boolean;
    begin
        CheckbeforDelete := true;
        "OnBeforDeletePurchaseHeader"(CheckbeforDelete);
        if CheckbeforDelete then begin
            PurchaseReceipt.reset();
            PurchaseReceipt.SetRange("Order No.", Rec."No.");
            if not PurchaseReceipt.IsEmpty() then
                ERROR('Cannot Delete this document has been Posted');
        end;
    end;

    [IntegrationEvent(false, false)]
    /// <summary> 
    /// Description for OnBeforDeletePurchaseHeader.
    /// </summary>
    /// <param name="CheckDelete">Parameter of type Boolean.</param>
    procedure "OnBeforDeletePurchaseHeader"(var CheckDelete: Boolean)
    begin
    end;


}