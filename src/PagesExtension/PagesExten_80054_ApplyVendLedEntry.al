pageextension 80054 "ApplyVendLedgEntry" extends "Apply Vendor Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("LS Purch. Billing No."; PurchBillingDocNo)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the PurchBillingDocNo field.';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchBillingLine: Record "Billing Receipt Line";
    begin
        PurchBillingDocNo := '';
        PurchBillingLine.reset();
        PurchBillingLine.SetRange("Document Type", PurchBillingLine."Document Type"::"Purchase Billing");
        PurchBillingLine.SetRange("Source Ledger Entry No.", Rec."Entry No.");
        if PurchBillingLine.FindFirst() then
            PurchBillingDocNo := PurchBillingLine."Document No.";
    end;

    var
        PurchBillingDocNo: Code[20];
}