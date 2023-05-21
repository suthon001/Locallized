pageextension 80068 "Purchase Order Lists" extends "Purchase Order List"
{
    layout
    {
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        addlast(Control1)
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
        modify(Status)
        {
            Visible = true;
        }
        moveafter("No."; Status)
    }
    actions
    {

        modify(Post)
        {
            Visible = false;
        }
        modify(PostAndPrint)
        {
            Visible = false;
        }
        modify(PostBatch)
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
                PromotedCategory = Category5;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset;
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"PurchaseOrder", true, true, PurchaseHeader);
                end;
            }
        }
    }
}