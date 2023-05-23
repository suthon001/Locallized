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


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', false, false)]
    local procedure "OnAfterGetPageID"(RecordRef: RecordRef; var PageID: Integer)
    begin

        if (PageID = 0) and (RecordRef.Number = Database::"Item Journal Line") then
            PageID := Page::"Item Journal";
    end;

    procedure "SalesPreviewVourcher"(SalesHeader: Record "Sales Header"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        ErrorMsg: Record "Error Message" temporary;
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(SalesPostYesNo);
        GenJnlPostPreview.SetContext(SalesPostYesNo, SalesHeader);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            "InsertToTempGL"(RecRef, TemporaryGL);
        end;
        if ErrorMessageMgt.GetErrors(ErrorMsg) then
            ERROR(STRSUBSTNO('%1 %2', ErrorMsg."Field Name", ErrorMsg.Description));
    end;

    /// <summary> 
    /// Description for PurchasePreviewVourcher.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="TemporaryGL">Parameter of type Record "G/L Entry" temporary.</param>
    procedure "PurchasePreviewVourcher"(PurchaseHeader: Record "Purchase Header"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        ErrorMsg: Record "Error Message" temporary;
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(PurchasePostYesNo);
        GenJnlPostPreview.SetContext(PurchasePostYesNo, PurchaseHeader);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            "InsertToTempGL"(RecRef, TemporaryGL);

        end;
        if ErrorMessageMgt.GetErrors(ErrorMsg) then
            ERROR(STRSUBSTNO('%1 %2', ErrorMsg."Field Name", ErrorMsg.Description));
    end;

    /// <summary> 
    /// Description for GenLinePreviewVourcher.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="TemporaryGL">Parameter of type Record "G/L Entry" temporary.</param>
    procedure "GenLinePreviewVourcher"(GenJournalLine: Record "Gen. Journal Line"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        ErrorMsg: Record "Error Message" temporary;
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
            "InsertToTempGL"(RecRef, TemporaryGL);
        end;
        if ErrorMessageMgt.GetErrors(ErrorMsg) then
            ERROR(STRSUBSTNO('%1 %2', ErrorMsg."Field Name", ErrorMsg.Description));
    end;

    /// <summary> 
    /// Description for InsertToTempGL.
    /// </summary>
    /// <param name="RecRef2">Parameter of type RecordRef.</param>
    /// <param name="TempGLEntry">Parameter of type Record "G/L Entry" temporary.</param>
    local procedure "InsertToTempGL"(RecRef2: RecordRef; var TempGLEntry: Record "G/L Entry" temporary)
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


    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
        PurchasePostYesNo: Codeunit "Purch.-Post (Yes/No)";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorMessageHandler: Codeunit "Error Message Handler";

}