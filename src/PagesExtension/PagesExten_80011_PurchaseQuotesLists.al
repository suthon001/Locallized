/// <summary>
/// PageExtension Purchase Quotes Lists (ID 80011) extends Record Purchase Quotes.
/// </summary>
pageextension 80011 "Purchase Quotes Lists" extends "Purchase Quotes"
{

    layout
    {
        addlast(Control1)
        {
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Tax Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
            field("Purchase Order No."; rec."Purchase Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Order No. field.';
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("Expected Receipt Date"; rec."Expected Receipt Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
        modify(Status)
        {
            Visible = true;
        }
        moveafter("No."; Status)
    }
    actions
    {
        addlast(Reporting)
        {
            action("Purchase Quote")
            {
                Caption = 'Purchase Quote';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Category6;
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
                    REPORT.RunModal(REPORT::"PurchaseQuotes", true, true, PurchaseHeader);
                end;
            }
        }
    }
}