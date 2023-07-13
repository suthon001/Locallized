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
        modify("Line Discount Amount")
        {
            Visible = true;
        }
        modify(FilteredTypeField)
        {
            Visible = false;
        }
        modify(Type)
        {
            ApplicationArea = all;
        }
        moveafter(Quantity; "Over-Receipt Code", "Over-Receipt Quantity")
        modify("Bin Code") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        modify("Promised Receipt Date") { Visible = false; }
        modify("Item Charge Qty. to Handle") { Visible = false; }
        modify("Planned Receipt Date") { Visible = false; }
        modify("Expected Receipt Date") { Visible = false; }

        modify("Item Reference No.") { Visible = false; }
        modify("VAT Bus. Posting Group") { Visible = true; }
        modify("VAT Prod. Posting Group") { Visible = true; }
        modify("Gen. Bus. Posting Group") { Visible = true; }
        modify("Gen. Prod. Posting Group") { Visible = true; }
        movefirst(Control1; Type, "No.", Description, "Description 2", "Location Code", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group", Quantity, "Unit of Measure Code", "Direct Unit Cost", "Line Discount %", "Line Discount Amount", "Line Amount",
        "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8, "Qty. to Receive", "Quantity Received", "Qty. to Invoice", "Quantity Invoiced")
        addafter("Qty. to Receive")
        {
            field("NCT Qty. to Cancel"; rec."NCT Qty. to Cancel")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Qty. to Cancel field.';
            }
        }

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