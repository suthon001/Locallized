/// <summary>
/// Report WHT Certificate Preprint (ID 50009).
/// </summary>
report 50009 "WHT Certificate Preprint"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50009_WHTCertificatePreprint.rdl';
    Caption = 'WHT Certificate (Preprint)';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = None;
    dataset
    {
        dataitem("WHT Header"; "WHT Header")
        {
            trigger OnAfterGetRecord()
            var
                Currcount: Integer;
                DigitCount: Integer;
                WHTEntry: Record "WHT Line";
                WHTBus: Record "WHT Business Posting Group";
            begin
                WHTBus.GET("WHT Business Posting Group");
                IF "WHT Type" = "WHT Type"::PND53 THEN
                    PND53 := 'X';
                IF "WHT Type" = "WHT Type"::PND3 THEN
                    PND3 := 'X';
                PVNo := "Gen. Journal Document No.";
                WHTName := WHTBus."Name" + ' ' + WHTBus."Name 2";
                WHTAddress := WHTBus."Address" + ' ' + WHTBus."Address 2";
                WHTRegID2 := WHTBus."VAT Registration No.";
                WHTCerti := "WHT Certificate No.";
                WHTDAte := "WHT Date";
                whtVendorName := "WHT Name" + '  ' + "WHT Name 2";
                whtVendorAddress := "WHT Address" + ' ' + "WHT Address 2" + ' ' + "WHT City" + ' ' + "WHT Post Code";

                Currcount := 0;
                DigitCount := 1;
                REPEAT
                    Currcount += 1;
                    IF COPYSTR(WHTRegID2, Currcount, 1) IN ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] THEN
                        IF DigitCount <= 13 THEN BEGIN
                            WHTRegID[DigitCount] := COPYSTR(WHTRegID2, Currcount, 1);
                            DigitCount += 1;
                        END;
                UNTIL Currcount > STRLEN(WHTRegID2);

                VATRegID2 := "VAT Registration No.";
                Currcount := 0;
                DigitCount := 1;
                REPEAT
                    Currcount += 1;
                    IF COPYSTR(VATRegID2, Currcount, 1) IN ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] THEN
                        IF DigitCount <= 13 THEN BEGIN
                            VATRegID[DigitCount] := COPYSTR(VATRegID2, Currcount, 1);
                            DigitCount += 1;
                        END;
                UNTIL Currcount > STRLEN(VATRegID2);
                IF "WHT Option" = "WHT Option"::"(1) หักภาษี ณ ที่จ่าย" THEN
                    WHTOPtion[1] := 'X'
                ELSE
                    IF "WHT Option" = "WHT Option"::"(2) ออกภาษีให้ตลอดไป" THEN
                        WHTOPtion[2] := 'X'
                    ELSE
                        IF "WHT Option" = "WHT Option"::"(3) ออกภาษีให้ครั้งเดียว" THEN
                            WHTOPtion[3] := 'X'
                        ELSE
                            WHTOPtion[4] := 'X';

                WHTEntry.RESET();
                WHTEntry.SETRANGE("WHT No.", "WHT No.");
                WHTEntry.SETFILTER("WHT Amount", '<>%1', 0);
                IF WHTEntry.FIND('-') THEN
                    REPEAT
                        WHTSumBase += WHTEntry."WHT Base";
                        WHTSumAmt += WHTEntry."WHT Amount";
                        WHTSetup.GET("WHT Business Posting Group", WHTEntry."WHT Product Posting Group");
                        WHTProductPostingGroup.GET(WHTEntry."WHT Product Posting Group");
                        IF WHTProductPostingGroup."Sequence" = 0 THEN BEGIN
                            WHTLineDate[1] := "WHT Date";
                            WHTLineBase[1] := WHTEntry."WHT Base";
                            WHTLineAmt[1] := WHTEntry."WHT Amount";
                        END ELSE
                            IF WHTProductPostingGroup."Sequence" = 1 THEN BEGIN
                                WHTLineDate[2] := "WHT Date";
                                WHTLineBase[2] := WHTEntry."WHT Base";
                                WHTLineAmt[2] := WHTEntry."WHT Amount";
                            END ELSE
                                IF WHTProductPostingGroup."Sequence" = 2 THEN BEGIN
                                    WHTLineDate[3] := "WHT Date";
                                    WHTLineBase[3] := WHTEntry."WHT Base";
                                    WHTLineAmt[3] := WHTEntry."WHT Amount";
                                END ELSE
                                    IF WHTProductPostingGroup."Sequence" = 3 THEN BEGIN
                                        WHTLineDate[4] := "WHT Date";
                                        WHTLineBase[4] := WHTEntry."WHT Base";
                                        WHTLineAmt[4] := WHTEntry."WHT Amount";
                                    END ELSE
                                        IF WHTProductPostingGroup."Sequence" = 4 THEN BEGIN
                                            WHTLineDate[41] := "WHT Date";
                                            WHTLineBase[41] := WHTEntry."WHT Base";
                                            WHTLineAmt[41] := WHTEntry."WHT Amount";
                                        END ELSE
                                            IF WHTProductPostingGroup."Sequence" = 5 THEN BEGIN
                                                WHTLineDate[42] := "WHT Date";
                                                WHTLineBase[42] := WHTEntry."WHT Base";
                                                WHTLineAmt[42] := WHTEntry."WHT Amount";
                                            END ELSE
                                                IF WHTProductPostingGroup."Sequence" = 6 THEN BEGIN
                                                    WHTLineDate[43] := "WHT Date";
                                                    WHTLineBase[43] := WHTEntry."WHT Base";
                                                    WHTLineAmt[43] := WHTEntry."WHT Amount";
                                                END ELSE
                                                    IF WHTProductPostingGroup."Sequence" = 7 THEN BEGIN
                                                        WHTLineDate[44] := "WHT Date";
                                                        WHTLineBase[44] := WHTEntry."WHT Base";
                                                        WHTLineAmt[44] := WHTEntry."WHT Amount";
                                                        //WHT44Percent := WHTSetup."WHT City";
                                                    END ELSE
                                                        IF WHTProductPostingGroup."Sequence" = 8 THEN BEGIN
                                                            WHTLineDate[45] := "WHT Date";
                                                            WHTLineBase[45] := WHTEntry."WHT Base";
                                                            WHTLineAmt[45] := WHTEntry."WHT Amount";
                                                        END ELSE
                                                            IF WHTProductPostingGroup."Sequence" = 9 THEN BEGIN
                                                                WHTLineDate[46] := "WHT Date";
                                                                WHTLineBase[46] := WHTEntry."WHT Base";
                                                                WHTLineAmt[46] := WHTEntry."WHT Amount";
                                                            END ELSE
                                                                IF WHTProductPostingGroup."Sequence" = 10 THEN BEGIN
                                                                    WHTLineDate[47] := "WHT Date";
                                                                    WHTLineBase[47] := WHTEntry."WHT Base";
                                                                    WHTLineAmt[47] := WHTEntry."WHT Amount";
                                                                END ELSE
                                                                    IF WHTProductPostingGroup."Sequence" = 11 THEN BEGIN
                                                                        WHTLineDate[48] := "WHT Date";
                                                                        WHTLineBase[48] := WHTEntry."WHT Base";
                                                                        WHTLineAmt[48] := WHTEntry."WHT Amount";
                                                                    END ELSE
                                                                        IF WHTProductPostingGroup."Sequence" = 12 THEN BEGIN
                                                                            WHTLineDate[49] := "WHT Date";
                                                                            WHTLineBase[49] := WHTEntry."WHT Base";
                                                                            WHTLineAmt[49] := WHTEntry."WHT Amount";
                                                                            WHT4Description := WHTProductPostingGroup."Description";
                                                                        END ELSE
                                                                            IF WHTProductPostingGroup."Sequence" = 13 THEN BEGIN
                                                                                IF WHTLineBase[51] = 0 THEN BEGIN
                                                                                    WHTLineDate[51] := "WHT Date";
                                                                                    WHTLineBase[51] := WHTEntry."WHT Base";
                                                                                    WHTLineAmt[51] := WHTEntry."WHT Amount";
                                                                                    WHT5Description := WHTProductPostingGroup."Description";
                                                                                END ELSE
                                                                                    IF WHTLineBase[52] = 0 THEN BEGIN
                                                                                        WHTLineDate[52] := "WHT Date";
                                                                                        WHTLineBase[52] := WHTEntry."WHT Base";
                                                                                        WHTLineAmt[52] := WHTEntry."WHT Amount";
                                                                                        WHT52Description := WHTProductPostingGroup."Description";
                                                                                    END ELSE
                                                                                        IF WHTLineBase[53] = 0 THEN BEGIN
                                                                                            WHTLineDate[53] := "WHT Date";
                                                                                            WHTLineBase[53] := WHTEntry."WHT Base";
                                                                                            WHTLineAmt[53] := WHTEntry."WHT Amount";
                                                                                            WHT53Description := WHTProductPostingGroup."Description";
                                                                                        END;
                                                                            END ELSE
                                                                                IF WHTProductPostingGroup."Sequence" = 14 THEN BEGIN
                                                                                    WHTLineDate[6] := "WHT Date";
                                                                                    WHTLineBase[6] := WHTEntry."WHT Base";
                                                                                    WHTLineAmt[6] := WHTEntry."WHT Amount";
                                                                                    WHT6Description := WHTProductPostingGroup."Description";
                                                                                END;
                    UNTIL WHTEntry.NEXT() = 0;

            end;
        }
        dataitem(Integer; integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = FILTER(1 ..));
            column(PVNo; PVNo) { }
            column(WHTName; WHTName) { }
            column(WHTAddress; WHTAddress) { }
            column(WHTDocumentNo; WHTCerti) { }
            column(WHTDocumentDate; FORMAT(WHTDAte, 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(PND3; PND3) { }
            column(PND53; PND53) { }
            column(WHTRegID1; WHTRegID[1]) { }
            column(WHTRegID2; WHTRegID[2]) { }
            column(WHTRegID3; WHTRegID[3]) { }
            column(WHTRegID4; WHTRegID[4]) { }
            column(WHTRegID5; WHTRegID[5]) { }
            column(WHTRegID6; WHTRegID[6]) { }
            column(WHTRegID7; WHTRegID[7]) { }
            column(WHTRegID8; WHTRegID[8]) { }
            column(WHTRegID9; WHTRegID[9]) { }
            column(WHTRegID10; WHTRegID[10]) { }
            column(WHTRegID11; WHTRegID[11]) { }
            column(WHTRegID12; WHTRegID[12]) { }
            column(WHTRegID13; WHTRegID[13]) { }
            column(VendName; whtVendorName) { }
            column(VendAddress; whtVendorAddress) { }
            column(VATRegID1; VATRegID[1]) { }
            column(VATRegID2; VATRegID[2]) { }
            column(VATRegID3; VATRegID[3]) { }
            column(VATRegID4; VATRegID[4]) { }
            column(VATRegID5; VATRegID[5]) { }
            column(VATRegID6; VATRegID[6]) { }
            column(VATRegID7; VATRegID[7]) { }
            column(VATRegID8; VATRegID[8]) { }
            column(VATRegID9; VATRegID[9]) { }
            column(VATRegID10; VATRegID[10]) { }
            column(VATRegID11; VATRegID[11]) { }
            column(VATRegID12; VATRegID[12]) { }
            column(VATRegID13; VATRegID[13]) { }
            column(WHTLineDate1; FORMAT(WHTLineDate[1], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate2; FORMAT(WHTLineDate[2], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate3; FORMAT(WHTLineDate[3], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate4; FORMAT(WHTLineDate[4], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate41; FORMAT(WHTLineDate[41], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate42; FORMAT(WHTLineDate[42], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate43; FORMAT(WHTLineDate[43], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate44; FORMAT(WHTLineDate[44], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate45; FORMAT(WHTLineDate[45], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate46; FORMAT(WHTLineDate[46], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate47; FORMAT(WHTLineDate[47], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate48; FORMAT(WHTLineDate[48], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate49; FORMAT(WHTLineDate[49], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate51; FORMAT(WHTLineDate[51], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate52; FORMAT(WHTLineDate[52], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate53; FORMAT(WHTLineDate[53], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHTLineDate6; FORMAT(WHTLineDate[6], 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(WHT4Description; WHT4Description) { }
            column(WHT5Description; WHT5Description) { }
            column(WHT52Description; WHT52Description) { }
            column(WHT53Description; WHT53Description) { }
            column(WHT6Description; WHT6Description) { }
            column(WHTLineBase1; WHTLineBase[1]) { }
            column(WHTLineBase2; WHTLineBase[2]) { }
            column(WHTLineBase3; WHTLineBase[3]) { }
            column(WHTLineBase4; WHTLineBase[4]) { }
            column(WHTLineBase41; WHTLineBase[41]) { }
            column(WHTLineBase42; WHTLineBase[42]) { }
            column(WHTLineBase43; WHTLineBase[43]) { }
            column(WHTLineBase44; WHTLineBase[44]) { }
            column(WHTLineBase45; WHTLineBase[45]) { }
            column(WHTLineBase46; WHTLineBase[46]) { }
            column(WHTLineBase47; WHTLineBase[47]) { }
            column(WHTLineBase48; WHTLineBase[48]) { }
            column(WHTLineBase49; WHTLineBase[49]) { }
            column(WHTLineBase51; WHTLineBase[51]) { }
            column(WHTLineBase52; WHTLineBase[52]) { }
            column(WHTLineBase53; WHTLineBase[53]) { }
            column(WHTLineBase6; WHTLineBase[6]) { }
            column(WHTLineAmt1; WHTLineAmt[1]) { }
            column(WHTLineAmt2; WHTLineAmt[2]) { }
            column(WHTLineAmt3; WHTLineAmt[3]) { }
            column(WHTLineAmt4; WHTLineAmt[4]) { }
            column(WHTLineAmt41; WHTLineAmt[41]) { }
            column(WHTLineAmt42; WHTLineAmt[42]) { }
            column(WHTLineAmt43; WHTLineAmt[43]) { }
            column(WHTLineAmt44; WHTLineAmt[44]) { }
            column(WHTLineAmt45; WHTLineAmt[45]) { }
            column(WHTLineAmt46; WHTLineAmt[46]) { }
            column(WHTLineAmt47; WHTLineAmt[47]) { }
            column(WHTLineAmt48; WHTLineAmt[48]) { }
            column(WHTLineAmt49; WHTLineAmt[49]) { }
            column(WHTLineAmt51; WHTLineAmt[51]) { }
            column(WHTLineAmt52; WHTLineAmt[52]) { }
            column(WHTLineAmt53; WHTLineAmt[53]) { }
            column(WHTLineAmt6; WHTLineAmt[6]) { }
            column(WHTPercent44; WHT44Percent) { }
            column(WHTSumBase; WHTSumBase) { }
            column(WHTSumAmt; WHTSumAmt) { }
            column(WHTAmtText; LocalFunction."NumberThaiToText"(WHTSumAmt)) { }
            column(WHTDay; DATE2DMY(WHTDAte, 1)) { }
            column(WHTMonth; LocalFunction."Get ThaiMonth"(DATE2DMY(WHTDAte, 2))) { }
            column(WHTYear; DATE2DMY(WHTDAte, 3)) { }
            column(WHTOption1; WHTOPtion[1]) { }
            column(WHTOption2; WHTOPtion[2]) { }
            column(WHTOption3; WHTOPtion[3]) { }
            column(WHTOption4; WHTOPtion[4]) { }
            column(WHTHeaderText; WHTHeaderText[1]) { }
            column(numberofcopies; Number) { }
            trigger OnPreDataItem()

            begin
                generaledgersetup.get();
                // generaledgersetup.TestField("No. of Copy WHT Cert.");
                SetFilter(Number, '%1..%2', 1, 1);
            end;

            trigger OnAfterGetRecord()
            begin
                case Number of
                    1:
                        WHTHeaderText[1] := generaledgersetup."WHT Certificate Caption 1";
                    2:
                        WHTHeaderText[1] := generaledgersetup."WHT Certificate Caption 2";
                    3:
                        WHTHeaderText[1] := generaledgersetup."WHT Certificate Caption 3";
                    4:
                        WHTHeaderText[1] := generaledgersetup."WHT Certificate Caption 4";
                end;
            end;
        }

    }
    var
        WHTSetup: Record "WHT Posting Setup";
        WHTRegID: array[13] of Code[10];
        VATRegID: array[13] of Code[10];
        PND3: Code[10];
        PND53: Code[10];
        WHTRegID2: Code[20];
        VATRegID2: Code[20];
        WHTLineDate: array[100] of date;
        WHTLineBase: array[100] of Decimal;
        WHTLineAmt: array[100] of Decimal;
        WHTSumBase: Decimal;
        WHTSumAmt: Decimal;
        WHT4Description: Text[100];
        WHT5Description: Text[100];
        WHT52Description: Text[250];
        WHT53Description: Text[250];
        WHT6Description: Text[250];
        WHT44Percent: Decimal;
        WHTOPtion: array[4] of Code[10];
        WHTName: Text[250];
        WHTAddress: Text[250];
        WHTCerti: Text[250];
        whtVendorName: Text[250];
        whtVendorAddress: Text[1024];
        WHTDAte: date;
        generaledgersetup: Record "General Ledger Setup";
        WHTHeaderText: array[4] of Text[1024];
        WHTProductPostingGroup: Record "WHT Product Posting Group";
        LocalFunction: Codeunit "Function Center";
        PVNo: Code[30];
}