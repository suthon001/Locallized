pageextension 80051 "ApplyCustEntries" extends "Apply Customer Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("LS Sales Billing No."; SalesBillingDocNo)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesBillingLine: Record "Billing Receipt Line";
    begin
        SalesBillingDocNo := '';
        SalesBillingLine.reset;
        SalesBillingLine.SetRange("Document Type", SalesBillingLine."Document Type"::"Sales Billing");
        SalesBillingLine.SetRange("Source Ledger Entry No.", Rec."Entry No.");
        if SalesBillingLine.FindFirst() then begin
            SalesBillingDocNo := SalesBillingLine."Document No.";
        end;
    end;

    var
        SalesBillingDocNo: Code[20];
}