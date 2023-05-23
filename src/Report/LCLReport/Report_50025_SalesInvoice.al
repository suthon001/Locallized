report 50025 "Report Sales Invoice"
{
    Caption = 'Sales Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50025_SalesInvoice.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
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
            column(CreateDocBy; "Create By") { }
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
            dataitem(SalesLine; "Sales Line")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = FIELD("No.");
                column(SalesLine_No_; "No.") { }
                column(SalesLine_Description; Description) { }
                column(SalesLine_Description_2; "Description 2") { }
                column(SalesLine_Unit_Price; "Unit Price") { }
                column(Line_Discount__; "Line Discount %") { }
                column(SalesLine_LineNo; LineNo) { }
                column(SalesLine_Quantity; Quantity) { }
                column(SalesLine_Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }

                dataitem("Reservation Entry"; "Reservation Entry")
                {
                    DataItemTableView = sorting("Entry No.");
                    DataItemLinkReference = SalesLine;
                    DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                    column(LotSeriesNo; LotSeriesNo) { }
                    column(Reservation_Quantity; Quantity) { }
                    column(Reservation_Location_Code; "Location Code") { }
                    column(Expiration_Date; format("Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(LotSeriesCaption; LotSeriesCaption) { }
                    trigger OnAfterGetRecord()
                    begin
                        LotSeriesNo := '';
                        LineLotSeries += 1;
                        if "Lot No." <> '' then begin
                            LotSeriesNo := "Lot No.";
                            LotSeriesCaption := 'Lot No. :';
                        end else begin
                            LotSeriesNo := "Serial No.";
                            LotSeriesCaption := 'Series No. :';
                        end;
                        if LineLotSeries > 1 then
                            LotSeriesCaption := '';
                    end;

                }
                trigger OnAfterGetRecord()
                begin
                    If "No." <> '' then
                        LineNo += 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                NewDate: Date;
            begin
                FunctionCenter.SalesStatistic("Document Type", "No.", TotalAmt, VatText);
                FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", false);
                FunctionCenter.SalesInformation("Document Type", "No.", CustText, 0);
                FunctionCenter.SalesInformation("Document Type", "No.", CustTextShipment, 2);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TotalAmt[5]) + ')';
                IF NOT PaymentTerm.GET(SalesHeader."Payment Terms Code") then
                    PaymentTerm.Init();
                IF NOT ShipMethod.Get("Shipment Method Code") then
                    ShipMethod.Init();
                NewDate := DT2Date("Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
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
                    field(CaptionOptionThai; CaptionOptionThai)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption';
                        ToolTip = 'Specifies the value of the Caption field.';
                        trigger OnValidate()
                        begin
                            CaptionOptionEng := CaptionOptionThai;
                        end;
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
        LotSeriesCaption: Text[50];
        LineLotSeries: Integer;
        SplitDate: Array[3] of Text[20];

        companyInfor: Record "Company Information";

        PaymentTerm: Record "Payment Terms";

        ShipMethod: Record "Shipment Method";
        ExchangeRate: Text[20];
        LineNo: Integer;
        LotSeriesNo: Code[30];
        CommentText: Array[99] of Text[250];

        FunctionCenter: Codeunit "Function Center";

        TotalAmt: Array[100] of Decimal;
        VatText: Text[30];
        AmtText: Text[250];
        ComText: Array[10] of Text[250];
        CustText, CustTextShipment : Array[10] of Text[250];
        CaptionOptionEng: Option INVOICE,"INVOICE/TAX INVOICE";
        CaptionOptionThai: Option ใบแจ้งหนี้,"ใบแจ้งหนี้/ใบกำกับภาษี";

}
