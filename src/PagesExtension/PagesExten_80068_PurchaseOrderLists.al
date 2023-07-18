/// <summary>
/// PageExtension NCT Purchase Order Lists (ID 80068) extends Record Purchase Order List.
/// </summary>
pageextension 80068 "NCT Purchase Order Lists" extends "Purchase Order List"
{
    layout
    {
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        addlast(Control1)
        {
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("Branch Code"; Rec."NCT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'Branch Code';
                ToolTip = 'Specifies the value of the Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
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
        modify(Print)
        {
            Visible = false;
        }
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
}