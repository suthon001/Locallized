/// <summary>
/// Report Recript to CashReceipt (ID 80038).
/// </summary>
report 80038 "NCT Recript to CashReceipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80038_ReceiptToRv.rdl';
    Caption = 'Receipt to CashReceipt';
    ProcessingOnly = true;
    Permissions = TableData "Cust. Ledger Entry" = imd;
    UsageCategory = None;
    dataset
    {
        dataitem("Billing - Receipt Header"; "NCT Billing Receipt Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST("Sales Receipt"));
            RequestFilterFields = "Document Type", "No.";
            trigger OnAfterGetRecord()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                DiffAmt: Decimal;
            begin

                DiffAmt := 0;
                BillingHeader.GET("Document Type", "No.");
                TestField("Journal Template Name");
                TestField("Journal Batch Name");
                TestField("Journal No. Series");
                TESTFIELD("Account No.");
                TESTFIELD("Journal Date");
                TESTFIELD("Receive & Payment Amount");
                GenTemplate.GET("Journal Template Name");
                GenBatch.GET("Journal Template Name", "Journal Batch Name");
                CALCFIELDS("Amount");
                DiffAmt := "Receive & Payment Amount" - "Bank Fee Amount (LCY)" - "Prepaid WHT Amount (LCY)" - "Amount";
                IF DiffAmt <> 0 THEN
                    TESTFIELD("Diff Amount Acc.");
                IF "Prepaid WHT Amount (LCY)" <> 0 THEN
                    TESTFIELD("Prepaid WHT Acc.");
                IF "Bank Fee Amount (LCY)" <> 0 THEN
                    TESTFIELD("Bank Fee Acc.");

                if "Journal Document No." = '' then
                    DocumentNo := NosMgt.GetNextNo("Journal No. Series", "Journal Date", TRUE)
                else
                    DocumentNo := "Journal Document No.";
                GenJnlLine.INIT();
                GenJnlLine."Journal Template Name" := GenTemplate.Name;
                GenJnlLine."Journal Batch Name" := GenBatch.Name;
                GenJnlLine."Line No." := GetLastLine();
                GenJnlLine."Source Code" := GenTemplate."Source Code";
                GenJnlLine.INSERT();

                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Document No.", DocumentNo);
                GenJnlLine.VALIDATE("NCT Document No. Series", "Journal No. Series");
                GenJnlLine.VALIDATE("Posting Date", "Journal Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE("Account No.", "Bill/Pay-to Cust/Vend No.");
                GenJnlLine.VALIDATE("External Document No.", "No.");
                GenJnlLine.VALIDATE("Amount", -"Amount");
                GenJnlLine."Applies-to ID" := DocumentNo;
                GenJnlLine."NCT Ref. Billing & Receipt No." := "No.";
                GenJnlLine."NCT Create By" := COPYSTR(UserId(), 1, 50);
                GenJnlLine."NCT Create DateTime" := CurrentDateTime();
                GenJnlLine.MODIFY();

                //Apply Document
                BillingLine.RESET();
                BillingLine.SETRANGE("Document Type", "Document Type");
                BillingLine.SETRANGE("Document No.", "No.");
                IF BillingLine.FIND('-') THEN
                    REPEAT
                        CustLedgEntry.GET(BillingLine."Source Ledger Entry No.");
                        SetCustApplId(CustLedgEntry, BillingLine."Amount");
                    UNTIL BillingLine.NEXT() = 0;
                //Insert WHT
                IF "Prepaid WHT Amount (LCY)" <> 0 THEN BEGIN
                    GenJnlLine.INIT();
                    GenJnlLine."Journal Template Name" := GenTemplate.Name;
                    GenJnlLine."Journal Batch Name" := GenBatch.Name;
                    GenJnlLine."Line No." := GetLastLine();
                    GenJnlLine."Source Code" := GenTemplate."Source Code";
                    GenJnlLine.INSERT();


                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("NCT Document No. Series", "Journal No. Series");
                    GenJnlLine.VALIDATE("Posting Date", BillingHeader."Journal Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", "Prepaid WHT Acc.");
                    GenJnlLine.VALIDATE("Document Date", "Prepaid WHT Date");
                    GenJnlLine.VALIDATE("External Document No.", "Prepaid WHT No.");
                    GenJnlLine.VALIDATE("Amount", "Prepaid WHT Amount (LCY)");
                    GenJnlLine."NCT Ref. Billing & Receipt No." := "No.";
                    GenJnlLine."NCT Create By" := COPYSTR(UserId(), 1, 50);
                    GenJnlLine."NCT Create DateTime" := CurrentDateTime();
                    GenJnlLine.MODIFY();
                END;
                //Insert Bank Fee
                IF "Bank Fee Amount (LCY)" <> 0 THEN BEGIN
                    GenJnlLine.INIT();
                    GenJnlLine."Journal Template Name" := GenTemplate.Name;
                    GenJnlLine."Journal Batch Name" := GenBatch.Name;
                    GenJnlLine."Line No." := GetLastLine();
                    GenJnlLine."Source Code" := GenTemplate."Source Code";
                    GenJnlLine.INSERT();


                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("NCT Document No. Series", "Journal No. Series");
                    GenJnlLine.VALIDATE("Posting Date", "Journal Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", "Bank Fee Acc.");
                    GenJnlLine.VALIDATE("Amount", "Bank Fee Amount (LCY)");
                    GenJnlLine."NCT Ref. Billing & Receipt No." := "No.";
                    GenJnlLine."NCT Create By" := COPYSTR(UserId(), 1, 50);
                    GenJnlLine."NCT Create DateTime" := CurrentDateTime();
                    GenJnlLine.MODIFY();
                END;
                //Insert Diff Amount
                IF "Diff Amount (LCY)" <> 0 THEN BEGIN
                    GenJnlLine.INIT();
                    GenJnlLine."Journal Template Name" := GenTemplate.Name;
                    GenJnlLine."Journal Batch Name" := GenBatch.Name;
                    GenJnlLine."Line No." := GetLastLine();
                    GenJnlLine."Source Code" := GenTemplate."Source Code";
                    GenJnlLine.INSERT();


                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("NCT Document No. Series", "Journal No. Series");
                    GenJnlLine.VALIDATE("Posting Date", "Journal Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", "Diff Amount Acc.");
                    GenJnlLine.VALIDATE("Amount", "Diff Amount (LCY)");
                    GenJnlLine."NCT Ref. Billing & Receipt No." := "No.";
                    GenJnlLine."NCT Create By" := COPYSTR(UserId(), 1, 50);
                    GenJnlLine."NCT Create DateTime" := CurrentDateTime();
                    GenJnlLine.MODIFY();
                END;
                //Insert Receive Line
                GenJnlLine.INIT();
                GenJnlLine."Journal Template Name" := GenTemplate.Name;
                GenJnlLine."Journal Batch Name" := GenBatch.Name;
                GenJnlLine."Line No." := GetLastLine();
                GenJnlLine."Source Code" := GenTemplate."Source Code";
                GenJnlLine.INSERT();


                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Document No.", DocumentNo);
                GenJnlLine.VALIDATE("NCT Document No. Series", "Journal No. Series");
                GenJnlLine.VALIDATE("Posting Date", BillingHeader."Journal Date");
                IF BillingHeader."Account Type" = BillingHeader."Account Type"::"G/L Account" THEN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account")
                ELSE
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Account No.", BillingHeader."Account No.");
                IF BillingHeader."Cheque Date" <> 0D THEN
                    GenJnlLine.VALIDATE("Document Date", BillingHeader."Cheque Date");
                IF BillingHeader."Cheque No." <> '' THEN
                    GenJnlLine.VALIDATE("External Document No.", BillingHeader."Cheque No.");
                GenJnlLine.Description := COPYSTR('Receive From ' + BillingHeader."Bill/Pay-to Cust/Vend Name", 1, 100);
                GenJnlLine.VALIDATE("Amount", BillingHeader."Receive & Payment Amount");
                GenJnlLine."NCT Ref. Billing & Receipt No." := "No.";
                GenJnlLine."NCT Create By" := COPYSTR(UserId(), 1, 50);
                GenJnlLine."NCT Create DateTime" := CurrentDateTime();
                GenJnlLine.MODIFY();
                BillingHeader."Journal Document No." := DocumentNo;
                BillingHeader."Status" := BillingHeader."Status"::"Created to Journal";
                BillingHeader."Create to Journal" := true;
                BillingHeader.MODIFY();
            end;
        }
    }
    local procedure SetCustApplId(CustLedgEntry: Record "Cust. Ledger Entry"; AmountApply: Decimal)
    begin
        CustLedgEntry.VALIDATE("Amount to Apply", AmountApply);
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", CustLedgEntry);
        IF (BillingHeader."Journal Date" < CustLedgEntry."Posting Date") THEN
            ERROR(
                EarlierPostingDateErr, BillingHeader."Document Type", BillingHeader."No.",
                CustLedgEntry."Document Type", CustLedgEntry."Document No.");
        CustLedgEntry."Applies-to ID" := DocumentNo;
        CustLedgEntry.MODIFY();
    end;

    local procedure GetLastLine(): Integer
    var
        GenLine: Record "Gen. Journal Line";
    begin
        GenLine.reset();
        GenLine.SetFilter("Journal Template Name", GenTemplate.Name);
        GenLine.SetFilter("Journal Batch Name", GenBatch.Name);
        if GenLine.FindLast() then
            exit(GenLine."Line No." + 10000);
        exit(10000);
    end;



    var
        EarlierPostingDateErr: Label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.', Locked = true;
        BillingHeader: Record "NCT Billing Receipt Header";
        DocumentNo: Code[20];

        GenTemplate: Record "Gen. Journal Template";
        GenBatch: Record "Gen. Journal Batch";
        NosMgt: Codeunit NoSeriesManagement;
        GenJnlLine: Record "Gen. Journal Line";
        BillingLine: Record "NCT Billing Receipt Line";

}