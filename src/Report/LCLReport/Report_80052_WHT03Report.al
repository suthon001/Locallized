/// <summary>
/// Report NCT WHT03 Report (ID 80099).
/// </summary>
report 80052 "NCT WHT03 Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80052_WHT03.rdl';
    Caption = 'WHT 03';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Tax Report Header"; "NCT Tax & WHT Header")
        {
            column(ShowTitle; ShowTitle) { }
            column(MonthTxt; MonTxt) { }
            column(YearTxt; YearTxt) { }
            column(VATBusName; VATBusName) { }
            column(VATBusTaxID; VATBusID) { }
            column(VATBranch; VATBranch) { }
            column(VATBranchID; VATBranchID) { }
            column(VATHO; VATHO) { }
            column(Month_SubmitVATEntry; "Month No.") { }
            column(Year_SubmitVATEntry; "Year No.") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(RowsPerPage; RowsPerPage) { }
            dataitem("WHT Transaction"; "NCT Tax & WHT Line")
            {
                DataItemTableView = sorting("Tax Type", "Document No.", "Entry No.");
                DataItemLink = "Tax Type" = FIELD("Tax Type"),
                               "Document No." = FIELD("Document No.");
                UseTemporary = true;
                column(WHTDate; FORMAT(YearTxtLine)) { }
                column(WHTNo; "WHT Certificate No.") { }
                column(WHTName; format("Title Name") + ' ' + Name) { }
                column(WHTAddress; Address) { }
                column(WHTAddress2; "Address 2") { }
                column(WHTAddress3; '') { }
                column(WHTID; "VAT Registration No.") { }
                column(WHTHO; LineVATHO) { }
                column(WHTBranch; WHTBranch) { }
                column(WHTBase1; WHTBase[1]) { }
                column(WHTBase2; WHTBase[2]) { }
                column(WHTBase3; WHTBase[3]) { }
                column(WHTAmt1; WHTAmount[1]) { }
                column(WHTAmt2; WHTAmount[2]) { }
                column(WHTAmt3; WHTAmount[3]) { }
                column(WHTPer1; WhtPer[1]) { }
                column(WHTPer2; WhtPer[2]) { }
                column(WHTPer3; WhtPer[3]) { }
                column(WHTDesc1; WHTDesc[1]) { }
                column(WHTDesc2; WHTDesc[2]) { }
                column(WHTDesc3; WHTDesc[3]) { }
                column(WHTOption; format("Tax Report Header"."Vat Option")) { }
                column(ShowLineNo; LineNo) { }
                column(BaseAmtPerPage; BaseAmtPerPage) { }
                column(TaxAmtPerPage; TaxAmtPerPage) { }
                column(PageNo; PageNo) { }
                column(TotalBaseAmt; TotalBaseAmt) { }
                column(TotalTaxAmt; TotalTaxAmt) { }
                trigger OnAfterGetRecord()
                var
                    WHTEntry: Record "NCT Tax & WHT Line";
                    CurrInt: Integer;
                    WHTSetup: Record "NCT WHT Product Posting Group";
                    SumValue: Boolean;
                begin

                    //TPP.SSI 2022/03/29++
                    Clear(YearTxtLine);
                    // IF Date2DMY("WHT Date", 3) < 2500 THEN
                    //     YearTxtLine := STRSUBSTNO('%1', CalcDate('+543Y', "WHT Date"))
                    // ELSE
                    YearTxtLine := STRSUBSTNO('%1', "Posting Date");
                    //TPP.SSI 2022/03/29--


                    IF CurrDocNo = '' THEN BEGIN
                        CurrDocNo := "WHT Certificate No.";
                        LineNo += 1;
                        SumValue := TRUE;
                    END
                    ELSE
                        IF CurrDocNo <> "WHT Certificate No." THEN BEGIN
                            IF (LineNo > 0) AND (CurrDocNo <> '') AND (LineNo MOD RowsPerPage = 0) THEN BEGIN
                                CLEAR(BaseAmtPerPage);
                                CLEAR(TaxAmtPerPage);
                                PageNo += 1;
                            END;
                            CurrDocNo := "WHT Certificate No.";
                            LineNo += 1;
                            SumValue := TRUE;
                        END;

                    if "Head Office" then
                        WHTBranch := '00000'
                    else
                        WHTBranch := "VAT Branch Code";
                    CLEAR(WHTBase);
                    CLEAR(WHTAmount);
                    CLEAR(WhtPer);
                    CLEAR(WHTDesc);
                    CurrInt := 1;
                    WHTEntry.RESET();
                    WHTEntry.SETRANGE("Tax Type", "Tax Type");
                    WHTEntry.SetRange("Document No.", "Document No.");
                    WHTEntry.SetRange("WHT Document No.", "WHT Document No.");
                    WHTEntry.SETFILTER("VAT Amount", '<>%1', 0);
                    IF WHTEntry.FindSet() THEN
                        REPEAT
                            IF CurrInt = 1 THEN BEGIN
                                WHTBase[1] := WHTEntry."Base Amount";
                                WHTAmount[1] := WHTEntry."VAT Amount";
                                WhtPer[1] := WHTEntry."WHT %";
                                IF WHTSetup.GET(WHTEntry."WHT Product Posting Group") THEN
                                    WHTDesc[1] := WHTSetup.Description;
                            END ELSE
                                IF CurrInt = 2 THEN BEGIN
                                    WHTBase[2] := WHTEntry."Base Amount";
                                    WHTAmount[2] := WHTEntry."VAT Amount";
                                    WhtPer[2] := WHTEntry."WHT %";
                                    IF WHTSetup.GET(WHTEntry."WHT Product Posting Group") THEN
                                        WHTDesc[2] := WHTSetup.Description;
                                END ELSE
                                    IF CurrInt = 3 THEN BEGIN
                                        WHTBase[3] := WHTEntry."Base Amount";
                                        WHTAmount[3] := WHTEntry."VAT Amount";
                                        WhtPer[3] := WHTEntry."WHT %";
                                        IF WHTSetup.GET(WHTEntry."WHT Product Posting Group") THEN
                                            WHTDesc[3] := WHTSetup.Description;
                                    END;
                            IF SumValue THEN BEGIN
                                BaseAmtPerPage += WHTEntry."Base Amount";
                                TaxAmtPerPage += WHTEntry."VAT Amount";
                                TotalBaseAmt += WHTEntry."Base Amount";
                                TotalTaxAmt += WHTEntry."VAT Amount";
                            END;
                            CurrInt += 1;
                        UNTIL WHTEntry.NEXT() = 0;
                end;

            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.GET();
                CompanyInfo.CALCFIELDS(Picture);
                RowsPerPage := 5;
                PageNo := 1;
            end;

            trigger OnAfterGetRecord()
            var
                WHTSetup: Record "NCT WHT Business Posting Group";
            begin
                WHTSetup.reset();
                WHTSetup.SetRange("WHT Certificate Option", WHTSetup."WHT Certificate Option"::"ภ.ง.ด.3");
                if WHTSetup.FindFirst() then begin
                    // IF "WHT Bus. Posting Group" = 'WHT53' THEN
                    //     ShowTitle := 'ใบแนบ ภงด.53'
                    // ELSE
                    //     IF "WHT Bus. Posting Group" = 'WHT03' THEN
                    //         ShowTitle := 'ใบแนบ ภงด.3'
                    //     ELSE
                    //         IF "WHT Bus. Posting Group" = 'WHT02' THEN
                    //             ShowTitle := 'ใบแนบ ภงด.2';
                    //TPP.SSI 2022/03/09++
                    ShowTitle := 'ใบแนบ ภงด.3';
                    VATBusID := WHTSetup."VAT Registration No.";
                    if WHTSetup."Head Office" then
                        VATBranchID := '00000'
                    else
                        VATBranchID := WHTSetup."VAT Branch Code";
                    MonTxt := LocalFunction."Get ThaiMonth"("Month No." + 1);
                    // IF "Year" < 2500 THEN
                    //     YearTxt := STRSUBSTNO('%1', "Year" + 543)
                    // ELSE
                    YearTxt := STRSUBSTNO('%1', "Year No.");

                    LineNo := 0;
                    TaxReportLineFind.RESET();
                    TaxReportLineFind.SetCurrentKey("Tax Type", "Document No.", "Entry No.");
                    TaxReportLineFind.SETFILTER("Tax Type", '%1', "Tax Type");
                    TaxReportLineFind.SETFILTER("Document No.", '%1', "Document No.");
                    if TaxReportLineFind.FindSet() then
                        repeat
                            "WHT Transaction".reset();
                            "WHT Transaction".SetRange("Tax Type", TaxReportLineFind."Tax Type");
                            "WHT Transaction".SetRange("Document No.", TaxReportLineFind."Document No.");
                            "WHT Transaction".SetFilter("WHT Document No.", TaxReportLineFind."WHT Document No.");
                            if not "WHT Transaction".FindFirst() then begin
                                "WHT Transaction".Init();
                                "WHT Transaction".TransferFields(TaxReportLineFind);
                                "WHT Transaction".insert();
                            end;
                        until TaxReportLineFind.Next() = 0;
                    "WHT Transaction".reset();
                end;
            end;
        }
    }
    var
        TaxReportLineFind: Record "NCT Tax & WHT Line";
        LocalFunction: Codeunit "NCT Function Center";
        MonTxt: Text[250];
        YearTxt: Text[250];
        YearTxtLine: Text;
        VATBusName: Text[100];
        VATBusID: Code[250];
        VATBranchID: Code[250];
        VATHO: Code[20];
        VATBranch: Code[20];
        LineVATHO: Code[20];
        ShowTitle: Text[250];
        WHTBase: array[100] of DeCimal;
        WHTAmount: array[100] of decimal;
        WhtPer: array[100] of Decimal;
        WHTDesc: array[100] of Text[250];
        LineNo: Integer;
        CurrDocNo: Code[20];
        CompanyInfo: Record "Company Information";
        BaseAmtPerPage: Decimal;
        TaxAmtPerPage: Decimal;
        TotalBaseAmt: Decimal;
        TotalTaxAmt: Decimal;
        RowsPerPage: Integer;
        PageNo: Integer;
        WHTBranch: Code[5];

}