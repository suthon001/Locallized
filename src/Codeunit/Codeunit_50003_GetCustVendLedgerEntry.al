/// <summary>
/// Codeunit Get Cust/Vend Ledger Entry (ID 50003).
/// </summary>
codeunit 50003 "Get Cust/Vend Ledger Entry"
{
    Permissions = TableData "Cust. Ledger Entry" = rm, TableData "Vendor Ledger Entry" = rm;
    TableNo = "Billing Receipt Header";
    trigger OnRun()
    begin
        BillingHeader.GET(rec."Document Type", REc."No.");
        BillingHeader.TESTFIELD("Bill/Pay-to Cust/Vend No.");

        CASE BillingHeader."Document Type" OF
            BillingHeader."Document Type"::"Sales Billing", BillingHeader."Document Type"::"Sales Receipt":
                BEGIN
                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open);
                    CustLedgEntry.SETRANGE("Customer No.", BillingHeader."Bill/Pay-to Cust/Vend No.");
                    CustLedgEntry.SetFilter("Document Type", '%1|%2', CustLedgEntry."Document Type"::Invoice, CustLedgEntry."Document Type"::"Credit Memo");
                    CustLedgEntry.SETRANGE(Open, TRUE);
                    IF BillingHeader."Document Type" = BillingHeader."Document Type"::"Sales Billing" THEN
                        CustLedgEntry.SETFILTER("Completed Billing", '%1', FALSE)
                    ELSE
                        CustLedgEntry.SETFILTER("Completed Receipt", '%1', FALSE);

                    GetCustLedger."SetDocument"(BillingHeader."Document Type", BillingHeader."No.");
                    GetCustLedger.LOOKUPMODE := TRUE;
                    GetCustLedger.SETTABLEVIEW(CustLedgEntry);
                    IF GetCustLedger.RUNMODAL() <> ACTION::Cancel THEN;
                END;
            BillingHeader."Document Type"::"Purchase Billing":
                BEGIN
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open);
                    VendLedgEntry.SETRANGE("Vendor No.", BillingHeader."Bill/Pay-to Cust/Vend No.");
                    VendLedgEntry.SetFilter("Document Type", '%1|%2', VendLedgEntry."Document Type"::Invoice, VendLedgEntry."Document Type"::"Credit Memo");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    VendLedgEntry.SETFILTER("Completed Billing", '%1', FALSE);
                    GetVendLedger."SetDocument"(BillingHeader."Document Type", BillingHeader."No.");
                    GetVendLedger.LOOKUPMODE := TRUE;
                    GetVendLedger.SETTABLEVIEW(VendLedgEntry);
                    IF GetVendLedger.RUNMODAL() <> ACTION::Cancel THEN;
                END;
        END;

    end;

    /// <summary> 
    /// Description for SetDocument.
    /// </summary>
    /// <param name="VAR BillingHeader2">Parameter of type Record "Billing  Receipt Header".</param>
    procedure "SetDocument"(VAR BillingHeader2: Record "Billing Receipt Header")
    begin
        BillingHeader.GET(BillingHeader2."Document Type", BillingHeader2."No.");
    end;

    /// <summary> 
    /// Description for CreateCustBillingLines.
    /// </summary>
    /// <param name="VAR CustLedgEntry2">Parameter of type Record "Cust. Ledger Entry".</param>
    procedure "CreateCustBillingLines"(VAR CustLedgEntry2: Record "Cust. Ledger Entry")
    var
        BillingLine: Record "Billing Receipt Line";
        CurrencyFactor: Decimal;
        currencyExchange: Record "Currency Exchange Rate";
    begin
        BillingHeader.TESTFIELD("Status", BillingHeader."Status"::Open);

        // WITH CustLedgEntry2 DO BEGIN
        IF CustLedgEntry2.FINDSET() THEN
            REPEAT
                CurrencyFactor := 0;
                if CustLedgEntry2."Currency Code" <> '' then
                    CurrencyFactor := (1 / currencyExchange.ExchangeRate(CustLedgEntry2."Posting Date", CustLedgEntry2."Currency Code"));

                CustLedgEntry2.CALCFIELDS("Original Amount", "Original Amt. (LCY)", "Billing Amount", "Billing Amount (LCY)",
                 "Receipt Amount", "Receipt Amount (LCY)");
                BillingLine.LOCKTABLE();
                BillingLine.SETRANGE("Document Type", BillingHeader."Document Type");
                BillingLine.SETRANGE("Document No.", BillingHeader."No.");
                BillingLine."Document Type" := BillingHeader."Document Type";
                BillingLine."Document No." := BillingHeader."No.";
                BillingLine."Posting Date" := BillingHeader."Posting Date";
                BillingLine."Document Date" := BillingHeader."Document Date";
                BillingLine."Due Date" := BillingHeader."Due Date";
                BillingLine."Bill/Pay-to Cust/Vend No." := BillingHeader."Bill/Pay-to Cust/Vend No.";
                BillingLine."Line No." := BillingLine."FindLastLineNo"();
                BillingLine.INSERT();
                CustLedgEntry2.TESTFIELD("Customer No.", BillingHeader."Bill/Pay-to Cust/Vend No.");
                BillingLine."Source Ledger Entry No." := CustLedgEntry2."Entry No.";
                BillingLine."Source Document Type" := CustLedgEntry2."Document Type";
                BillingLine."Source Document No." := CustLedgEntry2."Document No.";
                BillingLine."Source Posting Date" := CustLedgEntry2."Posting Date";
                BillingLine."Source Document Date" := CustLedgEntry2."Document Date";
                BillingLine."Source Ext. Document No." := CustLedgEntry2."External Document No.";
                BillingLine."Source Due Date" := CustLedgEntry2."Due Date";
                BillingLine."Source Currency Code" := CustLedgEntry2."Currency Code";
                BillingLine."Source Currency Factor" := CurrencyFactor;
                // BillingLine."Source Currency Factor" := CustLedgEntry2.cur;
                BillingLine."Source Amount" := CustLedgEntry2."Original Amount";
                BillingLine."Source Amount (LCY)" := CustLedgEntry2."Original Amt. (LCY)";
                BillingLine."Source Description" := CustLedgEntry2.Description;
                CASE BillingLine."Document Type" OF
                    BillingLine."Document Type"::"Sales Billing":
                        BEGIN
                            BillingLine."Amount" := CustLedgEntry2."Original Amount" - CustLedgEntry2."Billing Amount";
                            //  CurrencyFactor := BillingLine."Source Amount" / BillingLine."Source Amount (LCY)";
                            if CustLedgEntry2."Currency Code" <> '' then
                                BillingLine."Amount (LCY)" := BillingLine."Amount" * CurrencyFactor
                            else
                                BillingLine."Amount (LCY)" := BillingLine."Amount";
                            CustLedgEntry2."Completed Billing" := TRUE;
                            CustLedgEntry2.MODIFY();
                        END;
                    BillingLine."Document Type"::"Sales Receipt":
                        BEGIN
                            BillingLine."Amount" := CustLedgEntry2."Original Amount" - CustLedgEntry2."Receipt Amount";
                            // CurrencyFactor := BillingLine."Source Amount" / BillingLine."Source Amount (LCY)";
                            if CustLedgEntry2."Currency Code" <> '' then
                                BillingLine."Amount (LCY)" := BillingLine."Amount" * CurrencyFactor
                            else
                                BillingLine."Amount (LCY)" := BillingLine."Amount";

                            CustLedgEntry2."Completed Receipt" := TRUE;
                            CustLedgEntry2.MODIFY();
                        END;
                END;
                BillingLine.MODIFY();
            UNTIL CustLedgEntry2.NEXT() = 0;
        COMMIT();
        // END;
    end;

    /// <summary>
    /// CreateVendBillingLines.
    /// </summary>
    /// <param name="VAR VendLedgEntry2">Record "Vendor Ledger Entry".</param>
    procedure CreateVendBillingLines(VAR VendLedgEntry2: Record "Vendor Ledger Entry")
    var
        BillingLine: Record "Billing Receipt Line";
        CurrencyFactor: Decimal;
        currencyExchange: Record "Currency Exchange Rate";
    begin
        BillingHeader.TESTFIELD("Status", BillingHeader."Status"::Open);


        //  WITH VendLedgEntry2 DO BEGIN
        IF VendLedgEntry2.FINDSET() THEN
            REPEAT
                CurrencyFactor := 0;
                VendLedgEntry2.CALCFIELDS("Original Amount", "Original Amt. (LCY)", "Billing Amount", "Billing Amount (LCY)");
                if VendLedgEntry2."Currency Code" <> '' then
                    CurrencyFactor := (1 / currencyExchange.ExchangeRate(VendLedgEntry2."Posting Date", VendLedgEntry2."Currency Code"));
                BillingLine.LOCKTABLE();
                BillingLine.SETRANGE("Document Type", BillingHeader."Document Type");
                BillingLine.SETRANGE("Document No.", BillingHeader."No.");
                BillingLine."Document Type" := BillingHeader."Document Type";
                BillingLine."Document No." := BillingHeader."No.";
                BillingLine."Line No." := BillingLine."FindLastLineNo"();
                BillingLine.INSERT();
                VendLedgEntry2.TESTFIELD("Vendor No.", BillingHeader."Bill/Pay-to Cust/Vend No.");
                BillingLine."Source Ledger Entry No." := VendLedgEntry2."Entry No.";
                BillingLine."Source Document Type" := VendLedgEntry2."Document Type";
                BillingLine."Source Document No." := VendLedgEntry2."Document No.";
                BillingLine."Source Posting Date" := VendLedgEntry2."Posting Date";
                BillingLine."Source Document Date" := VendLedgEntry2."Document Date";
                BillingLine."Source Ext. Document No." := VendLedgEntry2."External Document No.";
                BillingLine."Source Due Date" := VendLedgEntry2."Due Date";
                BillingLine."Source Currency Code" := VendLedgEntry2."Currency Code";
                BillingLine."Source Amount" := -VendLedgEntry2."Original Amount";
                BillingLine."Source Amount (LCY)" := -VendLedgEntry2."Original Amt. (LCY)";
                BillingLine."Source Description" := VendLedgEntry2.Description;
                BillingLine."Amount" := -VendLedgEntry2."Original Amount" - VendLedgEntry2."Billing Amount";
                BillingLine."Source Currency Factor" := CurrencyFactor;
                if VendLedgEntry2."Currency Code" <> '' then
                    BillingLine."Amount (LCY)" := BillingLine."Amount" * CurrencyFactor
                else
                    BillingLine."Amount (LCY)" := BillingLine."Amount";
                VendLedgEntry2."Completed Billing" := TRUE;
                VendLedgEntry2.MODIFY();
                BillingLine.MODIFY();
            UNTIL VendLedgEntry2.NEXT() = 0;
        COMMIT();
        //  END;
    end;

    var
        BillingHeader: Record "Billing Receipt Header";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GetCustLedger: Page "Get Cus. Ledger Entry";
        GetVendLedger: Page "Get Vendor Ledger Entry";
}