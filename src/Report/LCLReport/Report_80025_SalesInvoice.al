/// <summary>
/// Report Report Sales Invoice (ID 80025).
/// </summary>
report 80025 "NCT Report Sales Invoice"
{
    Caption = 'Sales Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80025_SalesInvoice.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.";
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
            column(CustTextShipment_1; CustTextShipment[1]) { }
            column(CustTextShipment_2; CustTextShipment[2]) { }
            column(CustTextShipment_3; CustTextShipment[3]) { }
            column(CustTextShipment_4; CustTextShipment[4]) { }
            column(CustTextShipment_5; CustTextShipment[5]) { }
            column(Quote_No_; "Quote No.") { }
            column(ShipMethod_Description; ShipMethod.Description) { }
            column(External_Document_No_; "External Document No.") { }
            column(CaptionOptionThai; CaptionOptionThai) { }
            column(CaptionOptionEng; CaptionOptionEng) { }
            column(VatText; VatText) { }
            dataitem(myLoop; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(Number; Number) { }
                column(OriginalCaption; OriginalCaption) { }
                dataitem(SalesLine; "Sales Line")
                {
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = SalesHeader;
                    column(SalesLine_No_; "No.") { }
                    column(SalesLine_Description; Description) { }
                    column(SalesLine_Description_2; "Description 2") { }
                    column(SalesLine_Unit_Price; "Unit Price") { }
                    column(Line_Discount__; "Line Discount %") { }
                    column(SalesLine_LineNo; LineNo) { }
                    column(SalesLine_Quantity; Quantity) { }
                    column(SalesLine_Unit_of_Measure_Code; "Unit of Measure Code") { }
                    column(Line_Amount; "Line Amount") { }


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
            begin

                if "Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", true);

                FunctionCenter.SalesStatistic("Document Type", "No.", TotalAmt, VatText);
                FunctionCenter.SalesInformation("Document Type", "No.", CustText, 1);
                FunctionCenter.SalesInformation("Document Type", "No.", CustTextShipment, 2);
                if "Currency Code" = '' then
                    AmtText := '(' + FunctionCenter."NumberThaiToText"(TotalAmt[5]) + ')'
                else
                    AmtText := '(' + FunctionCenter."NumberEngToText"(TotalAmt[5], "Currency Code") + ')';

                IF NOT PaymentTerm.GET(SalesHeader."Payment Terms Code") then
                    PaymentTerm.Init();
                IF NOT ShipMethod.Get("Shipment Method Code") then
                    ShipMethod.Init();
                NewDate := DT2Date("NCT Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
            end;
        }


    }
    requestpage
    {
        SaveValues = true;
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

    var
        SplitDate: Array[3] of Text[20];

        companyInfor: Record "Company Information";

        PaymentTerm: Record "Payment Terms";

        ShipMethod: Record "Shipment Method";
        ExchangeRate: Text[30];
        LineNo: Integer;
        CommentText: Array[99] of Text[250];

        FunctionCenter: Codeunit "NCT Function Center";

        TotalAmt: Array[100] of Decimal;
        VatText: Text[30];
        AmtText: Text[250];
        ComText: Array[10] of Text[250];
        CustText, CustTextShipment : Array[10] of Text[250];
        NoOfCopies: Integer;
        CaptionOptionEng, CaptionOptionThai, OriginalCaption : Text[50];

}
