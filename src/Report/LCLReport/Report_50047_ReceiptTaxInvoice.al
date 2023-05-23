report 50047 "Receipt Tax Invoice"
{
    Caption = 'Receipt Tax Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50047_ReceiptTaxInvoice.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            column(LineNo; LineNo) { }
            column(CustLedg_DocumentNo; "Document No.") { }
            column(CustLedg_Description; Description) { }
            column(wCustLedg_AmounttoApply; "Amount to Apply") { }
            column(SumTotalAmount; SumTotalAmount) { }
            column(SumTotalAmountText; SumTotalAmountText) { }
            column(SalesInvHeader_PostingDate; format(PostingDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(SalesInvoiceHeader_DueDate; format(DueDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(SalesInvoiceHeader_PaymentTerms; RecPaymentTerms.Description) { }
            column(SalesPerson_Name; RecSalesPerson.Name) { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(ComText_7; ComText[7]) { }
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(CustText_1; CustText[1]) { }
            column(CustText_2; CustText[2]) { }
            column(CustText_3; CustText[3]) { }
            column(CustText_4; CustText[4]) { }
            column(CustText_5; CustText[5]) { }
            column(CustText_6; CustText[6]) { }
            column(CustText_9; CustText[9]) { }
            column(CustText_10; CustText[10]) { }
            column(GrandTotalAmt1; GrandTotalAmt[1]) { }
            column(GrandTotalAmt2; GrandTotalAmt[2]) { }
            column(GrandTotalAmt3; GrandTotalAmt[3]) { }
            column(GrandTotalAmt4; GrandTotalAmt[4]) { }
            column(GrandTotalAmt5; GrandTotalAmt[5]) { }

            dataitem(TempSalesLine; "Sales Line")
            {
                DataItemLink = "DOcument No." = field("Document No.");
                DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.");
                UseTemporary = true;
                column(Line_No_; "Line No.") { }
                column(No_; "No.") { }
                column(Document_No_; "Document No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Discount__; "Line Discount %") { }
                column(Location_Code; "Location Code") { }
                column(Line_Amount; "Line Amount") { }
                column(Unit_Price; "Unit Price") { }
                trigger OnAfterGetRecord()
                begin
                    if "Document Type" = "Document Type" then
                        "Line Amount" := -"Line Amount";
                end;
            }


            trigger OnPreDataItem()
            begin
                CLEAR(GrandTotalAmt);
                companyInfor.get();
                companyInfor.CalcFields(Picture);
                Clear(RecCustLedgEntry);
                RecCustLedgEntry.CopyFilters(CustLedgerEntry);
                if RecCustLedgEntry.FindSet() then
                    repeat
                        InsertDetailReceipt(RecCustLedgEntry."Document No.");
                    until RecCustLedgEntry.next() = 0;
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(ComText);
                CUFunction."CusInfo"("Customer No.", CustText);
                if RecSalesInvoiceHeader."VAT Bus. Posting Group" = '' then
                    CUFunction."CompanyInformation"(ComText, false)
                else
                    CUFunction."CompanyinformationByVat"(ComText, RecSalesInvoiceHeader."VAT Bus. Posting Group", false);
                IF RecSalesInvoiceHeader.GET(CustLedgerEntry."Document No.") then begin
                    SalesPersonCode := RecSalesInvoiceHeader."Salesperson Code";
                    DueDate := RecSalesInvoiceHeader."Due Date";
                    PaymentTerm := RecSalesInvoiceHeader."Payment Terms Code";
                    PostingDate := RecSalesInvoiceHeader."Posting Date";
                end;

                if not RecSalesPerson.Get(SalesPersonCode) then
                    RecSalesPerson.init();

                if not RecPaymentTerms.Get(PaymentTerm) then
                    RecPaymentTerms.init();



                CurrencyCode := "Currency Code";
                if CurrencyCode = '' then
                    CurrencyCode := 'THB';

                if CurrencyCode = 'THB' then
                    SumTotalAmountText := CUFunction."NumberThaiToText"(GrandTotalAmt[5])
                else
                    SumTotalAmountText := CUFunction."NumberEngToText"(GrandTotalAmt[5], CurrencyCode);

                LineNo += 1;


            end;
        }
    }
    procedure InsertDetailReceipt(DocNo: Code[30])
    var
        salesInvoiceLine: Record "Sales Invoice Line";
        SalesCreditMemoLine: record "Sales Cr.Memo Line";
        EntryNo: Integer;
        TempVat: Record "VAT Amount Line" temporary;
    begin
        CLEAR(TotalAmt);
        if NOT TempSalesLine.IsTemporary then
            ERROR('Table must be Tempolary');

        salesInvoiceLine.reset();
        salesInvoiceLine.SetRange("Document No.", DocNo);
        salesInvoiceLine.SetFilter("No.", '<>%1', '');
        if salesInvoiceLine.FindFirst() then begin
            CUFunction."SalesInvoiceStatistics"(salesInvoiceLine."Document No.", TotalAmt, TempVat);
            GrandTotalAmt[1] += TotalAmt[1];
            GrandTotalAmt[2] += TotalAmt[2];
            GrandTotalAmt[3] += TotalAmt[3];
            GrandTotalAmt[4] += TotalAmt[4];
            GrandTotalAmt[5] += TotalAmt[5];
            repeat
                EntryNo += 1;
                TempSalesLine.init();
                TempSalesLine."Document Type" := TempSalesLine."Document Type"::Invoice;
                TempSalesLine.TransferFields(salesInvoiceLine);
                TempSalesLine."Line No." := EntryNo;
                TempSalesLine.Insert();
            until salesInvoiceLine.next() = 0;
        end;
        SalesCreditMemoLine.reset();
        SalesCreditMemoLine.SetRange("Document No.", DocNo);
        SalesCreditMemoLine.SetFilter("No.", '<>%1', '');
        if SalesCreditMemoLine.FindFirst() then begin
            CUFunction."SalesCrMemoStatistics"(SalesCreditMemoLine."Document No.", TotalAmt, TempVat);
            GrandTotalAmt[1] += (TotalAmt[1]) * -1;
            GrandTotalAmt[2] += (TotalAmt[2]) * -1;
            GrandTotalAmt[3] += (TotalAmt[3]) * -1;
            GrandTotalAmt[4] += (TotalAmt[4]) * -1;
            GrandTotalAmt[5] += (TotalAmt[5]) * -1;
            repeat
                EntryNo += 1;
                TempSalesLine.init();
                TempSalesLine."Document Type" := TempSalesLine."Document Type"::"Credit Memo";
                TempSalesLine.TransferFields(SalesCreditMemoLine);
                TempSalesLine."Line No." := EntryNo;
                TempSalesLine.Insert();
            until SalesCreditMemoLine.next() = 0;
        end;
        TempSalesLine.reset();
    end;

    var
        ComText: array[100] of Text[250];
        CustText: array[10] of Text[250];
        companyInfor: Record "Company Information";
        CUFunction: Codeunit "Function Center";

        RecCustLedgEntry: Record "Cust. Ledger Entry";
        SumTotalAmount: Decimal;
        SumTotalAmountText: Text[250];
        PostingDate: Date;
        RecSalesInvoiceHeader: Record "Sales Invoice Header";
        SalesPersonCode: Code[20];
        RecSalesPerson: Record "Salesperson/Purchaser";
        DueDate: Date;
        PaymentTerm: Text[100];
        RecPaymentTerms: Record "Payment Terms";
        LineNo: Integer;
        TotalAmt: array[100] of Decimal;
        GrandTotalAmt: array[100] of Decimal;
        CurrencyCode: code[20];


}
