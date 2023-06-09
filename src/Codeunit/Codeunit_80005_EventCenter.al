/// <summary>
/// Codeunit NCT EventFunction (ID 80005).
/// </summary>
codeunit 80005 "NCT EventFunction"
{
    Permissions = TableData "G/L Entry" = rimd;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnAfterValidateEvent', 'AppliesToDocNo', false, false)]
    local procedure AppliesToDocNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line")
    var
        PurchaseBillingLine: Record "NCT Billing Receipt Line";
    begin

        if rec."Applies-to Doc. No." <> xRec."Applies-to Doc. No." then
            if (rec."Applies-to Doc. No." <> '') and (rec."Account Type" = rec."Account Type"::Vendor) then begin
                if rec."Ref. Billing & Receipt No." = '' then begin
                    PurchaseBillingLine.reset();
                    PurchaseBillingLine.SetRange("Document Type", PurchaseBillingLine."Document Type"::"Purchase Billing");
                    PurchaseBillingLine.SetRange("Source Document No.", rec."Applies-to Doc. No.");
                    if not PurchaseBillingLine.IsEmpty then
                        rec.FieldError("Applies-to Doc. No.", StrSubstNo('this record process by puchase billing'));
                end;
                InsertWHTCertificate(Rec, rec."Applies-to Doc. No.");
            end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnApplyVendorLedgerEntryOnBeforeModify', '', false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeModify(var GenJournalLine: Record "Gen. Journal Line")
    var
        VendLdgEntry: Record "Vendor Ledger Entry";
        PurchaseBillingLine: Record "NCT Billing Receipt Line";
        InvoiceNo: Text;
    begin
        if GenJournalLine."Document No." <> '' then begin

            VendLdgEntry.reset();
            VendLdgEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
            VendLdgEntry.SetRange("Applies-to ID", GenJournalLine."Document No.");
            if VendLdgEntry.FindSet() then begin
                repeat
                    if GenJournalLine."Ref. Billing & Receipt No." = '' then begin

                        PurchaseBillingLine.reset();
                        PurchaseBillingLine.SetRange("Document Type", PurchaseBillingLine."Document Type"::"Purchase Billing");
                        PurchaseBillingLine.SetRange("Source Document No.", VendLdgEntry."Document No.");
                        if not PurchaseBillingLine.IsEmpty then
                            VendLdgEntry.FieldError("Document No.", StrSubstNo('this record process by puchase billing'));
                    end;
                    if StrPos(InvoiceNO, VendLdgEntry."Document No.") = 0 then begin
                        if InvoiceNO <> '' then
                            InvoiceNO := InvoiceNO + '|';
                        InvoiceNO := InvoiceNO + VendLdgEntry."Document No.";
                    end;
                until VendLdgEntry.Next() = 0;
                InsertWHTCertificate(GenJournalLine, InvoiceNo);
            end;
        end;
    end;

    /// <summary>
    /// InsertWHTCertificate.
    /// </summary>
    /// <param name="rec">VAR Record "Gen. Journal Line".</param>
    /// <param name="pInvoiceNo">text.</param>
    procedure InsertWHTCertificate(var rec: Record "Gen. Journal Line"; pInvoiceNo: text)
    var
        GeneralSetup: Record "General Ledger Setup";
        ltGenJournalLine: Record "Gen. Journal Line";
        WHTHeader: Record "NCT WHT Header";
        NosMgt: Codeunit NoSeriesManagement;
        Vendor: Record Vendor;
        WHTBusiness: Record "NCT WHT Business Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ltWHTAppliedEntry: Record "NCT WHT Applied Entry";
        ltWHTEntry: Record "NCT WHT Line";
        ltLineNo: Integer;

    begin


        ltWHTAppliedEntry.reset();
        ltWHTAppliedEntry.SetFilter("Document No.", pInvoiceNo);
        if ltWHTAppliedEntry.FindFirst() then begin
            GeneralSetup.GET();
            GeneralSetup.TESTFIELD("NCT WHT Document Nos.");
            IF Rec."NCT WHT Document No." = '' THEN BEGIN
                WHTHeader.reset();
                WHTHeader.setrange("Gen. Journal Template Code", Rec."Journal Template Name");
                WHTHeader.setrange("Gen. Journal Batch Code", Rec."Journal Batch Name");
                WHTHeader.setrange("Gen. Journal Document No.", Rec."Document No.");
                if WHTHeader.FindFirst() then begin
                    if ltGenJournalLine.GET(WHTHeader."Gen. Journal Template Code", WHTHeader."Gen. Journal Batch Code", WHTHeader."Gen. Journal Line No.") then
                        ltGenJournalLine.Delete(true);
                    WHTHeader.DeleteAll();
                end;

                Vendor.GET(rec."Account No.");
                WHTBusiness.GET(ltWHTAppliedEntry."WHT Bus. Posting Group");
                WHTBusiness.TestField("WHT Certificate No. Series");
                WHTBusiness.TESTfield("WHT Account No.");


                WHTHeader.INIT();
                WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."NCT WHT Document Nos.", Rec."Posting Date", TRUE);
                WHTHeader."No. Series" := GeneralSetup."NCT WHT Document Nos.";
                WHTHeader."Gen. Journal Template Code" := Rec."Journal Template Name";
                WHTHeader."Gen. Journal Batch Code" := Rec."Journal Batch Name";
                WHTHeader."Gen. Journal Document No." := Rec."Document No.";
                WHTHeader."WHT Date" := Rec."Document Date";
                WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Vendor;
                WHTHeader.validate("WHT Source No.", Vendor."No.");
                WHTHeader.INSERT();

                WHTHeader."WHT Type" := WHTBusiness."WHT Type";
                WHTheader."WHT Certificate No." := NoSeriesMgt.GetNextNo(WHTBusiness."WHT Certificate No. Series", WorkDate(), true);
                WHTHeader."WHT Option" := ltWHTAppliedEntry."WHT Option";
                if ltWHTAppliedEntry."WHT Bus. Posting Group" <> '' then
                    WHTHeader."WHT Business Posting Group" := ltWHTAppliedEntry."WHT Bus. Posting Group";
                WHTHeader.Modify();


                ltWHTEntry.reset();
                ltWHTEntry.SetRange("WHT No.", WHTHeader."WHT No.");
                ltWHTEntry.DeleteAll();

                ltWHTAppliedEntry.reset();
                ltWHTAppliedEntry.SetFilter("Document No.", pInvoiceNo);
                if ltWHTAppliedEntry.FindSet() then begin
                    repeat
                        ltWHTEntry.reset();
                        ltWHTEntry.SetRange("WHT No.", WHTHeader."WHT No.");
                        ltWHTEntry.SetRange("WHT Business Posting Group", ltWHTAppliedEntry."WHT Bus. Posting Group");
                        ltWHTEntry.SetRange("WHT Product Posting Group", ltWHTAppliedEntry."WHT Prod. Posting Group");
                        if not ltWHTEntry.FindFirst() then begin
                            ltLineNo := ltLineNo + 10000;
                            ltWHTEntry.init();
                            ltWHTEntry."WHT No." := WHTHeader."WHT No.";
                            ltWHTEntry."WHT Line No." := ltLineNo;
                            ltWHTEntry."WHT Certificate No." := WHTHeader."WHT Certificate No.";
                            ltWHTEntry."WHT Date" := WHTHeader."WHT Date";
                            ltWHTEntry."WHT Business Posting Group" := ltWHTAppliedEntry."WHT Bus. Posting Group";
                            ltWHTEntry."WHT Product Posting Group" := ltWHTAppliedEntry."WHT Prod. Posting Group";
                            ltWHTEntry."WHT Base" := ltWHTAppliedEntry."WHT Base";
                            ltWHTEntry."WHT %" := ltWHTAppliedEntry."WHT %";
                            ltWHTEntry."WHT Amount" := ltWHTAppliedEntry."WHT Amount";
                            ltWHTEntry."WHT Name" := ltWHTAppliedEntry."WHT Name";
                            ltWHTEntry."WHT Post Code" := ltWHTAppliedEntry."WHT Post Code";
                            if ltWHTEntry.Insert() then;
                        end else begin
                            ltWHTEntry."WHT Amount" := ltWHTEntry."WHT Amount" + ltWHTAppliedEntry."WHT Amount";
                            ltWHTEntry."WHT Base" := ltWHTEntry."WHT Base" + ltWHTAppliedEntry."WHT Base";
                            ltWHTEntry.Modify();
                        end;
                    until ltWHTAppliedEntry.Next() = 0;
                    CreateWHTCertificate(WHTHeader, rec);
                end;

            end;
        end;
    end;

    /// <summary>
    /// CreateWHTCertificate.
    /// </summary>
    /// <param name="rec">VAR WHTHeader "NCT WHT Header".</param>
    /// <param name="pGenJournalLine">Record "Gen. Journal Line".</param>
    procedure CreateWHTCertificate(var WHTHeader: Record "NCT WHT Header"; pGenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        CurrLine: Integer;
        LastLine: Integer;
        WHTSetup: Record "NCT WHT Business Posting Group";
        WHTEntry: Record "NCT WHT Line";
        SumAmt: Decimal;
    begin
        if WHTHeader."WHT Certificate No." <> '' then begin
            WHTHeader.TESTfield("WHT Business Posting Group");

            Clear(CurrLine);

            GenJnlLine.RESET();
            GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine.SETRANGE("Journal Template Name", pGenJournalLine."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", pGenJournalLine."Journal Batch Name");
            GenJnlLine.SETRANGE("Document No.", pGenJournalLine."Document No.");
            GenJnlLine.setrange("Account Type", GenJnlLine."Account Type"::Vendor);
            IF GenJnlLine.FindLast() THEN
                CurrLine := GenJnlLine."Line No.";



            WHTSetup.GET(WHTHeader."WHT Business Posting Group");
            WHTSetup.TESTfield("WHT Account No.");

            GenJnlLine.RESET();
            GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine.SETRANGE("Journal Template Name", pGenJournalLine."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", pGenJournalLine."Journal Batch Name");
            GenJnlLine.SETRANGE("Document No.", pGenJournalLine."Document No.");
            GenJnlLine.SETFILTER("Line No.", '>%1', CurrLine);
            IF GenJnlLine.FindFirst() THEN
                LastLine := GenJnlLine."Line No.";
            IF LastLine = 0 THEN
                CurrLine += 10000
            ELSE
                CurrLine := ROUND((CurrLine + LastLine) / 2, 1);
            GenJnlLine.INIT();
            GenJnlLine."Journal Template Name" := WHTHeader."Gen. Journal Template Code";
            GenJnlLine."Journal Batch Name" := WHTHeader."Gen. Journal Batch Code";
            GenJnlLine."Source Code" := pGenJournalLine."Source Code";
            GenJnlLine."Line No." := CurrLine;
            GenJnlLine.INSERT();
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", WHTSetup."WHT Account No.");
            GenJnlLine."Posting Date" := pGenJournalLine."Posting Date";
            GenJnlLine."Document Date" := WHTHeader."WHT Date";
            GenJnlLine."Document Type" := pGenJournalLine."Document Type";
            GenJnlLine."Document No." := pGenJournalLine."Document No.";
            GenJnlLine."External Document No." := WHTHeader."WHT Certificate No.";
            GenJnlLine."NCT WHT Document No." := WHTHeader."WHT No.";

            WHTEntry.RESET();
            WHTEntry.SETRANGE("WHT No.", WHTHeader."WHT No.");
            WHTEntry.CalcSums("WHT Amount");
            SumAmt := WHTEntry."WHT Amount";
            GenJnlLine.Validate(Amount, -SumAmt);
            GenJnlLine.MODIFY();
            WHTHeader."Gen. Journal Line No." := CurrLine;
            WHTHeader."Gen. Journal Document No." := GenJnlLine."Document No.";
            WHTHeader.MODIFY();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, true)]
    local procedure "OnAfterSubstituteReport"(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = 4 then
            NewReportId := 80050;
        if ReportId = 6 then
            NewReportId := 80051;
        if ReportId = 104 then
            NewReportId := 80052;
        if ReportId = 105 then
            NewReportId := 80053;
        if ReportId = 111 then
            NewReportId := 80054;
        if ReportId = 120 then
            NewReportId := 80055;
        if ReportId = 121 then
            NewReportId := 80056;
        if ReportId = 129 then
            NewReportId := 80057;
        if ReportId = 5601 then
            NewReportId := 80058;
        if ReportId = 5605 then
            NewReportId := 80059;
        if ReportId = 322 then
            NewReportId := 80060;
        if ReportId = 321 then
            NewReportId := 80061;
        if ReportId = 329 then
            NewReportId := 80062;
        if ReportId = 304 then
            NewReportId := 80063;
        if ReportId = REPORT::"Customer - List" then
            NewReportId := 80064;
        if ReportId = REPORT::"Customer - Order Detail" then
            NewReportId := 80065;
        if ReportId = REPORT::"Customer - Order Summary" then
            NewReportId := 80066;
        if ReportId = REPORT::"Customer/Item Sales" then
            NewReportId := 80067;
        if ReportId = REPORT::"Inventory - Customer Sales" then
            NewReportId := 80068;
        if ReportId = REPORT::"Bank Acc. - Detail Trial Bal." then
            NewReportId := 80069;
        if ReportId = REPORT::"Inventory - Vendor Purchases" then
            NewReportId := 80070;
        if ReportId = 1001 then
            NewReportId := 80071;
        if ReportId = 112 then
            NewReportId := 80072;
        if ReportId = 712 then
            NewReportId := 80073;
        if ReportId = 704 then
            NewReportId := 80074;
        if ReportId = 708 then
            NewReportId := 80075;


    end;

    /// <summary>
    /// SalesPreviewVourcher.
    /// </summary>
    /// <param name="SalesHeader">Record "Sales Header".</param>
    /// <param name="TemporaryGL">Temporary VAR Record "G/L Entry".</param>
    procedure "SalesPreviewVourcher"(SalesHeader: Record "Sales Header"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        TempErrorMessage: Record "Error Message" temporary;
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(SalesPostYesNo);
        GenJnlPostPreview.SetContext(SalesPostYesNo, SalesHeader);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            InsertToTempGL(RecRef, TemporaryGL);
        end;
        if ErrorMessageMgt.GetErrors(TempErrorMessage) then
            ERROR(TempErrorMessage.Message);
    end;

    /// <summary> 
    /// Description for PurchasePreviewVourcher.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="TemporaryGL">Parameter of type Record "G/L Entry" temporary.</param>
    procedure "PurchasePreviewVourcher"(PurchaseHeader: Record "Purchase Header"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        TempErrorMessage: Record "Error Message" temporary;
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(PurchasePostYesNo);
        GenJnlPostPreview.SetContext(PurchasePostYesNo, PurchaseHeader);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            InsertToTempGL(RecRef, TemporaryGL);

        end;
        if ErrorMessageMgt.GetErrors(TempErrorMessage) then
            ERROR(TempErrorMessage.Message);
    end;

    /// <summary> 
    /// Description for GenLinePreviewVourcher.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="TemporaryGL">Parameter of type Record "G/L Entry" temporary.</param>
    procedure "GenLinePreviewVourcher"(GenJournalLine: Record "Gen. Journal Line"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        TempErrorMessage: Record "Error Message" temporary;
    begin

        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.SetContext(GenJnlPost, GenJournalLine);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            InsertToTempGL(RecRef, TemporaryGL);
        end;
        if ErrorMessageMgt.GetErrors(TempErrorMessage) then
            ERROR(TempErrorMessage.Message);
    end;

    /// <summary> 
    /// Description for InsertToTempGL.
    /// </summary>
    /// <param name="RecRef2">Parameter of type RecordRef.</param>
    /// <param name="TempGLEntry">Parameter of type Record "G/L Entry" temporary.</param>
    local procedure InsertToTempGL(RecRef2: RecordRef; var TempGLEntry: Record "G/L Entry" temporary)
    begin
        if NOT TempGLEntry.IsTemporary then
            Error('GL Entry must be Temporary Table!');
        TempGLEntry.reset();
        TempGLEntry.DeleteAll();
        if RecRef2.FindSet() then
            repeat
                RecRef2.SetTable(TempGLEntry);
                TempGLEntry.Insert();

            until RecRef2.next() = 0;
    end;

    /// <summary>
    /// RunWorkflowOnSendBillingReceiptHeaderApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnSendBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendBillingReceiptApproval'))
    end;



    /// <summary>
    /// RunWorkflowOnSendBillingReceiptApproval.
    /// </summary>
    /// <param name="BillingReceiptHeader">VAR Record "NCT Billing Receipt Header".</param>
    [EventSubscriber(ObjectType::Table, database::"NCT Billing Receipt Header", 'OnSendBillingReceiptforApproval', '', false, false)]
    local procedure RunWorkflowOnSendBillingReceiptApproval(var BillingReceiptHeader: Record "NCT Billing Receipt Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendBillingReceiptApprovalCode(), BillingReceiptHeader);
    end;

    /// <summary>
    /// RunWorkflowOnCancelBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnCancelBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelBillingReceiptApproval'));
    end;

    [EventSubscriber(ObjectType::Table, database::"NCT Billing Receipt Header", 'OnCancelBillingReceiptforApproval', '', false, false)]
    local procedure OnCancelBillingReceiptforApproval(var BillingReceiptHeader: Record "NCT Billing Receipt Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelBillingReceiptApprovalCode(), BillingReceiptHeader);
    end;




    /// <summary>
    /// RunWorkflowOnApproveBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnApproveBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveBillingReceiptApproval'))
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnApproveBillingReceiptApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"NCT Billing Receipt Header" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveBillingReceiptApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;




    /// <summary>
    /// RunWorkflowOnRejectBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnRejectBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectBillingReceiptApproval'))
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnRejectApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"NCT Billing Receipt Header" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectBillingReceiptApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    /// <summary>
    /// RunWorkflowOnDelegateBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnDelegateBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateBillingReceiptApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnDelegateApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"NCT Billing Receipt Header" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateBillingReceiptApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure "OnSetStatusToPendingApproval"(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean);
    var
        BillingReceipts: Record "NCT Billing Receipt Header";
    begin
        case RecRef.Number of
            DATABASE::"NCT Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipts);
                    BillingReceipts.Status := BillingReceipts.Status::"Pending Approval";
                    BillingReceipts.Modify();
                    IsHandled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure "OnReleaseDocument"(RecRef: RecordRef; var Handled: Boolean);
    var
        BillingReceipts: Record "NCT Billing Receipt Header";

    begin
        case RecRef.Number of
            DATABASE::"NCT Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipts);
                    BillingReceipts.Status := BillingReceipts.Status::Released;
                    BillingReceipts.Modify();

                end;
        end;
        Handled := true;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean);
    var
        BillingReceipts: Record "NCT Billing Receipt Header";

    begin
        case RecRef.Number of
            DATABASE::"NCT Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipts);
                    BillingReceipts.Status := BillingReceipts.Status::Open;
                    BillingReceipts.Modify();
                    Handled := true;
                END;
        end;
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure "AddBillingReceiptEventToLibrary"()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBillingReceiptApprovalCode(), Database::"NCT Billing Receipt Header", SendBillingReceiptReqLbl, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBillingReceiptApprovalCode(), Database::"NCT Billing Receipt Header", CancelReqBillingReceiptLbl, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]

    local procedure "OnPopulateApprovalEntryArgument"(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance");
    var
        BillingReceipt: Record "NCT Billing Receipt Header";
    begin
        case RecRef.Number OF
            DATABASE::"NCT Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipt);
                    BillingReceipt.CalcFields(Amount);
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Billing" then
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"NCT Sales Billing";
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Receipt" then
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"NCT Sales Receipt";
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Purchase Billing" then
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"NCT Purchase Billing";
                    ApprovalEntryArgument."Document No." := BillingReceipt."No.";
                    ApprovalEntryArgument.Amount := BillingReceipt.Amount;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', false, false)]
    local procedure "OnAfterGetPageID"(RecordRef: RecordRef; var PageID: Integer)
    var
        BillingReceipt: Record "NCT Billing Receipt Header";
    begin
        if (PageID = 0) and (RecordRef.Number = Database::"NCT Billing Receipt Header") then begin
            RecordRef.SetTable(BillingReceipt);
            if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Billing" then
                PageID := Page::"NCT Sales Billing List";
            if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Receipt" then
                PageID := Page::"NCT Sales Receipt List";
            if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Purchase Billing" then
                PageID := Page::"NCT Purchase Billing List";

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure "OnGetDocumentTypeAndNumber"(var RecRef: RecordRef; var IsHandled: Boolean; var DocumentNo: Text; var DocumentType: Text);
    var
        FieldRef: FieldRef;
    begin
        IF RecRef.Number = DATABASE::"NCT Billing Receipt Header" then begin
            DocumentType := RecRef.Caption;
            FieldRef := RecRef.FieldIndex(1);
            DocumentNo := Format(FieldRef.Value);
            FieldRef := RecRef.Field(2);
            DocumentNo += ',' + Format(FieldRef.Value);
            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure "OnAddWorkflowCategoriesToLibrary"();
    var
        workflowSetup: Codeunit "Workflow Setup";
    begin
        workflowSetup.InsertWorkflowCategory('BILLINGRECEIPT', 'Billing Receipt Workflow');

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInitWorkflowTemplates', '', false, false)]
    local procedure "OnAfterInitWorkflowTemplates"()
    var
        Workflow: Record Workflow;
        workflowSetup: Codeunit "Workflow Setup";
        BillingReceiptHeader: Record "NCT Billing Receipt Header";
        BillingReceiptLine: Record "NCT Billing Receipt Line";
        ApprovalEntry: Record "Approval Entry";

    begin
        Workflow.reset();
        Workflow.SetRange(Category, BillingReceiptCatLbl);
        Workflow.SetRange(Template, true);
        if Workflow.IsEmpty then begin
            workflowSetup.InsertTableRelation(Database::"NCT Billing Receipt Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
            workflowSetup.InsertTableRelation(Database::"NCT Billing Receipt Header", BillingReceiptHeader.FieldNo("Document Type"), DATABASE::"NCT Billing Receipt Line", BillingReceiptLine.FieldNo("Document Type"));
            workflowSetup.InsertTableRelation(Database::"NCT Billing Receipt Header", BillingReceiptHeader.FieldNo("No."), DATABASE::"NCT Billing Receipt Line", BillingReceiptLine.FieldNo("Document No."));
            InsertWorkflowBillingReceiptTemplateSalesBilling();
            InsertWorkflowBillingReceiptTemplateSalesReceipt();
            InsertWorkflowBillingReceiptTemplatePurchaseBilling();
        end;

    end;

    local procedure InsertWorkflowBillingReceiptTemplateSalesBilling()
    var

        Workflow: Record 1501;
        workflowSetup: Codeunit "Workflow Setup";

    begin
        workflowSetup.InsertWorkflowTemplate(Workflow, 'SBILLING', 'Sales Billing Workflow', BillingReceiptCatLbl);
        InsertBillingReceiptDetailWOrkflowSalesBilling(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertWorkflowBillingReceiptTemplateSalesReceipt()
    var
        Workflow: Record 1501;
        workflowSetup: Codeunit "Workflow Setup";

    begin
        workflowSetup.InsertWorkflowTemplate(Workflow, 'SRECEIPT', 'Sales Receipt Workflow', BillingReceiptCatLbl);
        InsertBillingReceiptDetailWOrkflowSalesReceipt(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertWorkflowBillingReceiptTemplatePurchaseBilling()
    var
        Workflow: Record 1501;
        workflowSetup: Codeunit "Workflow Setup";
    begin


        workflowSetup.InsertWorkflowTemplate(Workflow, 'PBILLING', 'Purchase Billing Workflow', BillingReceiptCatLbl);
        InsertBillingReceiptDetailWOrkflowPurchBilling(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertBillingReceiptDetailWOrkflowSalesBilling(var workflow: Record 1501)
    var

        WorkflowSetpArgument: Record 1523;
        blankDateFormula: DateFormula;
        BillingReceipt: Record "NCT Billing Receipt Header";
        WorkflowSetup: Codeunit "Workflow Setup";

    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildBillingReceiptCondition(BillingReceipt."Status"::Open, BillingReceipt."Document Type"::"Sales Billing"),
      RunWorkflowOnSendBillingReceiptApprovalCode(),
       BuildBillingReceiptCondition(BillingReceipt."Status"::"Pending Approval", BillingReceipt."Document Type"::"Sales Billing"),
       RunWorkflowOnCancelBillingReceiptApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;

    local procedure InsertBillingReceiptDetailWOrkflowSalesReceipt(var workflow: Record 1501)
    var

        WorkflowSetpArgument: Record 1523;
        blankDateFormula: DateFormula;
        BillingReceipt: Record "NCT Billing Receipt Header";
        WorkflowSetup: Codeunit "Workflow Setup";

    begin

        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildBillingReceiptCondition(BillingReceipt."Status"::Open, BillingReceipt."Document Type"::"Sales Receipt"),
      RunWorkflowOnSendBillingReceiptApprovalCode(),
       BuildBillingReceiptCondition(BillingReceipt."Status"::"Pending Approval", BillingReceipt."Document Type"::"Sales Receipt"),
       RunWorkflowOnCancelBillingReceiptApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;

    local procedure InsertBillingReceiptDetailWOrkflowPurchBilling(var workflow: Record 1501)
    var

        WorkflowSetpArgument: Record 1523;
        blankDateFormula: DateFormula;
        BillingReceipt: Record "NCT Billing Receipt Header";
        WorkflowSetup: Codeunit "Workflow Setup";

    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildBillingReceiptCondition(BillingReceipt."Status"::Open, BillingReceipt."Document Type"::"Purchase Billing"),
      RunWorkflowOnSendBillingReceiptApprovalCode(),
       BuildBillingReceiptCondition(BillingReceipt."Status"::"Pending Approval", BillingReceipt."Document Type"::"Purchase Billing"),
       RunWorkflowOnCancelBillingReceiptApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowEventPredecessorsToLibrary"(EventFunctionName: Code[128]);
    var
        WorkflowEventHadning: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            RunWorkflowOnCancelBillingReceiptApprovalCode():


                WorkflowEventHadning.AddEventPredecessor(RunWorkflowOnCancelBillingReceiptApprovalCode(), RunWorkflowOnSendBillingReceiptApprovalCode());
            WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHadning.AddEventPredecessor(WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendBillingReceiptApprovalCode());

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowResponsePredecessorsToLibrary"(ResponseFunctionName: Code[128]);
    var
        WorkflowResponseHanding: Codeunit 1521;
    begin
        case ResponseFunctionName of

            WorkflowResponseHanding.SetStatusToPendingApprovalCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SetStatusToPendingApprovalCode(),
                RunWorkflowOnSendBillingReceiptApprovalCode());
            WorkflowResponseHanding.SendApprovalRequestForApprovalCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SendApprovalRequestForApprovalCode(),
                RunWorkflowOnSendBillingReceiptApprovalCode());
            WorkflowResponseHanding.RejectAllApprovalRequestsCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.RejectAllApprovalRequestsCode(),
                RunWorkflowOnRejectBillingReceiptApprovalCode());
            WorkflowResponseHanding.CancelAllApprovalRequestsCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.CancelAllApprovalRequestsCode(),
                RunWorkflowOnCancelBillingReceiptApprovalCode());
            WorkflowResponseHanding.OpenDocumentCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.OpenDocumentCode(),
                RunWorkflowOnCancelBillingReceiptApprovalCode());
        end;

    end;

    local procedure BuildBillingReceiptCondition(Status: Enum "NCT Billing Receipt Status"; DocumentType: Enum "NCT Billing Document Type"): Text
    var
        BillingReceipt: Record "NCT Billing Receipt Header";
        BillingReceiptLine: Record "NCT Billing Receipt Line";
        workflowSetup: Codeunit "Workflow Setup";
    begin
        BillingReceipt.SetRange("Document Type", DocumentType);
        BillingReceipt.SetRange("Status", Status);
        exit(StrSubstNo(BillingReceiptConditionTxt, workflowSetup.Encode(BillingReceipt.GetView(false)), workflowSetup.Encode(BillingReceiptLine.GetView(false))));
    end;

    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
        PurchasePostYesNo: Codeunit "Purch.-Post (Yes/No)";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        BillingReceiptCatLbl: Label 'BILLINGRECEIPT';
        WFMngt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        SendBillingReceiptReqLbl: Label 'Approval Request for Billing Receipt is requested';
        CancelReqBillingReceiptLbl: Label 'Approval of a Billing Receipt is canceled';
        BillingReceiptConditionTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="NCT Billing Receipt Header">%1</DataItem><DataItem name="NCT Billing Receipt Line">%2</DataItem></DataItems></ReportParameters>', Locked = true;

}