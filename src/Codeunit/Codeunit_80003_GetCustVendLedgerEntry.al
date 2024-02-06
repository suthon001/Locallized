/// <summary>
/// Codeunit NCT Get Cust/Vend Ledger Entry (ID 80003).
/// </summary>
codeunit 80003 "NCT Get Cust/Vend Ledger Entry"
{
    Permissions = TableData "Cust. Ledger Entry" = rm, TableData "Vendor Ledger Entry" = rm;
    TableNo = "NCT Billing Receipt Header";
    trigger OnRun()
    var
        IsHandle: Boolean;
    begin
        IsHandle := false;
        BillingHeader.GET(rec."Document Type", rec."No.");
        NCTOnBeforRunPage(BillingHeader, IsHandle);
        if not IsHandle then begin
            BillingHeader.TESTFIELD("Bill/Pay-to Cust/Vend No.");
            BillingHeader.TestField(Status, BillingHeader.Status::Open);
            CASE BillingHeader."Document Type" OF
                BillingHeader."Document Type"::"Sales Billing", BillingHeader."Document Type"::"Sales Receipt":
                    BEGIN
                        CLEAR(GetCustLedger);
                        GetCustLedger.SetTableData(BillingHeader."Bill/Pay-to Cust/Vend No.", BillingHeader."Document Type", BillingHeader."No.");
                        GetCustLedger.SetDocument(BillingHeader);
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
        AfterOnRun(BillingHeader);
    end;

    /// <summary> 
    /// Description for SetDocument.
    /// </summary>
    /// <param name="VAR BillingHeader2">Parameter of type Record "Billing  Receipt Header".</param>
    procedure "SetDocument"(VAR BillingHeader2: Record "NCT Billing Receipt Header")
    begin
        BillingHeader.GET(BillingHeader2."Document Type", BillingHeader2."No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterOnRun(BillingHeader: Record "NCT Billing Receipt Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NCTOnBeforRunPage(VAR BillingHeader2: Record "NCT Billing Receipt Header"; var pIsHandle: Boolean)
    begin
    end;

    var
        BillingHeader: Record "NCT Billing Receipt Header";

        GetCustLedger: Page "NCT Get Cus. Ledger Entry";
        GetVendLedger: Page "NCT Get Vendor Ledger Entry";
}