pageextension 80011 "Purchase Quotes Lists" extends "Purchase Quotes"
{

    layout
    {
        addlast(Control1)
        {
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
            field("Purchase Order No."; rec."Purchase Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("Expected Receipt Date"; rec."Expected Receipt Date")
            {
                ApplicationArea = all;
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
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset;
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"PurchaseQuotes", true, true, PurchaseHeader);
                end;
            }
        }
    }
}