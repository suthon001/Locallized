pageextension 80051 "ApplyCustEntries" extends "Apply Customer Entries"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }
        moveafter("Document No."; "External Document No.")
        addafter("External Document No.")
        {
            field("LS Sales Billing No."; SalesBillingDocNo)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies value of the field.';
                Caption = 'Sales Billing No.';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        BillingReceiptLine: Record "Billing Receipt Line";
    begin
        SalesBillingDocNo := '';
        BillingReceiptLine.reset();
        BillingReceiptLine.SetRange("Document Type", BillingReceiptLine."Document Type"::"Sales Billing");
        BillingReceiptLine.SetRange("Source Ledger Entry No.", Rec."Entry No.");
        if BillingReceiptLine.FindFirst() then
            SalesBillingDocNo := BillingReceiptLine."Document No.";
    end;

    var
        SalesBillingDocNo: Code[20];
}