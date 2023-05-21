pageextension 80035 "PurchaseBlnketCard" extends "Blanket Purchase Order"
{

    trigger OnDeleteRecord(): Boolean
    var
        PurchaseLInes: Record "Purchase Line";
    begin
        PurchaseLInes.reset;
        PurchaseLInes.SetRange("Document Type", PurchaseLInes."Document Type"::Order);
        PurchaseLInes.SetRange("Blanket Order No.", Rec."No.");
        if PurchaseLInes.FindFirst() then
            ERROR('Has been Make to Order')
    end;
}