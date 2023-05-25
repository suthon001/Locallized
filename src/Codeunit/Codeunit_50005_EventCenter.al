codeunit 50005 EventFunction
{
    Permissions = TableData "G/L Entry" = rimd;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, true)]
    local procedure "OnAfterSubstituteReport"(ReportId: Integer; var NewReportId: Integer)
    begin

        if ReportId = 6 then
            NewReportId := 50051;
        if ReportId = 104 then
            NewReportId := 50052;
        if ReportId = 105 then
            NewReportId := 50053;
        if ReportId = 111 then
            NewReportId := 50054;
        if ReportId = 120 then
            NewReportId := 50055;
        if ReportId = 121 then
            NewReportId := 50056;
        if ReportId = 129 then
            NewReportId := 50057;
        if ReportId = 5601 then
            NewReportId := 50058;
        if ReportId = 5605 then
            NewReportId := 50059;
        if ReportId = 322 then
            NewReportId := 50060;
        if ReportId = 321 then
            NewReportId := 50061;
        if ReportId = 329 then
            NewReportId := 50062;
        if ReportId = 304 then
            NewReportId := 50063;
        if ReportId = REPORT::"Customer - List" then
            NewReportId := 50064;
        if ReportId = REPORT::"Customer - Order Detail" then
            NewReportId := 50065;
        if ReportId = REPORT::"Customer - Order Summary" then
            NewReportId := 50066;
        if ReportId = REPORT::"Customer/Item Sales" then
            NewReportId := 50067;
        if ReportId = REPORT::"Inventory - Customer Sales" then
            NewReportId := 50068;
        if ReportId = REPORT::"Bank Acc. - Detail Trial Bal." then
            NewReportId := 50069;
        if ReportId = REPORT::"Inventory - Vendor Purchases" then
            NewReportId := 50070;
        if ReportId = 1001 then
            NewReportId := 50071;
        if ReportId = 112 then
            NewReportId := 50072;
        if ReportId = 712 then
            NewReportId := 50073;
        if ReportId = 704 then
            NewReportId := 50074;
        if ReportId = 708 then
            NewReportId := 50075;
        if ReportId = 4 then
            NewReportId := 50077;

    end;

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
        GenLine: Record "Gen. Journal Line";
    begin

        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(GenJnlPost);
        GenLine.reset();
        GenLine.copy(GenJournalLine);
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenJnlPostPreview.SetContext(GenJnlPost, GenLine);
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
    /// <param name="BillingReceiptHeader">VAR Record "Billing Receipt Header".</param>
    [EventSubscriber(ObjectType::Table, database::"Billing Receipt Header", 'OnSendBillingReceiptforApproval', '', false, false)]
    local procedure RunWorkflowOnSendBillingReceiptApproval(var BillingReceiptHeader: Record "Billing Receipt Header")
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

    [EventSubscriber(ObjectType::Table, database::"Billing Receipt Header", 'OnCancelBillingReceiptforApproval', '', false, false)]
    local procedure OnCancelBillingReceiptforApproval(var BillingReceiptHeader: Record "Billing Receipt Header")
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
        if ApprovalEntry."Table ID" = Database::"Billing Receipt Header" then
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
        if ApprovalEntry."Table ID" = Database::"Billing Receipt Header" then
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
        if ApprovalEntry."Table ID" = Database::"Billing Receipt Header" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateBillingReceiptApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure "OnSetStatusToPendingApproval"(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean);
    var
        BillingReceipts: Record "Billing Receipt Header";
    begin
        case RecRef.Number of
            DATABASE::"Billing Receipt Header":
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
        BillingReceipts: Record "Billing Receipt Header";

    begin
        case RecRef.Number of
            DATABASE::"Billing Receipt Header":
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
        BillingReceipts: Record "Billing Receipt Header";

    begin
        case RecRef.Number of
            DATABASE::"Billing Receipt Header":
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
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBillingReceiptApprovalCode(), Database::"Billing Receipt Header", SendBillingReceiptReqLbl, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBillingReceiptApprovalCode(), Database::"Billing Receipt Header", CancelReqBillingReceiptLbl, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]

    local procedure "OnPopulateApprovalEntryArgument"(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance");
    var
        BillingReceipt: Record "Billing Receipt Header";
    begin
        case RecRef.Number OF
            DATABASE::"Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipt);
                    BillingReceipt.CalcFields(Amount);
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Billing" then
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Sales Billing";
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Receipt" then
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Sales Receipt";
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Purchase Billing" then
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Purchase Billing";
                    ApprovalEntryArgument."Document No." := BillingReceipt."No.";
                    ApprovalEntryArgument.Amount := BillingReceipt.Amount;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', false, false)]
    local procedure "OnAfterGetPageID"(RecordRef: RecordRef; var PageID: Integer)
    var
        BillingReceipt: Record "Billing Receipt Header";
    begin
        if (PageID = 0) and (RecordRef.Number = Database::"Billing Receipt Header") then begin
            RecordRef.SetTable(BillingReceipt);
            if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Billing" then
                PageID := Page::"Sales Billing List";
            if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Receipt" then
                PageID := Page::"Sales Receipt List";
            if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Purchase Billing" then
                PageID := Page::"Purchase Billing List";

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure "OnGetDocumentTypeAndNumber"(var RecRef: RecordRef; var IsHandled: Boolean; var DocumentNo: Text; var DocumentType: Text);
    var
        FieldRef: FieldRef;
    begin
        IF RecRef.Number = DATABASE::"Billing Receipt Header" then begin
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
    begin
        Workflow.SetRange(Category, BillingReceiptCatLbl);
        Workflow.SetRange(Template, true);
        if Workflow.IsEmpty then
            InsertWorkflowBillingReceiptTemplate();

    end;

    local procedure InsertWorkflowBillingReceiptTemplate()
    var
        ApprovalEntry: Record "Approval Entry";
        Workflow: Record 1501;
        workflowSetup: Codeunit "Workflow Setup";
        workflowwebhook: Record "Workflow Webhook Entry";
    begin
        workflowSetup.InsertTableRelation(Database::"Billing Receipt Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"Billing Receipt Header", 53, Database::"Workflow Webhook Entry", workflowwebhook.FieldNo("Data ID"));

        workflowSetup.InsertWorkflowTemplate(Workflow, BillingReceiptCatLbl, 'Billing Receipt Workflow', BillingReceiptCatLbl);
        InsertBillingReceiptDetailWOrkflow(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertBillingReceiptDetailWOrkflow(var workflow: Record 1501)
    var
        WorkflowSetpArgument: Record 1523;
        blankDateFormula: DateFormula;
        BillingReceipt: Record "Billing Receipt Header";
        WorkflowSetup: Codeunit "Workflow Setup";

    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildBillingReceiptCondition(BillingReceipt."Status"::Open),
      RunWorkflowOnSendBillingReceiptApprovalCode(),
       BuildBillingReceiptCondition(BillingReceipt."Status"::"Pending Approval"),
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

    local procedure BuildBillingReceiptCondition(Status: Option Open,Released,"Pending Approval","Create RV",Posted): Text
    var
        BillingReceipt: Record "Billing Receipt Header";
        workflowSetup: Codeunit "Workflow Setup";
    begin
        BillingReceipt.SetRange("Status", Status);
        EXIT(StrSubstNo(ItemBillingReceiptConditionTxt, workflowSetup.Encode(BillingReceipt.GetView(false))));
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
        ItemBillingReceiptConditionTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Billing Receipt Header">%1</DataItem></DataItems></ReportParameters>', Locked = true;

}