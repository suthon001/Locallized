/// <summary>
/// Codeunit NCT Journal Function (ID 80000).
/// </summary>
codeunit 80000 "NCT Journal Function"
{



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnProcessLinesOnAfterPostGenJnlLines', '', true, true)]
    /// <summary> 
    /// Description for InsertPostedGenLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "OnProcessLinesOnAfterPostGenJnlLines"(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean)
    var
        WHTHeader: Record "NCT WHT Header";
        WHTLines: Record "NCT WHT Line";
        BillingHeader: Record "NCT Billing Receipt Header";
        GenJnlLine2, GenJnlLine3 : Record "Gen. Journal Line";
        WHTAppEntry: Record "NCT WHT Applied Entry";
        GenJournalTemplate: Record "Gen. Journal Template";
        LastLineNo: Integer;
    begin
        if not PreviewMode then begin
            if not GenJournalTemplate.GET(GenJournalLine."Journal Template Name") then
                GenJournalLine.Init();
            GenJnlLine2.reset();
            GenJnlLine2.Copy(GenJournalLine);
            GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine2.SetFilter("Account No.", '<>%1', '');
            GenJnlLine2.SetFilter("NCT WHT Document No.", '<>%1', '');
            if GenJnlLine2.FindSet() then
                repeat
                    WHTHeader.reset();
                    WHTHeader.setrange("WHT No.", GenJnlLine2."NCT WHT Document No.");
                    if WHTHeader.FindFirst() then begin
                        WHTHeader."Posted" := true;
                        WHTHeader.Modify();
                        LastLineNo := 0;
                        WHTLines.reset();
                        WHTLines.SetRange("WHT No.", WHTHeader."WHT No.");
                        WHTLines.SetFilter("WHT Product Posting Group", '<>%1', '');
                        "NCT OnFilterWHTLineAPPLY"(WHTHeader, WHTLines, GenJnlLine2);
                        if WHTLines.FindSet() then
                            repeat
                                LastLineNo := LastLineNo + 10000;
                                WHTAppEntry.init();
                                WHTAppEntry."Document No." := GenJnlLine2."Document No.";
                                WHTAppEntry."Document Line No." := WHTLines."WHT Line No.";
                                WHTAppEntry."Entry Type" := WHTAppEntry."Entry Type"::Applied;
                                WHTAppEntry."Line No." := LastLineNo;
                                WHTAppEntry."WHT Bus. Posting Group" := WHTLines."WHT Business Posting Group";
                                WHTAppEntry."WHT Prod. Posting Group" := WHTLines."WHT Product Posting Group";
                                WHTAppEntry.Description := copystr(WHTLines.Description, 1, 100);
                                WHTAppEntry."WHT %" := WHTLines."WHT %";
                                WHTAppEntry."WHT Base" := WHTLines."WHT Base";
                                WHTAppEntry."WHT Amount" := WHTLines."WHT Amount";
                                WHTAppEntry."WHT Title Name" := WHTHeader."WHT Title Name";
                                WHTAppEntry."WHT Name" := WHTHeader."WHT Name";
                                WHTAppEntry."WHT Name 2" := WHTHeader."WHT Name 2";
                                WHTAppEntry."WHT Address" := WHTHeader."WHT Address";
                                WHTAppEntry."WHT Address 2" := WHTHeader."WHT Address 2";
                                WHTAppEntry."WHT Address 3" := WHTHeader."WHT Address 3";
                                WHTAppEntry."WHT City" := WHTHeader."WHT City";
                                WHTAppEntry."VAT Registration No." := WHTHeader."VAT Registration No.";
                                WHTAppEntry."WHT Option" := WHTHeader."WHT Option";
                                WHTAppEntry."VAT Branch Code" := WHTHeader."VAT Branch Code";
                                WHTAppEntry."Head Office" := WHTHeader."Head Office";
                                WHTAppEntry."WHT Post Code" := WHTHeader."Wht Post Code";
                                if GenJournalTemplate.Type = GenJournalTemplate.Type::Payments then
                                    WHTAppEntry."WHT Document Type" := WHTAppEntry."WHT Document Type"::Payment;
                                if GenJournalTemplate.Type = GenJournalTemplate.Type::"Cash Receipts" then
                                    WHTAppEntry."WHT Document Type" := WHTAppEntry."WHT Document Type"::"Cash Receipt";
                                "NCT OnBeforInsertWHTAPPLY"(WHTAppEntry, WHTHeader, WHTLines, GenJnlLine2);
                                WHTAppEntry.Insert();
                            until WHTLines.Next() = 0;
                    end;
                until GenJnlLine2.Next() = 0;
            GenJnlLine3.reset();
            GenJnlLine3.Copy(GenJournalLine);
            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine3.SetFilter("Account No.", '<>%1', '');
            GenJnlLine3.SetFilter("NCT Ref. Billing & Receipt No.", '<>%1', '');
            if GenJnlLine3.FindSet() then
                repeat
                    BillingHeader.reset();
                    BillingHeader.SetRange("No.", GenJnlLine3."NCT Ref. Billing & Receipt No.");
                    if BillingHeader.FindFirst() then begin
                        BillingHeader."Status" := BillingHeader."Status"::Posted;
                        BillingHeader."Journal Document No." := GenJnlLine3."Document No.";
                        BillingHeader.Modify();
                    end;
                until GenJnlLine3.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeaderPrepmt', '', true, true)]
    local procedure "NCT CopyHeaderFromPropmtInvoiceBuff"(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin

        GenJournalLine."NCT Head Office" := SalesHeader."NCT Head Office";
        GenJournalLine."NCT VAT Branch Code" := SalesHeader."NCT VAT Branch Code";
        GenJournalLine."NCT Tax Invoice No." := SalesHeader."No.";
        GenJournalLine."VAT Registration No." := SalesHeader."VAT Registration No.";
        GenJournalLine."Document Date" := SalesHeader."Document Date";
        GenJournalLine."NCT Tax Invoice Date" := SalesHeader."Posting Date";
        GenJournalLine."NCT Tax Invoice Name" := SalesHeader."Sell-to Customer Name";
        GenJournalLine."NCT Tax Invoice Name 2" := SalesHeader."Sell-to Customer Name 2";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPrepmtInvBuffer', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPrepmtInvBuffer(PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if PrepmtInvLineBuffer."NCT Tax Invoice No." <> '' then
            GenJournalLine."NCT Tax Invoice No." := PrepmtInvLineBuffer."NCT Tax Invoice No.";
        GenJournalLine."VAT Registration No." := PrepmtInvLineBuffer."NCT Vat Registration No.";
        GenJournalLine."NCT Tax Invoice Name" := PrepmtInvLineBuffer."NCT Tax Invoice Name";
        GenJournalLine."NCT Tax Invoice Name 2" := PrepmtInvLineBuffer."NCT Tax Invoice Name 2";
        GenJournalLine."NCT VAT Branch Code" := PrepmtInvLineBuffer."NCT VAT Branch Code";
        GenJournalLine."NCT Head Office" := PrepmtInvLineBuffer."NCT Head Office";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prepayment Inv. Line Buffer", 'OnAfterCopyFromSalesLine', '', false, false)]
    local procedure OnAfterCopyFromSalesLine(SalesLine: Record "Sales Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        PrepaymentInvLineBuffer."NCT Tax Invoice No." := SalesHeader."Prepayment No.";
        PrepaymentInvLineBuffer."NCT Tax Invoice Name" := SalesHeader."Sell-to Customer Name";
        PrepaymentInvLineBuffer."NCT Tax Invoice Name 2" := SalesHeader."Sell-to Customer Name 2";
        PrepaymentInvLineBuffer."NCT Vat Registration No." := SalesHeader."VAT Registration No.";
        PrepaymentInvLineBuffer."NCT VAT Branch Code" := SalesHeader."NCT VAT Branch Code";
        PrepaymentInvLineBuffer."NCT Head Office" := SalesHeader."NCT Head Office";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertPostUnrealVATEntry', '', true, true)]
    /// <summary> 
    /// Description for PostUnrealVatEntry.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VATEntry">Parameter of type Record "VAT Entry".</param>
    local procedure "PostUnrealVatEntry"(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        VATEntry."NCT Tax Invoice Base" := VATEntry.Base;
        VATEntry."NCT Tax Invoice Amount" := VATEntry.Amount;
        VATEntry."NCT Tax Invoice No." := GenJournalLine."NCT Tax Invoice No.";
        VATEntry."NCT Tax Invoice Date" := GenJournalLine."NCT Tax Invoice Date";
        VATEntry."NCT Tax Vendor No." := GenJournalLine."NCT Tax Vendor No.";
        VATEntry."NCT Tax Invoice Name" := GenJournalLine."NCT Tax Invoice Name";
        VATEntry."NCT Tax Invoice Name 2" := GenJournalLine."NCT Tax Invoice Name 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromInvoiceBuff.
    /// </summary>
    local procedure "CopyHeaderFromInvoiceBuff"(InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line")
    begin

        GenJnlLine."NCT Tax Invoice No." := InvoicePostingBuffer."NCT Tax Invoice No.";
        GenJnlLine."NCT Tax Invoice Date" := InvoicePostingBuffer."NCT Tax Invoice Date";
        GenJnlLine."NCT Tax Invoice Base" := InvoicePostingBuffer."NCT Tax Invoice Base";
        GenJnlLine."NCT Tax Invoice Amount" := InvoicePostingBuffer."NCT Tax Invoice Amount";
        GenJnlLine."NCT Tax Vendor No." := InvoicePostingBuffer."NCT Tax Vendor No.";
        GenJnlLine."NCT Tax Invoice Name" := InvoicePostingBuffer."NCT Tax Invoice Name";
        GenJnlLine."NCT Tax Invoice Name 2" := InvoicePostingBuffer."NCT Tax Invoice Name 2";
        GenJnlLine."NCT Tax Invoice Address" := InvoicePostingBuffer."NCT Address";
        GenJnlLine."NCT Tax Invoice Address 2" := InvoicePostingBuffer."NCT Address 2";
        GenJnlLine."NCT Head Office" := InvoicePostingBuffer."NCT Head Office";
        GenJnlLine."NCT VAT Branch Code" := InvoicePostingBuffer."NCT VAT Branch Code";
        GenJnlLine."VAT Registration No." := InvoicePostingBuffer."NCT VAT Registration No.";
        GenJnlLine."NCT Journal Description" := InvoicePostingBuffer."NCT Description Line";
        GenJnlLine."NCT Tax Invoice Address" := InvoicePostingBuffer."NCT Address";
        GenJnlLine."NCT Tax Invoice City" := InvoicePostingBuffer."NCT City";
        GenJnlLine."NCT Tax Invoice Post Code" := InvoicePostingBuffer."NCT Post Code";
        GenJnlLine."NCT Document Line No." := InvoicePostingBuffer."NCT Document Line No.";
        "NCT AfterCopyInvoicePostingBufferToGL"(GenJnlLine, InvoicePostingBuffer);


    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromInvoiceBuff.
    /// </summary>
    local procedure OnAfterCopyToGenJnlLine(InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line")
    begin
        // with GenJournalLine do begin
        GenJnlLine."NCT Tax Invoice No." := InvoicePostBuffer."NCT Tax Invoice No.";
        GenJnlLine."NCT Tax Invoice Date" := InvoicePostBuffer."NCT Tax Invoice Date";
        GenJnlLine."NCT Tax Invoice Base" := InvoicePostBuffer."NCT Tax Invoice Base";
        GenJnlLine."NCT Tax Invoice Amount" := InvoicePostBuffer."NCT Tax Invoice Amount";
        GenJnlLine."NCT Tax Vendor No." := InvoicePostBuffer."NCT Tax Vendor No.";
        GenJnlLine."NCT Tax Invoice Name" := InvoicePostBuffer."NCT Tax Invoice Name";
        GenJnlLine."NCT Tax Invoice Name 2" := InvoicePostBuffer."NCT Tax Invoice Name 2";
        GenJnlLine."NCT Tax Invoice Address" := InvoicePostBuffer."NCT Address";
        GenJnlLine."NCT Tax Invoice Address 2" := InvoicePostBuffer."NCT Address 2";
        GenJnlLine."NCT Head Office" := InvoicePostBuffer."NCT Head Office";
        GenJnlLine."NCT VAT Branch Code" := InvoicePostBuffer."NCT VAT Branch Code";
        GenJnlLine."VAT Registration No." := InvoicePostBuffer."NCT VAT Registration No.";
        GenJnlLine."NCT Journal Description" := InvoicePostBuffer."NCT Description Line";
        GenJnlLine."NCT Tax Invoice Address" := InvoicePostBuffer."NCT Address";
        GenJnlLine."NCT Tax Invoice City" := InvoicePostBuffer."NCT City";
        GenJnlLine."NCT Tax Invoice Post Code" := InvoicePostBuffer."NCT Post Code";
        GenJnlLine."NCT Document Line No." := InvoicePostBuffer."NCT Document Line No.";
        "NCT AfterCopyInvoicePostBufferToGL"(GenJnlLine, InvoicePostBuffer);
        // end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterCopyFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for CopyVatFromGenLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VATEntry">Parameter of type Record "VAT Entry".</param>
    local procedure "CopyVatFromGenLine"(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    var
        VATProPostingGroup: Record "VAT Product Posting Group";
    begin

        VATEntry."NCT Head Office" := GenJournalLine."NCT Head Office";
        VATEntry."NCT VAT Branch Code" := GenJournalLine."NCT VAT Branch Code";
        VATEntry."NCT Tax Invoice No." := GenJournalLine."NCT Tax Invoice No.";
        VATEntry."NCT Tax Invoice Name" := GenJournalLine."NCT Tax Invoice Name";
        VATEntry."NCT Tax Invoice Name 2" := GenJournalLine."NCT Tax Invoice Name 2";
        VATEntry."NCT Tax Vendor No." := GenJournalLine."NCT Tax Vendor No.";
        VATEntry."NCT Tax Invoice Base" := GenJournalLine."NCT Tax Invoice Base";
        VATEntry."NCT Tax Invoice Date" := GenJournalLine."NCT Tax Invoice Date";
        VATEntry."NCT Tax Invoice Amount" := GenJournalLine."NCT Tax Invoice Amount";
        VATEntry."VAT Registration No." := GenJournalLine."VAT Registration No.";
        VATEntry."NCT Tax Invoice Address" := GenJournalLine."NCT Tax Invoice Address";
        VATEntry."NCT Tax Invoice Address 2" := GenJournalLine."NCT Tax Invoice Address 2";
        VATEntry."NCT Tax Invoice City" := GenJournalLine."NCT Tax Invoice City";
        VATEntry."NCT Tax Invoice Post Code" := GenJournalLine."NCT Tax Invoice Post Code";
        VATEntry."External Document No." := GenJournalLine."External Document No.";
        if GenJournalLine."NCT Document Line No." <> 0 then
            VATEntry."NCT Document Line No." := GenJournalLine."NCT Document Line No."
        else
            VATEntry."NCT Document Line No." := GenJournalLine."Line No.";

        if NOT VATProPostingGroup.get(VATEntry."VAT Prod. Posting Group") then
            VATProPostingGroup.init();
        IF VATProPostingGroup."NCT Direct VAT" then begin
            VATEntry.Base := VATEntry."NCT Tax Invoice Base";
            VATEntry.Amount := VATEntry."NCT Tax Invoice Amount";
        end ELSE BEGIN
            VATEntry."NCT Tax Invoice Base" := VATEntry.Base;
            VATEntry."NCT Tax Invoice Amount" := VATEntry.Amount;
        END;
        "NCT AfterCopyGenLineToVatEntry"(VATEntry, GenJournalLine);
    end;




    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromPurchaseHeader.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "CopyHeaderFromPurchaseHeader"(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        VendCust: Record "NCT Customer & Vendor Branch";
    begin

        GenJournalLine."NCT Journal Description" := PurchaseHeader."Posting Description";
        GenJournalLine."NCT Head Office" := PurchaseHeader."NCT Head Office";
        GenJournalLine."NCT VAT Branch Code" := PurchaseHeader."NCT VAT Branch Code";
        if VendCust.Get(VendCust."Source Type"::Vendor, PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."NCT Head Office", PurchaseHeader."NCT VAT Branch Code") then
            if VendCust."Title Name" <> VendCust."Title Name"::" " then
                GenJournalLine."NCT Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
            else
                GenJournalLine."NCT Tax Invoice Name" := VendCust."Name";

        if GenJournalLine."NCT Tax Invoice Name" = '' then
            GenJournalLine."NCT Tax Invoice Name" := PurchaseHeader."Pay-to Name";
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" then
            if PurchaseHeader."Vendor Cr. Memo No." <> '' then
                GenJournalLine."NCT Tax Invoice No." := PurchaseHeader."Vendor Cr. Memo No.";
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            if PurchaseHeader."Vendor Cr. Memo No." <> '' then
                GenJournalLine."NCT Tax Invoice No." := PurchaseHeader."Vendor Invoice No.";

        "NCT AfterCopyPuchaseHeaderToGenLine"(GenJournalLine, PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromSalesHeader.
    /// </summary>
    /// <param name="SalesHeader">Parameter of type Record "Sales Header".</param>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "CopyHeaderFromSalesHeader"(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin

        GenJournalLine."NCT Journal Description" := SalesHeader."Posting Description";
        GenJournalLine."NCT Head Office" := SalesHeader."NCT Head Office";
        GenJournalLine."NCT VAT Branch Code" := SalesHeader."NCT VAT Branch Code";
        "NCT AfterCopySalesHeaderToGenLine"(GenJournalLine, SalesHeader);

    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterInsertEvent', '', true, true)]
    /// <summary> 
    /// Description for OnAfterInsertVat.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "VAT Entry".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    local procedure "OnAfterInsertVat"(var Rec: Record "VAT Entry"; RunTrigger: Boolean)
    var
        VATEntryReport: Record "NCT VAT Transections";
    begin
        if rec.IsTemporary then
            exit;

        VATEntryReport.INIT();
        VATEntryReport.TRANSFERFIELDS(Rec);
        if VATEntryReport.Insert() then;

    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for AfterCopyGLEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="GLEntry">Parameter of type Record "G/L Entry".</param>
    local procedure "AfterCopyGLEntryFromGenJnlLine"(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin

        GLEntry."NCT Journal Description" := GenJournalLine."NCT Journal Description";
        if GenJournalLine."NCT Document Line No." <> 0 then
            GLEntry."NCT Document Line No." := GenJournalLine."NCT Document Line No."
        else
            GLEntry."NCT Document Line No." := GenJournalLine."Line No.";

        "NCT AfterCopyGenJournalLineToGLEntry"(GLEntry, GenJournalLine);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', true, true)]
    /// <summary> 
    /// Description for OnsetUpNewLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="LastGenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "OnsetUpNewLine"(var GenJournalLine: Record "Gen. Journal Line"; LastGenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Document No." := LastGenJournalLine."Document No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyFromGen.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="BankAccountLedgerEntry">Parameter of type Record "Bank Account Ledger Entry".</param>
    local procedure "AfterCopyFromGen"(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        //   with BankAccountLedgerEntry do begin
        BankAccountLedgerEntry."NCT Bank Branch No." := GenJournalLine."NCT Bank Branch No.";
        BankAccountLedgerEntry."NCT Bank Code" := GenJournalLine."NCT Bank Code";
        BankAccountLedgerEntry."NCT Bank Name" := GenJournalLine."NCT Bank Name";
        BankAccountLedgerEntry."NCT Cheque Name" := GenJournalLine."NCT Pay Name";
        BankAccountLedgerEntry."NCT Cheque No." := GenJournalLine."NCT Cheque No.";
        BankAccountLedgerEntry."NCT Customer/Vendor No." := GenJournalLine."NCT Customer/Vendor No.";
        BankAccountLedgerEntry."NCT Cheque Date" := GenJournalLine."NCT Cheque Date";
        "NCT OnAfterBankAccountLedgerEntryCopyFromGenJnlLine"(BankAccountLedgerEntry, GenJournalLine);
        //  end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnAfterBankAccLedgEntryInsert', '', false, false)]
    local procedure OnPostBankAccOnAfterBankAccLedgEntryInsert(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    var
        CheckLedgEntry: Record "Check Ledger Entry";
        NextCheckEntryNo: Integer;
        DocNoMustBeEnteredErr: Label 'Document No. must be entered when Bank Payment Type is %1.', Comment = '%1 - option value';
        CheckAlreadyExistsErr: Label 'Check %1 already exists for this Bank Account.', Comment = '%1 - document no.';
    begin
        if ((GenJournalLine.Amount < 0) and (GenJournalLine."Bank Payment Type" = "Bank Payment Type"::" ") and (GenJournalLine."NCT Cheque No." <> ''))
     then begin
            if GenJournalLine."Document No." = '' then
                Error(DocNoMustBeEnteredErr, GenJournalLine."Bank Payment Type");
            CheckLedgEntry.Reset();
            CheckLedgEntry.LockTable();
            if CheckLedgEntry.FindLast() then
                NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
            else
                NextCheckEntryNo := 1;


            CheckLedgEntry.SetRange("Bank Account No.", GenJournalLine."Account No.");
            CheckLedgEntry.SetFilter(
              "Entry Status", '%1|%2|%3',
              CheckLedgEntry."Entry Status"::Printed,
              CheckLedgEntry."Entry Status"::Posted,
              CheckLedgEntry."Entry Status"::"Financially Voided");
            CheckLedgEntry.SetRange("Check No.", GenJournalLine."Document No.");
            if not CheckLedgEntry.IsEmpty() then
                Error(CheckAlreadyExistsErr, GenJournalLine."Document No.");

            CheckLedgEntry.Init();
            CheckLedgEntry.CopyFromBankAccLedgEntry(BankAccountLedgerEntry);
            CheckLedgEntry."Entry No." := NextCheckEntryNo;

            CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."Bank Payment Type"::"Manual Check";
            if BankAccount."Currency Code" <> '' then
                CheckLedgEntry.Amount := -GenJournalLine.Amount
            else
                CheckLedgEntry.Amount := -GenJournalLine."Amount (LCY)";
            CheckLedgEntry.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Check Ledger Entry", 'OnAfterCopyFromBankAccLedgEntry', '', TRUE, TRUE)]
    /// <summary> 
    /// Description for CopyFromBankLedger.
    /// </summary>
    /// <param name="BankAccountLedgerEntry">Parameter of type Record "Bank Account Ledger Entry".</param>
    /// <param name="CheckLedgerEntry">Parameter of type Record "Check Ledger Entry".</param>
    local procedure "CopyFromBankLedger"(BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var CheckLedgerEntry: Record "Check Ledger Entry")
    begin
        // with CheckLedgerEntry do begin
        CheckLedgerEntry."Check No." := COPYSTR(BankAccountLedgerEntry."External Document No.", 1, 20);
        CheckLedgerEntry."Check Date" := BankAccountLedgerEntry."Document Date";
        CheckLedgerEntry."External Document No." := BankAccountLedgerEntry."Document No.";
        CheckLedgerEntry."Bank Account No." := BankAccountLedgerEntry."Bank Account No.";
        CheckLedgerEntry."NCT Bank Branch No." := BankAccountLedgerEntry."NCT Bank Branch No.";
        CheckLedgerEntry."NCT Bank Code" := BankAccountLedgerEntry."NCT Bank Code";
        CheckLedgerEntry."NCT Bank Name" := BankAccountLedgerEntry."NCT Bank Name";
        CheckLedgerEntry."NCT Cheque Name" := BankAccountLedgerEntry."NCT Cheque Name";
        CheckLedgerEntry."NCT Cheque No." := BankAccountLedgerEntry."NCT Cheque No.";
        CheckLedgerEntry."NCT Customer/Vendor No." := BankAccountLedgerEntry."NCT Customer/Vendor No.";
        CheckLedgerEntry."NCT Cheque Date" := BankAccountLedgerEntry."NCT Cheque Date";
        "NCT OnAfterCheckLedgerEntryCopyFromBankLedger"(CheckLedgerEntry, BankAccountLedgerEntry);
        // end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyVendorFromGen.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VendorLedgerEntry">Parameter of type Record "Vendor Ledger Entry".</param>
    local procedure "AfterCopyVendorFromGen"(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        GenLine: Record "Gen. Journal Line";
    begin
        // with VendorLedgerEntry do begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("NCT Cheque No.", '<>%1', '');
        if GenLine.FindFirst() then begin
            VendorLedgerEntry."NCT Bank Name" := GenLine."NCT Bank Name";
            VendorLedgerEntry."NCT Bank Account No." := GenLine."NCT Bank Account No.";
            VendorLedgerEntry."NCT Bank Branch No." := GenLine."NCT Bank Branch No.";
            VendorLedgerEntry."NCT Bank Code" := GenLine."NCT Bank Code";
            VendorLedgerEntry."NCT Cheque Date" := GenLine."NCT Cheque Date";
            VendorLedgerEntry."NCT Cheque No." := GenLine."NCT Cheque No.";
            VendorLedgerEntry."NCT Customer/Vendor No." := GenLine."NCT Customer/Vendor No.";
        end;
        //  end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyCustFromGen.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="CustLedgerEntry">Parameter of type Record "Cust. Ledger Entry".</param>
    local procedure "AfterCopyCustFromGen"(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        GenLine: Record "Gen. Journal Line";
    begin
        // with CustLedgerEntry do begin

        CustLedgerEntry."NCT Billing Due Date" := GenJournalLine."Due Date";

        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("NCT Cheque No.", '<>%1', '');
        if GenLine.FindFirst() then begin
            CustLedgerEntry."Bank Account No." := GenLine."NCT Bank Account No.";
            CustLedgerEntry."NCT Bank Branch No." := GenLine."NCT Bank Branch No.";
            CustLedgerEntry."NCT Bank Code" := GenLine."NCT Bank Code";
            CustLedgerEntry."NCT Cheque Date" := GenLine."NCT Cheque Date";
            CustLedgerEntry."NCT Cheque No." := GenLine."NCT Cheque No.";
            CustLedgerEntry."NCT Customer/Vendor No." := GenLine."NCT Customer/Vendor No.";
        end;

        // end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for OnAfterCopyCustLedgerEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="CustLedgerEntry">Parameter of type Record "Cust. Ledger Entry".</param>
    local procedure "OnAfterCopyCustLedgerEntryFromGenJnlLine"(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."NCT Head Office" := GenJournalLine."NCT Head Office";
        CustLedgerEntry."NCT VAT Branch Code" := GenJournalLine."NCT VAT Branch Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for OnAfterCopyVendLedgerEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VendorLedgerEntry">Parameter of type Record "Vendor Ledger Entry".</param>
    local procedure "OnAfterCopyVendLedgerEntryFromGenJnlLine"(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."NCT Head Office" := GenJournalLine."NCT Head Office";
        VendorLedgerEntry."NCT VAT Branch Code" := GenJournalLine."NCT VAT Branch Code";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeUpdateDeleteLines', '', true, true)]
    local procedure "InsertPostedItemJournalLines"(var ItemJournalLine: Record "Item Journal Line")
    var
        PostedItemJournalLines: Record "NCT Posted ItemJournal Lines";
        ItemJnlLine2: Record "Item Journal Line";
    begin
        ItemJnlLine2.COPYFILTERS(ItemJournalLine);
        ItemJnlLine2.FINDSET();
        REPEAT
            PostedItemJournalLines.INIT();
            PostedItemJournalLines.TRANSFERFIELDS(ItemJnlLine2);
            PostedItemJournalLines."Entry No." := PostedItemJournalLines."LastPostedEntryNo"();
            PostedItemJournalLines."Posted By" := COPYSTR(USERID, 1, 50);
            PostedItemJournalLines."Posted DateTime" := CurrentDateTime();
            PostedItemJournalLines.INSERT(true);
        until ItemJnlLine2.next() = 0;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterSetupNewLine', '', True, true)]
    local procedure "AfterSetupNewLine"(var ItemJournalLine: Record "Item Journal Line"; var LastItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine."NCT Document No. Series" := LastItemJournalLine."NCT Document No. Series";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Item No.', TRUE, TRUE)]
    local procedure "AfterValidateItemNo"(var Rec: Record "Item Journal Line")
    var
        Item: Record Item;
        ItemJournalBatch: Record "Item Journal Batch";
    begin

        if not Item.get(Rec."Item No.") then
            Item.init();
        Rec."NCT Description 2" := Item."Description 2";
        if not ItemJournalBatch.GET(rec."Journal Template Name", Rec."Journal Batch Name") then
            ItemJournalBatch.init();
        if ItemJournalBatch."NCT Shortcut Dimension 1 Code" <> '' then
            rec.validate("Shortcut Dimension 1 Code", ItemJournalBatch."NCT Shortcut Dimension 1 Code");

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    /// <summary> 
    /// Description for AfterInitItemLedgEntry.
    /// </summary>
    /// <param name="ItemJournalLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="NewItemLedgEntry">Parameter of type Record "Item Ledger Entry".</param>
    local procedure "AfterInitItemLedgEntry"(ItemJournalLine: Record "Item Journal Line"; var NewItemLedgEntry: Record "Item Ledger Entry")
    begin

        NewItemLedgEntry."NCT Gen. Bus. Posting Group" := ItemJournalLine."Gen. Bus. Posting Group";
        NewItemLedgEntry."NCT Vat Bus. Posting Group" := ItemJournalLine."NCT Vat Bus. Posting Group";
        NewItemLedgEntry."NCT Vendor/Customer Name" := ItemJournalLine."NCT Vendor/Customer Name";
        NewItemLedgEntry."NCT Bin Code" := ItemJournalLine."Bin Code";
        "NCT OnCopyItemLedgerFromItemJournal"(NewItemLedgEntry, ItemJournalLine);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyItemJnlLineFromSalesHeader.
    /// </summary>
    /// <param name="SalesHeader">Parameter of type Record "Sales Header".</param>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    local procedure "AfterCopyItemJnlLineFromSalesHeader"(SalesHeader: Record "Sales Header"; var ItemJnlLine: Record "Item Journal Line")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            ItemJnlLine."Invoice No." := SalesHeader."No.";
        ItemJnlLine."NCT Vendor/Customer Name" := SalesHeader."Sell-to Customer Name";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchHeader', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyItemJnlLineFromPurchHeader.
    /// </summary>
    /// <param name="PurchHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    local procedure "AfterCopyItemJnlLineFromPurchHeader"(PurchHeader: Record "Purchase Header"; var ItemJnlLine: Record "Item Journal Line")
    begin
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            ItemJnlLine."Invoice No." := PurchHeader."No.";
        ItemJnlLine."NCT Vendor/Customer Name" := PurchHeader."Buy-from Vendor Name";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', TRUE, TRUE)]
    /// <summary> 
    /// Description for OnCopyFromSalesLine.
    /// </summary>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="SalesLine">Parameter of type Record "Sales Line".</param>
    local procedure "OnCopyFromSalesLine"(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        ItemJnlLine."NCT Vat Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        ItemJnlLine."Bin Code" := SalesLine."Bin Code";
        ItemJnlLine.Description := SalesLine.Description;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', TRUE, TRUE)]
    /// <summary> 
    /// Description for OnCopyFromPurchLine.
    /// </summary>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="PurchLine">Parameter of type Record "Purchase Line".</param>
    local procedure "OnCopyFromPurchLine"(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine."NCT Vat Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
        ItemJnlLine."Bin Code" := PurchLine."Bin Code";
        ItemJnlLine.Description := PurchLine.Description;
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT AfterCopyInvoicePostingBufferToGL"(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT AfterCopyInvoicePostBufferToGL"(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure "NCT AfterCopyGenLineToVatEntry"(var VatEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT AfterCopyPuchaseHeaderToGenLine"(var GenJournalLine: Record "Gen. Journal Line"; PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT AfterCopySalesHeaderToGenLine"(var GenJournalLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT AfterCopyGenJournalLineToGLEntry"(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT OnAfterBankAccountLedgerEntryCopyFromGenJnlLine"(var BankAccountLedger: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT OnAfterCheckLedgerEntryCopyFromBankLedger"(var CheckLedgerEntry: record "Check Ledger Entry"; BankAccountLedger: Record "Bank Account Ledger Entry")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure "NCT OnCopyItemLedgerFromItemJournal"(var ItemLedgerEntry: record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    [BusinessEvent(false)]
    local procedure "NCT OnBeforInsertWHTAPPLY"(var pWHTAppentry: Record "NCT WHT Applied Entry"; pWHTHeader: Record "NCT WHT Header"; pWhtLine: Record "NCT WHT Line"; pGenLine: Record "Gen. Journal Line")
    begin
    end;

    [BusinessEvent(false)]
    local procedure "NCT OnFilterWHTLineAPPLY"(pWHTHeader: Record "NCT WHT Header"; var pWhtLine: Record "NCT WHT Line"; pGenLine: Record "Gen. Journal Line")
    begin
    end;

}
