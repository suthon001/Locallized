report 50050 "Receipt Ducument"
{
    Caption = 'Report Receipt Ducument';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50050_ReciepDocument.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = where(Amount = FILTER(< 0));
            column(Posting_Date; format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; "Document No.") { }
            column(Description; Description) { }
            column(Amount; Amount) { }
            column(VAT_Bus__Posting_Group; "VAT Bus. Posting Group") { }
            column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(ComInfo_Picture; RecComInfo.Picture) { }
            column(CustVend_1; CustVend[1]) { }
            column(CustVend_2; CustVend[2]) { }
            column(CustVend_3; CustVend[3]) { }
            column(CustVend_4; CustVend[4]) { }
            column(CustVend_5; CustVend[5]) { }
            column(CustVend_9; CustVend[9]) { }
            column(CustVend_10; CustVend[10]) { }
            column(HeadThai; HeadThai) { }
            column(HeadEng; HeadEng) { }
            column(ExchangeRate; ExchangeRate) { }
            column(varTotal; varTotal) { }
            column(varGandtotal; varGandtotal) { }
            column(varVat; varVat) { }
            column(Line_No; LineNo) { }
            column(SumTotalAmountText; SumTotalAmountText) { }
            column(CurrencyCode; ExchangeRate) { }

            trigger OnPreDataItem()
            begin
                RecComInfo.get();
                RecComInfo.CalcFields(Picture);
                // หา Vat Business
                Clear(VatBusinessPostingGroup);
                GenJournalLine.Reset();
                GenJournalLine.SetFilter("Document No.", '%1', "Gen. Journal Line".GetFilter("Document No."));
                GenJournalLine.SetFilter("VAT Bus. Posting Group", '<>%1', '');
                if GenJournalLine.FindFirst() then
                    VatBusinessPostingGroup := GenJournalLine."VAT Bus. Posting Group";

                if VatBusinessPostingGroup = '' then
                    CUFunction."CompanyInformation"(ComText, false)
                else
                    CUFunction."CompanyinformationByVat"(ComText, VatBusinessPostingGroup, false);

                if VatBusinessPostingGroup = '' then
                    CUFunction."CompanyInformation"(ComText, false)
                else
                    CUFunction."CompanyinformationByVat"(ComText, VatBusinessPostingGroup, false);


                Clear(CustVend);

                GenJournalLine.Reset();
                GenJournalLine.SetFilter("Document No.", '%1', "Gen. Journal Line".GetFilter("Document No."));
                GenJournalLine.SetFilter("Journal Batch Name", '%1', "Gen. Journal Line".GetFilter("Journal Batch Name"));
                GenJournalLine.SetFilter("Journal Template Name", '%1', "Gen. Journal Line".GetFilter("Journal Template Name"));
                GenJournalLine.SetRange("Account Type", "Account Type"::Customer);
                if GenJournalLine.FindFirst() then
                    CUFunction."CusInfo"(GenJournalLine."Account No.", CustVend)
                else begin
                    GenJournalLine.Reset();
                    GenJournalLine.SetFilter("Document No.", '%1', "Gen. Journal Line".GetFilter("Document No."));
                    GenJournalLine.SetFilter("Journal Batch Name", '%1', "Gen. Journal Line".GetFilter("Journal Batch Name"));
                    GenJournalLine.SetFilter("Journal Template Name", '%1', "Gen. Journal Line".GetFilter("Journal Template Name"));
                    GenJournalLine.SetFilter("Pay Name", '<>%1', '');
                    if GenJournalLine.FindFirst() then
                        CustVend[1] := GenJournalLine."Pay Name";
                end;


                GenJournalLine.Reset();
                GenJournalLine.SetFilter("Document No.", '%1', "Gen. Journal Line".GetFilter("Document No."));
                GenJournalLine.SetFilter("Journal Batch Name", '%1', "Gen. Journal Line".GetFilter("Journal Batch Name"));
                GenJournalLine.SetFilter("Journal Template Name", '%1', "Gen. Journal Line".GetFilter("Journal Template Name"));
                GenJournalLine.SetFilter(Amount, '<%1', 0);
                if GenJournalLine.FindFirst() then
                    repeat
                        varTotal += GenJournalLine."VAT Base Amount" * -1;
                        varGandtotal += GenJournalLine.Amount * -1;
                        varVat := varGandtotal - varTotal;
                    until GenJournalLine.next() = 0;
                SumTotalAmountText := CUFunction."NumberThaiToText"(varGandtotal);




                CUFunction."ConvExchRate"("Currency Code", "Currency Factor", ExchangeRate);

                CurrencyCode := "Currency Code";
                if CurrencyCode = '' then
                    CurrencyCode := 'THB';

                if CurrencyCode = 'THB' then
                    SumTotalAmountText := CUFunction."NumberThaiToText"(varGandtotal)
                else
                    SumTotalAmountText := CUFunction."NumberEngToText"(varGandtotal, CurrencyCode);

            end;

            trigger OnAfterGetRecord()
            begin

                LineNo += 1;
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
                    field(HeadThai; HeadThai)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption';
                        ToolTip = 'Specifies the value of the Caption field.';
                        trigger OnValidate()
                        begin
                            HeadEng := HeadThai;
                        end;
                    }
                }
            }
        }


    }

    var
        CUFunction: Codeunit "Function Center";
        ComText: array[10] of Text[250];
        CustVend: array[10] of Text[250];
        VatBusinessPostingGroup: code[20];
        RecComInfo: Record "Company Information";
        GenJournalLine: Record "Gen. Journal Line";
        ExchangeRate: text[20];
        varTotal: Decimal;
        varVat: Decimal;
        varGandtotal: Decimal;
        LineNo: Integer;
        SumTotalAmountText: Text[250];
        CurrencyCode: Code[20];
        HeadEng: Option "RECEIPT","RECEIPT/TAX INVOICE";
        HeadThai: Option ใบเสร็จรับเงิน,"ใบเสร็จรับเงิน/ใบกำกับภาษี";
}