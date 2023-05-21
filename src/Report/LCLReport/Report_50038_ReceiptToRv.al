report 50038 "Recript to CashReceipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50038_ReceiptToRv.rdl';
    Caption = 'Receipt to CashReceipt';
    ProcessingOnly = true;
    Permissions = TableData "Cust. Ledger Entry" = imd;
    dataset
    {
        dataitem("Billing - Receipt Header"; "Billing Receipt Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST("Sales Receipt"));
            RequestFilterFields = "Document Type", "No.";
            trigger OnAfterGetRecord()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                DiffAmt: Decimal;
            begin
                TemplateName := "Template Name";
                BatchName := "Batch Name";
                RVSeries := "RV No. Series";
                //DocumentNo := "Receive Voucher No.";
                DiffAmt := 0;
                BillingHeader.GET("Document Type", "No.");
                TestField("Template Name");
                TestField("Batch Name");
                TestField("RV No. Series");
                TESTFIELD("Receive Account No.");
                TESTFIELD("Receive Date");
                TESTFIELD("Receive Amount");
                CALCFIELDS("Amount (LCY)");
                DiffAmt := "Receive Amount" - "Bank Fee Amount (LCY)" - "Prepaid WHT Amount (LCY)" - "Amount (LCY)";
                IF DiffAmt <> 0 THEN
                    TESTFIELD("Diff Amount Acc.");
                IF "Prepaid WHT Amount (LCY)" <> 0 THEN
                    TESTFIELD("Prepaid WHT Acc.");
                IF "Bank Fee Amount (LCY)" <> 0 THEN
                    TESTFIELD("Bank Fee Acc.");
                //Insert Customer Line
                // IF "Receive Voucher No." = '' THEN
                DocumentNo := NosMgt.GetNextNo(RVSeries, "Receive Date", TRUE);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := GenTemplate.Name;
                GenJnlLine."Journal Batch Name" := GenBatch.Name;
                GenJnlLine."Line No." := GetLastLine;
                GenJnlLine."Source Code" := GenTemplate."Source Code";
                GenJnlLine.INSERT;

                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Document No.", DocumentNo);
                GenJnlLine.VALIDATE("Document No. Series", RVSeries);
                GenJnlLine.VALIDATE("Posting Date", "Receive Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE("Account No.", "Bill/Pay-to Cust/Vend No.");
                GenJnlLine.VALIDATE("External Document No.", "No.");
                GenJnlLine.VALIDATE("Amount (LCY)", -"Amount (LCY)");
                GenJnlLine."Applies-to ID" := DocumentNo;
                GenJnlLine."Sales Receipt No." := "No.";
                GenJnlLine.MODIFY;

                //Apply Document
                BillingLine.RESET;
                BillingLine.SETRANGE("Document Type", "Document Type");
                BillingLine.SETRANGE("Document No.", "No.");
                IF BillingLine.FIND('-') THEN
                    REPEAT
                        CustLedgEntry.GET(BillingLine."Source Ledger Entry No.");
                        SetCustApplId(CustLedgEntry, BillingLine."Amount (LCY)");
                    UNTIL BillingLine.NEXT = 0;
                //Insert WHT
                IF "Prepaid WHT Amount (LCY)" <> 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := GenTemplate.Name;
                    GenJnlLine."Journal Batch Name" := GenBatch.Name;
                    GenJnlLine."Line No." := GetLastLine;
                    GenJnlLine."Source Code" := GenTemplate."Source Code";
                    GenJnlLine.INSERT;


                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("Document No. Series", RVSeries);
                    GenJnlLine.VALIDATE("Posting Date", BillingHeader."Receive Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", "Prepaid WHT Acc.");
                    GenJnlLine.VALIDATE("Document Date", "Prepaid WHT Date");
                    GenJnlLine.VALIDATE("External Document No.", "Prepaid WHT No.");
                    GenJnlLine.VALIDATE("Amount (LCY)", "Prepaid WHT Amount (LCY)");
                    GenJnlLine.MODIFY;
                END;
                //Insert Bank Fee
                IF "Bank Fee Amount (LCY)" <> 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := GenTemplate.Name;
                    GenJnlLine."Journal Batch Name" := GenBatch.Name;
                    GenJnlLine."Line No." := GetLastLine;
                    GenJnlLine."Source Code" := GenTemplate."Source Code";
                    GenJnlLine.INSERT;


                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("Document No. Series", RVSeries);
                    GenJnlLine.VALIDATE("Posting Date", "Receive Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", "Bank Fee Acc.");
                    GenJnlLine.VALIDATE("Amount (LCY)", "Bank Fee Amount (LCY)");
                    GenJnlLine.MODIFY;
                END;
                //Insert Diff Amount
                IF "Diff Amount (LCY)" <> 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := GenTemplate.Name;
                    GenJnlLine."Journal Batch Name" := GenBatch.Name;
                    GenJnlLine."Line No." := GetLastLine;
                    GenJnlLine."Source Code" := GenTemplate."Source Code";
                    GenJnlLine.INSERT;


                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("Document No. Series", RVSeries);
                    GenJnlLine.VALIDATE("Posting Date", "Receive Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", "Diff Amount Acc.");
                    GenJnlLine.VALIDATE("Amount (LCY)", "Diff Amount (LCY)");
                    GenJnlLine.MODIFY;
                END;
                //Insert Receive Line
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := GenTemplate.Name;
                GenJnlLine."Journal Batch Name" := GenBatch.Name;
                GenJnlLine."Line No." := GetLastLine;
                GenJnlLine."Source Code" := GenTemplate."Source Code";
                GenJnlLine.INSERT;


                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Document No.", DocumentNo);
                GenJnlLine.VALIDATE("Document No. Series", RVSeries);
                GenJnlLine.VALIDATE("Posting Date", BillingHeader."Receive Date");
                IF BillingHeader."Receive Type" = BillingHeader."Receive Type"::"G/L Account" THEN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account")
                ELSE
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Account No.", BillingHeader."Receive Account No.");
                IF BillingHeader."Cheque Date" <> 0D THEN
                    GenJnlLine.VALIDATE("Document Date", BillingHeader."Cheque Date");
                IF BillingHeader."Cheque No." <> '' THEN
                    GenJnlLine.VALIDATE("External Document No.", BillingHeader."Cheque No.");
                GenJnlLine.Description := COPYSTR(STRSUBSTNO('Receive From %1', BillingHeader."Bill/Pay-to Cus/Vend Name2"), 1, 100);
                GenJnlLine.VALIDATE("Amount (LCY)", BillingHeader."Receive Amount");
                GenJnlLine.MODIFY;

                BillingHeader."Receive Status" := BillingHeader."Receive Status"::"In used";
                BillingHeader."Journal Document No." := DocumentNo;
                BillingHeader."Status" := BillingHeader."Status"::"Create RV";
                BillingHeader.MODIFY;
            end;
        }
    }
    local procedure SetCustApplId(CustLedgEntry: Record "Cust. Ledger Entry"; AmountApply: Decimal)
    begin
        CustLedgEntry.VALIDATE("Amount to Apply", AmountApply);
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", CustLedgEntry);

        IF (BillingHeader."Receive Date" < CustLedgEntry."Posting Date") THEN
            ERROR(
                EarlierPostingDateErr, BillingHeader."Document Type", BillingHeader."No.",
                CustLedgEntry."Document Type", CustLedgEntry."Document No.");
        CustLedgEntry."Applies-to ID" := DocumentNo;
        CustLedgEntry.MODIFY;
    end;

    local procedure GetLastLine() ReturnLine: Integer
    var
        GenLine: Record "Gen. Journal Line";
    begin
        GenLine.reset;
        GenLine.SetFilter("Journal Template Name", GenTemplate.Name);
        GenLine.SetFilter("Journal Batch Name", GenBatch.Name);
        if GenLine.FindLast() then
            exit(GenLine."Line No." + 10000);
        exit(10000);
    end;

    trigger OnPreReport()
    begin
        GenTemplate.GET(TemplateName);
        GenBatch.GET(TemplateName, BatchName);
    end;

    var
        EarlierPostingDateErr: Label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
        BillingHeader: Record "Billing Receipt Header";
        DocumentNo: Code[20];
        TemplateName: Code[20];
        BatchName: Code[20];
        GenTemplate: Record "Gen. Journal Template";
        GenBatch: Record "Gen. Journal Batch";
        RVSeries: Code[20];
        NosMgt: Codeunit NoSeriesManagement;
        GenJnlLine: Record "Gen. Journal Line";
        BillingLine: Record "Billing Receipt Line";
        LastLineNo: Integer;
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";

}