/// <summary>
/// Codeunit Journal Function (ID 50000).
/// </summary>
codeunit 50000 "Journal Function"
{
    EventSubscriberInstance = StaticAutomatic;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforePostGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for InsertPostedGenLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "OnBeforePostGenJnlLine"(var GenJournalLine: Record "Gen. Journal Line")
    var
        WHTHeader: Record "WHT Header";
        BillingHeader: Record "Billing Receipt Header";

    begin

        WHTHeader.reset();
        WHTHeader.setrange("Gen. Journal Template Code", GenJournalLine."Journal Template Name");
        WHTHeader.setrange("Gen. Journal Batch Code", GenJournalLine."Journal Batch Name");
        WHTHeader.setrange("Gen. Journal Line No.", GenJournalLine."Line No.");
        if WHTHeader.FindFirst() then begin
            WHTHeader."Posted" := true;
            WHTHeader.Modify();
        end;

        BillingHeader.reset();
        BillingHeader.SetRange("Template Name", GenJournalLine."Journal Template Name");
        BillingHeader.SetRange("Batch Name", GenJournalLine."Journal Batch Name");
        BillingHeader.SetRange("Journal Document No.", GenJournalLine."Document No.");
        if BillingHeader.FindFirst() then begin
            BillingHeader."Status" := BillingHeader."Status"::Posted;
            BillingHeader."Posted Document No." := GenJournalLine."Document No.";
            BillingHeader.Modify();
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertPostUnrealVATEntry', '', true, true)]
    /// <summary> 
    /// Description for PostUnrealVatEntry.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VATEntry">Parameter of type Record "VAT Entry".</param>
    local procedure "PostUnrealVatEntry"(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        VATEntry."Tax Invoice Base" := VATEntry.Base;
        VATEntry."Tax Invoice Amount" := VATEntry.Amount;
    end;
    //OnAfterCopyGenJnlLineFromInvPostBuffer
    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromInvoiceBuff.
    /// </summary>
    local procedure "CopyHeaderFromInvoiceBuff"(InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line")
    begin
        // with GenJournalLine do begin
        GenJnlLine."Tax Invoice No." := InvoicePostingBuffer."Tax Invoice No.";
        GenJnlLine."Tax Invoice Date" := InvoicePostingBuffer."Tax Invoice Date";
        GenJnlLine."Tax Invoice Base" := InvoicePostingBuffer."Tax Invoice Base";
        GenJnlLine."Tax Invoice Amount" := InvoicePostingBuffer."Tax Invoice Amount";
        GenJnlLine."Tax Vendor No." := InvoicePostingBuffer."Tax Vendor No.";
        GenJnlLine."Tax Invoice Name" := InvoicePostingBuffer."Tax Invoice Name";
        GenJnlLine."Tax Invoice Name 2" := InvoicePostingBuffer."Tax Invoice Name 2";
        GenJnlLine."Tax Invoice Address" := InvoicePostingBuffer.Address;
        GenJnlLine."Tax Invoice Address 2" := InvoicePostingBuffer."Address 2";
        GenJnlLine."Head Office" := InvoicePostingBuffer."Head Office";
        GenJnlLine."Branch Code" := InvoicePostingBuffer."Branch Code";
        GenJnlLine."VAT Registration No." := InvoicePostingBuffer."VAT Registration No.";
        GenJnlLine."Description Line" := InvoicePostingBuffer."Description Line";
        GenJnlLine."Tax Invoice Address" := InvoicePostingBuffer."Address";
        GenJnlLine."Tax Invoice City" := InvoicePostingBuffer."City";
        GenJnlLine."Tax Invoice Post Code" := InvoicePostingBuffer."Post Code";
        GenJnlLine."Document Line No." := InvoicePostingBuffer."Document Line No.";

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

        VATEntry."Head Office" := GenJournalLine."Head Office";
        VATEntry."Branch Code" := GenJournalLine."Branch Code";
        VATEntry."Tax Invoice No." := GenJournalLine."Tax Invoice No.";
        VATEntry."Tax Invoice Name" := GenJournalLine."Tax Invoice Name";
        VATEntry."Tax Invoice Name 2" := GenJournalLine."Tax Invoice Name 2";
        VATEntry."Tax Vendor No." := GenJournalLine."Tax Vendor No.";
        VATEntry."Tax Invoice Base" := GenJournalLine."Tax Invoice Base";
        VATEntry."Tax Invoice Date" := GenJournalLine."Tax Invoice Date";
        VATEntry."Tax Invoice Amount" := GenJournalLine."Tax Invoice Amount";
        VATEntry."VAT Registration No." := GenJournalLine."VAT Registration No.";
        VATEntry."Tax Invoice Address" := GenJournalLine."Tax Invoice Address";
        VATEntry."Tax Invoice Address 2" := GenJournalLine."Tax Invoice Address 2";
        VATEntry."Tax Invoice City" := GenJournalLine."Tax Invoice City";
        VATEntry."Tax Invoice Post Code" := GenJournalLine."Tax Invoice Post Code";
        VATEntry."External Document No." := GenJournalLine."External Document No.";
        if GenJournalLine."Document Line No." <> 0 then
            VATEntry."Document Line No." := GenJournalLine."Document Line No."
        else
            VATEntry."Document Line No." := GenJournalLine."Line No.";
        if NOT VATProPostingGroup.get(VATEntry."VAT Prod. Posting Group") then
            VATProPostingGroup.init();
        IF VATProPostingGroup."Direct VAT" then
            VATEntry."Tax Invoice Amount" := GenJournalLine.Amount
        ELSE BEGIN
            IF VATEntry."Tax Invoice Base" = 0 THEN
                VATEntry."Tax Invoice Base" := VATEntry.Base;
            IF VATEntry."Tax Invoice Amount" = 0 THEN
                VATEntry."Tax Invoice Amount" := VATEntry.Amount;
        END;
        //   end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnBeforeInsertEvent', '', true, true)]
    /// <summary> 
    /// Description for SetVatLocalize.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "VAT Entry".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    local procedure "SetVatLocalize"(var Rec: Record "VAT Entry"; RunTrigger: Boolean)
    var
        vatPostingGroup: Record "VAT Product Posting Group";
    begin
        if RunTrigger then
            // with Rec do begin
            IF vatPostingGroup.GET(Rec."VAT Prod. Posting Group") then
                IF NOT vatPostingGroup."Direct VAT" THEN BEGIN
                    Rec."Tax Invoice Base" := Rec.Base;
                    Rec."Tax Invoice Amount" := Rec.Amount;
                END;
        // end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromPurchaseHeader.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "CopyHeaderFromPurchaseHeader"(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //  with GenJournalLine do begin
        GenJournalLine."Description Line" := PurchaseHeader."Posting Description";
        // end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromSalesHeader.
    /// </summary>
    /// <param name="SalesHeader">Parameter of type Record "Sales Header".</param>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "CopyHeaderFromSalesHeader"(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        // with GenJournalLine do begin
        GenJournalLine."Description Line" := SalesHeader."Posting Description";
        //  end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterInsertEvent', '', true, true)]
    /// <summary> 
    /// Description for OnAfterInsertVat.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "VAT Entry".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    local procedure "OnAfterInsertVat"(var Rec: Record "VAT Entry"; RunTrigger: Boolean)
    var
        VATEntryReport: Record "VAT Transections";
    begin
        if not Rec.IsTemporary then begin
            VATEntryReport.INIT();
            VATEntryReport.TRANSFERFIELDS(Rec);
            VATEntryReport.Insert();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for AfterCopyGLEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="GLEntry">Parameter of type Record "G/L Entry".</param>
    local procedure "AfterCopyGLEntryFromGenJnlLine"(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."Journal Description" := GenJournalLine."Journal Description";
        if GenJournalLine."Document Line No." <> 0 then
            GLEntry."Document Line No." := GenJournalLine."Document Line No."
        else
            GLEntry."Document Line No." := GenJournalLine."Line No.";
        GLEntry."Template Name" := GenJournalLine."Journal Template Name";
        GLEntry."Batch Name" := GenJournalLine."Journal Batch Name";
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
        BankAccountLedgerEntry."Bank Account No." := GenJournalLine."Bank Account No.";
        BankAccountLedgerEntry."Bank Branch No." := GenJournalLine."Bank Branch No.";
        BankAccountLedgerEntry."Bank Code" := GenJournalLine."Bank Code";
        BankAccountLedgerEntry."Bank Name" := GenJournalLine."Bank Name";
        BankAccountLedgerEntry."Cheque Name" := GenJournalLine."Cheque Name";
        BankAccountLedgerEntry."Cheque No." := GenJournalLine."Cheque No.";
        BankAccountLedgerEntry."Customer/Vendor No." := GenJournalLine."Customer/Vendor No.";
        BankAccountLedgerEntry."Cheque Date" := GenJournalLine."Cheque Date";
        //  end;
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
        CheckLedgerEntry."Bank Branch No." := BankAccountLedgerEntry."Bank Branch No.";
        CheckLedgerEntry."Bank Code" := BankAccountLedgerEntry."Bank Code";
        CheckLedgerEntry."Bank Name" := BankAccountLedgerEntry."Bank Name";
        CheckLedgerEntry."Cheque Name" := BankAccountLedgerEntry."Cheque Name";
        CheckLedgerEntry."Cheque No." := BankAccountLedgerEntry."Cheque No.";
        CheckLedgerEntry."Customer/Vendor No." := BankAccountLedgerEntry."Customer/Vendor No.";
        CheckLedgerEntry."Cheque Date" := BankAccountLedgerEntry."Cheque Date";
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
        GenLine.SetFilter("Cheque No.", '<>%1', '');
        if GenLine.FindFirst() then begin
            VendorLedgerEntry."Bank Name" := GenLine."Bank Name";
            VendorLedgerEntry."Bank Account No." := GenLine."Bank Account No.";
            VendorLedgerEntry."Bank Branch No." := GenLine."Bank Branch No.";
            VendorLedgerEntry."Bank Code" := GenLine."Bank Code";
            VendorLedgerEntry."Cheque Date" := GenLine."Cheque Date";
            VendorLedgerEntry."Cheque No." := GenLine."Cheque No.";
            VendorLedgerEntry."Customer/Vendor No." := GenLine."Customer/Vendor No.";
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

        CustLedgerEntry."Billing Due Date" := GenJournalLine."Due Date";

        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("Cheque No.", '<>%1', '');
        if GenLine.FindFirst() then begin
            CustLedgerEntry."Bank Account No." := GenLine."Bank Account No.";
            CustLedgerEntry."Bank Branch No." := GenLine."Bank Branch No.";
            CustLedgerEntry."Bank Code" := GenLine."Bank Code";
            CustLedgerEntry."Cheque Date" := GenLine."Cheque Date";
            CustLedgerEntry."Cheque No." := GenLine."Cheque No.";
            CustLedgerEntry."Customer/Vendor No." := GenLine."Customer/Vendor No.";
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
        CustLedgerEntry."Head Office" := GenJournalLine."Head Office";
        CustLedgerEntry."Branch Code" := GenJournalLine."Branch Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for OnAfterCopyVendLedgerEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VendorLedgerEntry">Parameter of type Record "Vendor Ledger Entry".</param>
    local procedure "OnAfterCopyVendLedgerEntryFromGenJnlLine"(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."Head Office" := GenJournalLine."Head Office";
        VendorLedgerEntry."Branch Code" := GenJournalLine."Branch Code";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeUpdateDeleteLines', '', true, true)]
    local procedure "InsertPostedItemJournalLines"(var ItemJournalLine: Record "Item Journal Line")
    var
        PostedItemJournalLines: Record "Posted ItemJournal Lines";
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
        ItemJournalLine."Document No. Series" := LastItemJournalLine."Document No. Series";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Item No.', TRUE, TRUE)]
    local procedure "AfterValidateItemNo"(var Rec: Record "Item Journal Line")
    var
        Item: Record Item;
        ItemJournalBatch: Record "Item Journal Batch";
        ItemTemplateName: Record "Item Journal Template";
    begin

        if not Item.get(Rec."Item No.") then
            Item.init();
        Rec."Description 2" := Item."Description 2";
        if not ItemJournalBatch.GET(rec."Journal Template Name", Rec."Journal Batch Name") then
            ItemJournalBatch.init();
        ItemTemplateName.GET(rec."Journal Template Name");
        if ItemTemplateName.Type = ItemTemplateName.Type::Item then
            rec."Entry Type" := ItemJournalBatch."Default Entry Type";
        if ItemJournalBatch."Shortcut Dimension 1 Code" <> '' then
            rec.validate("Shortcut Dimension 1 Code", ItemJournalBatch."Shortcut Dimension 1 Code");

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    /// <summary> 
    /// Description for AfterInitItemLedgEntry.
    /// </summary>
    /// <param name="ItemJournalLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="NewItemLedgEntry">Parameter of type Record "Item Ledger Entry".</param>
    local procedure "AfterInitItemLedgEntry"(ItemJournalLine: Record "Item Journal Line"; var NewItemLedgEntry: Record "Item Ledger Entry")
    begin
        //  with ItemJournalLine do begin
        NewItemLedgEntry."Invoice No." := ItemJournalLine."Invoice No.";
        NewItemLedgEntry."Gen. Bus. Posting Group" := ItemJournalLine."Gen. Bus. Posting Group";
        NewItemLedgEntry."Vat Bus. Posting Group" := ItemJournalLine."Vat Bus. Posting Group";
        NewItemLedgEntry."Vendor/Customer Name" := ItemJournalLine."Vendor/Customer Name";
        NewItemLedgEntry."Bin Code" := ItemJournalLine."Bin Code";
        //  end;
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
        ItemJnlLine."Vendor/Customer Name" := SalesHeader."Sell-to Customer Name";
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
        ItemJnlLine."Vendor/Customer Name" := PurchHeader."Buy-from Vendor Name";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', TRUE, TRUE)]
    /// <summary> 
    /// Description for OnCopyFromSalesLine.
    /// </summary>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="SalesLine">Parameter of type Record "Sales Line".</param>
    local procedure "OnCopyFromSalesLine"(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        ItemJnlLine."Vat Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
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
        ItemJnlLine."Vat Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
        ItemJnlLine."Bin Code" := PurchLine."Bin Code";
        ItemJnlLine.Description := PurchLine.Description;
    end;


}
