/// <summary>
/// PageExtension NCT PurchaseBlnketCard (ID 80035) extends Record Blanket Purchase Order.
/// </summary>
pageextension 80035 "NCT PurchaseBlnketCard" extends "Blanket Purchase Order"
{

    trigger OnDeleteRecord(): Boolean
    var
        PurchaseLInes: Record "Purchase Line";
    begin
        PurchaseLInes.reset();
        PurchaseLInes.SetRange("Document Type", PurchaseLInes."Document Type"::Order);
        PurchaseLInes.SetRange("Blanket Order No.", Rec."No.");
        if not PurchaseLInes.IsEmpty then
            ERROR('Has been Make to Order')
    end;
}