/// <summary>
/// Codeunit NCT Get Cust/Vend Ledger Entry (ID 80003).
/// </summary>
codeunit 80003 "NCT Get Cust/Vend Ledger Entry"
{
    Permissions = TableData "Cust. Ledger Entry" = rm, TableData "Vendor Ledger Entry" = rm;
    TableNo = "NCT Billing Receipt Header";
    trigger OnRun()
    begin
        BillingHeader.GET(rec."Document Type", rec."No.");
        BillingHeader.TESTFIELD("Bill/Pay-to Cust/Vend No.");
        BillingHeader.TestField(Status, BillingHeader.Status::Open);
        CASE BillingHeader."Document Type" OF
            BillingHeader."Document Type"::"Sales Billing", BillingHeader."Document Type"::"Sales Receipt":
                BEGIN
                    CLEAR(GetCustLedger);
                    GetCustLedger.SetTableData(BillingHeader."Bill/Pay-to Cust/Vend No.", BillingHeader."Document Type", BillingHeader."No.");
                    GetCustLedger.LOOKUPMODE := TRUE;
                    GetCustLedger.RUNMODAL();
                    CLEAR(GetCustLedger);
                END;
            BillingHeader."Document Type"::"Purchase Billing":
                BEGIN
                    CLEAR(GetVendLedger);
                    GetVendLedger.SetTableData(BillingHeader."Bill/Pay-to Cust/Vend No.", BillingHeader."Document Type", BillingHeader."No.");
                    GetVendLedger.LOOKUPMODE := TRUE;
                    GetVendLedger.RUNMODAL();
                    CLEAR(GetVendLedger);
                END;
        END;

    end;

    /// <summary> 
    /// Description for SetDocument.
    /// </summary>
    /// <param name="VAR BillingHeader2">Parameter of type Record "Billing  Receipt Header".</param>
    procedure "SetDocument"(VAR BillingHeader2: Record "NCT Billing Receipt Header")
    begin
        BillingHeader.GET(BillingHeader2."Document Type", BillingHeader2."No.");
    end;

    var
        BillingHeader: Record "NCT Billing Receipt Header";

        GetCustLedger: Page "NCT Get Cus. Ledger Entry";
        GetVendLedger: Page "NCT Get Vendor Ledger Entry";
}