/// <summary>
/// Report Debit Note (ID 80026).
/// </summary>
report 80026 "NCT Debit Note"
{
    Caption = 'Debit Note';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80026_DebitNote.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    Permissions = tabledata "Sales Invoice Header" = rm;
    dataset
    {

        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            UseTemporary = true;
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(PostingDate; format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentDate; format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Requested_Delivery_Date; format("Requested Delivery Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Due_Date; format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; "No.") { }
            column(CustText_1; CustText[1]) { }
            column(CustText_2; CustText[2]) { }
            column(CustText_3; CustText[3]) { }
            column(CustText_4; CustText[4]) { }
            column(CustText_5; CustText[5]) { }
            column(CustText_9; CustText[9]) { }
            column(CustText_10; CustText[10]) { }
            column(ExchangeRate; ExchangeRate) { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(CommentText_1; CommentText[1]) { }
            column(CommentText_2; CommentText[2]) { }
            column(CommentText_3; CommentText[3]) { }
            column(CommentText_4; CommentText[4]) { }
            column(CommentText_5; CommentText[5]) { }
            column(Payment_Terms_Code; PaymentTerm.Description) { }
            column(CreateDocBy; "NCT Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(AmtText; AmtText) { }
            column(TotalAmt_1; TotalAmt[1]) { }
            column(TotalAmt_2; TotalAmt[2]) { }
            column(TotalAmt_3; TotalAmt[3]) { }
            column(TotalAmt_4; TotalAmt[4]) { }
            column(TotalAmt_5; TotalAmt[5]) { }
            column(TotalAmt_99; TotalAmt[99]) { }
            column(TotalAmt_100; TotalAmt[100]) { }
            column(VatText; VatText) { }
            column(Quote_No_; "Quote No.") { }
            column(ShipMethod_Description; ShipMethod.Description) { }
            column(CaptionOptionThai; CaptionOptionThai) { }
            column(CaptionOptionEng; CaptionOptionEng) { }
            column(RefDocumentNo; RefDocumentNo) { }
            column(var_RefDocumentNo; RefDocumentNo) { }
            column(var_RefDocumentDate; format(var_RefDocumentDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(ReturnReasonDescFirstLine; ReturnReasonDescFirstLine) { }
            dataitem(myLoop; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(Number; Number) { }
                column(OriginalCaption; OriginalCaption) { }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = SalesHeader;
                    UseTemporary = true;
                    column(SalesLine_No_; "No.") { }
                    column(SalesLine_Description; Description) { }
                    column(SalesLine_Description_2; "Description 2") { }
                    column(SalesLine_Unit_Price; "Unit Price") { }
                    column(Line_Discount__; "Line Discount %") { }
                    column(SalesLine_Line_Amount; "Line Amount") { }
                    column(SalesLine_LineNo; LineNo) { }
                    column(SalesLine_Quantity; Quantity) { }
                    column(SalesLine_Unit_of_Measure_Code; "Unit of Measure Code") { }

                    trigger OnAfterGetRecord()
                    begin
                        If "No." <> '' then
                            LineNo += 1;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoOfCopies + 1);
                end;

                trigger OnAfterGetRecord()
                begin
                    LineNo := 0;
                    if Number = 1 then
                        OriginalCaption := 'Original'
                    else
                        OriginalCaption := 'Copy';
                end;
            }

            trigger OnAfterGetRecord()
            var
                NewDate: Date;
                RecReturnReason: Record "Return Reason";
                ltDocumentType: Enum "Sales Comment Document Type";
                ltSalesHeader: Record "Sales Header";
                ltSalesInvoice: Record "Sales Invoice Header";
            begin
                if "Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", true);
                if not FromPosted then begin

                    FunctionCenter.SalesStatistic("Document Type", "No.", TotalAmt, VatText);
                    FunctionCenter.GetSalesComment("Document Type", "No.", 0, CommentText);
                    FunctionCenter.SalesInformation("Document Type", "No.", CustText, 0);
                    if ("Last Thai Report Cap." <> CaptionOptionThai) or ("Last Eng Report Cap." <> CaptionOptionEng) then begin
                        ltSalesHeader.GET("Document Type", "No.");
                        ltSalesHeader."Last Thai Report Cap." := CaptionOptionThai;
                        ltSalesHeader."Last Eng Report Cap." := CaptionOptionEng;
                        ltSalesHeader.Modify();
                    end;
                end else begin
                    FunctionCenter.PostedSalesInvoiceStatistics("No.", TotalAmt, VatText);
                    FunctionCenter.GetSalesComment(ltDocumentType::"Posted Invoice", "No.", 0, CommentText);
                    FunctionCenter.SalesPostedCustomerInformation(2, "No.", CustText, 0);
                    if ("Last Thai Report Cap." <> CaptionOptionThai) or ("Last Eng Report Cap." <> CaptionOptionEng) then begin
                        ltSalesInvoice.GET("No.");
                        ltSalesInvoice."Last Thai Report Cap." := CaptionOptionThai;
                        ltSalesInvoice."Last Eng Report Cap." := CaptionOptionEng;
                        ltSalesInvoice.Modify();
                    end;
                end;
                FunctionCenter."ConvExchRate"("Currency Code", "Currency Factor", ExchangeRate);
                IF NOT PaymentTerm.GET(SalesHeader."Payment Terms Code") then
                    PaymentTerm.Init();
                IF NOT ShipMethod.Get("Shipment Method Code") then
                    ShipMethod.Init();
                NewDate := DT2Date("NCT Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                if "Currency Code" = '' then
                    AmtText := '(' + FunctionCenter."NumberThaiToText"(TotalAmt[5]) + ')'
                else
                    AmtText := '(' + FunctionCenter."NumberEngToText"(TotalAmt[5], "Currency Code") + ')';

                TotalAmt[100] := "NCT Ref. Tax Invoice Amount";
                TotalAmt[99] := TotalAmt[100] - TotalAmt[1];
                var_RefDocumentDate := "NCT Ref. Tax Invoice Date";
                RefDocumentNo := "NCT Ref. Tax Invoice No.";

                ReturnReasonDescFirstLine := '';
                RecSaleLine.Reset();
                RecSaleLine.SetRange("Document Type", SalesHeader."Document Type");
                RecSaleLine.SetRange("Document No.", SalesHeader."No.");
                RecSaleLine.SetFilter("Return Reason Code", '<>%1', '');
                if RecSaleLine.FindFirst() then begin

                    if NOT RecReturnReason.Get(RecSaleLine."Return Reason Code") then
                        RecReturnReason.init();
                    ReturnReasonDescFirstLine := RecReturnReason.Description;

                end;
            end;


        }
    }

    requestpage
    {


        layout
        {
            area(content)
            {
                group("Options")
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = all;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the value of the No. of Copies field.';
                        MinValue = 0;
                    }
                    field(CaptionOptionThai; CaptionOptionThai)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption (Thai)';
                        ToolTip = 'Specifies the value of the Caption field.';
                        trigger OnAssistEdit()
                        var
                            EvenCenter: Codeunit "NCT EventFunction";
                            ltDocumentType: Enum "NCT Document Type Report";
                        begin
                            EvenCenter.SelectCaptionReport(CaptionOptionThai, CaptionOptionEng, ltDocumentType::"Sales Invoice");
                        end;
                    }
                    field(CaptionOptionEng; CaptionOptionEng)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption (Eng)';
                        ToolTip = 'Specifies the value of the Caption field.';
                    }
                }
            }
        }


    }
    trigger OnPreReport()
    begin
        companyInfor.Get();
        companyInfor.CalcFields(Picture);

    end;

    /// <summary>
    /// SetDataTable.
    /// </summary>
    /// <param name="pVariant">Variant.</param>
    procedure SetDataTable(pVariant: Variant)
    var
        ltRecordRef: RecordRef;
        ltSalesLine: Record "Sales Line";
        ltSalesInvLine: Record "Sales Invoice Line";
    begin
        ltRecordRef.GetTable(pVariant);
        if ltRecordRef.FindFirst() then begin
            if ltRecordRef.Number = Database::"Sales Header" then begin
                FromPosted := false;
                ltRecordRef.SetTable(SalesHeader);
                SalesHeader.Insert();
                CaptionOptionThai := SalesHeader."Last Thai Report Cap.";
                CaptionOptionEng := SalesHeader."Last Eng Report Cap.";
                ltSalesLine.reset();
                ltSalesLine.SetRange("Document Type", SalesHeader."Document Type");
                ltSalesLine.SetRange("Document No.", SalesHeader."No.");
                if ltSalesLine.FindSet() then
                    repeat
                        SalesLine.Init();
                        SalesLine.TransferFields(ltSalesLine);
                        SalesLine.Insert();
                    until ltSalesLine.Next() = 0;
            end;
            if ltRecordRef.Number = Database::"Sales Invoice Header" then begin
                FromPosted := true;
                ltRecordRef.SetTable(SalesInvoice);
                SalesHeader.TransferFields(SalesInvoice, false);
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader."No." := SalesInvoice."No.";
                SalesHeader.Insert();
                CaptionOptionThai := SalesHeader."Last Thai Report Cap.";
                CaptionOptionEng := SalesHeader."Last Eng Report Cap.";
                ltSalesInvLine.reset();
                ltSalesInvLine.SetRange("Document No.", SalesHeader."No.");
                if ltSalesInvLine.FindSet() then
                    repeat
                        SalesLine.Init();
                        SalesLine.TransferFields(ltSalesInvLine, false);
                        SalesLine."Document Type" := SalesHeader."Document Type";
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := ltSalesInvLine."Line No.";
                        SalesLine.Insert();

                    until ltSalesInvLine.Next() = 0;
            end;
            SalesLine.Reset();
            "Sales Line".Copy(SalesLine, true);
            RecSaleLine.copy(SalesLine, true);
            Commit();
        end;

    end;

    var
        SalesLine, RecSaleLine : Record "Sales Line" temporary;
        SalesInvoice: Record "Sales Invoice Header" temporary;

        companyInfor: Record "Company Information";

        PaymentTerm: Record "Payment Terms";

        ShipMethod: Record "Shipment Method";
        FunctionCenter: Codeunit "NCT Function Center";
        var_RefDocumentDate: Date;
        ExchangeRate: Text[30];
        LineNo: Integer;
        RefDocumentNo, var_RefDocumentNo : Code[50];
        CommentText: Array[99] of Text[250];

        SplitDate: Array[3] of Text[20];



        TotalAmt: Array[100] of Decimal;
        VatText: Text[30];
        AmtText, ReturnReasonDescFirstLine : Text[250];
        ComText: Array[10] of Text[250];
        CustText: Array[10] of Text[250];
        NoOfCopies: Integer;
        CaptionOptionEng, CaptionOptionThai, OriginalCaption : Text[50];
        FromPosted: Boolean;

}
