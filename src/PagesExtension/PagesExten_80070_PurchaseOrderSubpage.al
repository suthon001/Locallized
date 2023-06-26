/// <summary>
/// PageExtension NCT Purchase Order Subpage (ID 80070) extends Record Purchase Order Subform.
/// </summary>
pageextension 80070 "NCT Purchase Order Subpage" extends "Purchase Order Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("Ref. PQ No."; rec."NCT Ref. PQ No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. PR No. field.';
            }
            field("Ref. PQ Line No."; rec."NCT Ref. PQ Line No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. PR Line No. field.';
            }
        }
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")



        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Over-Receipt Code")
        {
            Visible = true;
        }
        modify("Over-Receipt Quantity")
        {
            Visible = true;
        }
        moveafter(Quantity; "Over-Receipt Code", "Over-Receipt Quantity")


    }
    actions
    {
        addlast(processing)
        {
            action("Get Purchase Lines")
            {
                Caption = 'Get Purchase Lines';
                Image = GetLines;
                ApplicationArea = all;
                ToolTip = 'Executes the Get Purchase Lines action.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.GET(rec."Document Type", rec."Document No.");
                    PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
                    rec.GetPurchaseQuotesLine();
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        PQLine: Record "Purchase Line";
    begin
        if rec."NCT Ref. PQ No." <> '' then
            if PQLine.GET(PQLine."Document Type"::Quote, rec."NCT Ref. PQ No.", rec."NCT Ref. PQ Line No.") then begin
                PQLine."Outstanding Quantity" := PQLine."Outstanding Quantity" + rec.Quantity;
                PQLine."Outstanding Qty. (Base)" := PQLine."Outstanding Qty. (Base)" + rec."Quantity (Base)";
                PQLine."Completely Received" := PQLine."Outstanding Quantity" = 0;
                PQLine.Modify();
            end;
    end;

}