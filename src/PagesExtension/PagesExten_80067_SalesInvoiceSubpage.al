/// <summary>
/// PageExtension Sales Invoice Subpage (ID 80067) extends Record Sales Invoice Subform.
/// </summary>
pageextension 80067 "NCT Sales Invoice Subpage" extends "Sales Invoice Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")

        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Business Posting Group"; Rec."NCT WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("WHT Product Posting Group"; rec."NCT WHT Product Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
        modify("Depr. until FA Posting Date")
        {
            Visible = true;
        }
        moveafter(Quantity; "Depr. until FA Posting Date")

        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        moveafter("VAT Bus. Posting Group"; "VAT Prod. Posting Group")
    }
    trigger OnDeleteRecord(): Boolean
    var
        NCTFunctionCenter: Codeunit "NCT Function Center";
    begin
        if rec."Shipment No." <> '' then
            NCTFunctionCenter.SetDefualtGetInvoiceSales(rec."Shipment No.", Rec."Shipment Line No.");
    end;

}