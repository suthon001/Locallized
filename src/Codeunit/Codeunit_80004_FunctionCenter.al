/// <summary>
/// Codeunit NCT Function Center (ID 80004).
/// </summary>
codeunit 80004 "NCT Function Center"
{

    Permissions = tabledata "G/L Entry" = rimd, tabledata "Purch. Rcpt. Line" = imd, tabledata "Return Shipment Line" = imd, tabledata "Sales Shipment Line" = imd;


    procedure GetUserNameFormSystemGUID(pGUID: Guid): code[50]
    var
        User: Record User;
    begin
        if not User.GET(pGUID) then
            User.Init();
        exit(user."User Name");
    end;
    /// <summary>
    /// GetGlobalDimCaption.
    /// </summary>
    /// <param name="DimCaptionThai1">VAR text.</param>
    /// <param name="DimCaptionEng1">VAR text.</param>
    /// <param name="DimCaptionThai2">VAR text.</param>
    /// <param name="DimCaptionEng2">VAR text.</param>
    procedure GetGlobalDimCaption(var DimCaptionThai1: text; var DimCaptionEng1: text; var DimCaptionThai2: text; var DimCaptionEng2: text)
    var
        GeneralSetup: Record "General Ledger Setup";
        ltDimension: Record Dimension;
    begin

        GeneralSetup.GET();
        if not ltDimension.GET(GeneralSetup."Global Dimension 1 Code") then
            ltDimension.Init();
        DimCaptionEng1 := ltDimension.Description;
        DimCaptionThai1 := ltDimension."Thai Description";

        if not ltDimension.GET(GeneralSetup."Global Dimension 2 Code") then
            ltDimension.Init();
        DimCaptionEng2 := ltDimension.Description;
        DimCaptionThai2 := ltDimension."Thai Description";
    end;
    /// <summary>
    /// SetDefualtGetInvoiceSales.
    /// </summary>
    /// <param name="pShipNo">code[20].</param>
    /// <param name="pShipLineNo">integer.</param>
    procedure SetDefualtGetInvoiceSales(pShipNo: code[20]; pShipLineNo: integer)
    var
        SalesShipmentLine: record "Sales Shipment Line";
    begin
        if SalesShipmentLine.GET(pShipNo, pShipLineNo) then begin
            SalesShipmentLine."NCT Get to Invoice" := false;
            SalesShipmentLine.Modify();
        end;
    end;

    /// <summary>
    /// SetDefualtGetInvoice.
    /// </summary>
    /// <param name="pReceiptNo">code[20].</param>
    /// <param name="pReceiptLineNo">integer.</param>
    procedure SetDefualtGetInvoicePurch(pReceiptNo: code[20]; pReceiptLineNo: integer)
    var
        ReceiptLine: record "Purch. Rcpt. Line";
    begin
        if ReceiptLine.GET(pReceiptNo, pReceiptLineNo) then begin
            ReceiptLine."NCT Get to Invoice" := false;
            ReceiptLine.Modify();
        end;
    end;

    /// <summary>
    /// SetDefualtGetCN.
    /// </summary>
    /// <param name="pReturnShipmentNo">code[20].</param>
    /// <param name="pReturnShipmentLineNo">integer.</param>
    procedure SetDefualtGetPurchCN(pReturnShipmentNo: code[20]; pReturnShipmentLineNo: integer)
    var
        ReturnShipmentLine: record "Return Shipment Line";
    begin
        if ReturnShipmentLine.GET(pReturnShipmentNo, pReturnShipmentLineNo) then begin
            ReturnShipmentLine."NCT Get to CN" := false;
            ReturnShipmentLine.Modify();
        end;
    end;


    /// <summary>
    /// Generatebarcode.
    /// </summary>
    /// <param name="pBarcodeSymbology">Enum "Barcode Symbology".</param>
    /// <param name="pValue">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure Generatebarcode(pBarcodeSymbology: Enum "Barcode Symbology"; pValue: Text): Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeString: Text;
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := pBarcodeSymbology;
        BarcodeString := pValue;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        exit(BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology));
    end;
    /// <summary>
    /// SetReportGLEntry.
    /// </summary>
    /// <param name="GenLine">Record "Gen. Journal Line".</param>
    /// <param name="pTempGLEntry">Temporary VAR Record "G/L Entry".</param>
    /// <param name="pTempVatEntry">Temporary VAR Record "VAT Entry".</param>
    /// <param name="pTotalAmount">VAR Decimal.</param>
    /// <param name="pGroupping">Boolean.</param>
    /// <param name="pFromPosted">Boolean.</param>
    procedure SetReportGLEntry(GenLine: Record "Gen. Journal Line"; var pTempGLEntry: Record "G/L Entry" temporary; var pTempVatEntry: Record "VAT Entry" temporary; var pTotalAmount: Decimal; pGroupping: Boolean; pFromPosted: Boolean)
    var
        GlEntry: Record "G/L Entry";
        TempltGLEntry, TempGLEntry : Record "G/L Entry" temporary;
        PreviewPost: Codeunit "NCT EventFunction";
        EntryNo: Integer;
        ltIshandle: Boolean;
    begin
        ltIshandle := false;
        pTotalAmount := 0;
        EntryNo := 0;
        if not pFromPosted then
            PreviewPost."GenLinePreviewVourcher"(GenLine, TempGLEntry, pTempVatEntry)
        else begin
            GlEntry.reset();
            GlEntry.SetRange("Document No.", GenLine."Document No.");
            if GlEntry.FindFirst() then
                repeat
                    TempGLEntry.Init();
                    TempGLEntry.TransferFields(GlEntry);
                    TempGLEntry.Insert();
                until GlEntry.Next() = 0;
        end;
        BeforSetGenLineGLEntry(ltIshandle, GenLine, pGroupping, pTotalAmount, TempGLEntry, pTempGLEntry);
        if not ltIshandle then begin
            TempGLEntry.reset();
            TempGLEntry.SetCurrentKey("G/L Account No.", Amount);
            TempGLEntry.SetFilter(Amount, '>%1', 0);
            if TempGLEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("Document No.", GenLine."Document No.");
                        TempltGLEntry.SetRange("Journal Batch Name", GenLine."Journal Batch Name");
                        TempltGLEntry.SetRange("G/L Account No.", TempGLEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", TempGLEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", TempGLEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(TempGLEntry, false);
                            TempltGLEntry."Document No." := GenLine."Document No.";
                            TempltGLEntry."Journal Batch Name" := GenLine."Journal Batch Name";
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + TempGLEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(TempGLEntry, false);
                        TempltGLEntry."Document No." := GenLine."Document No.";
                        TempltGLEntry."Journal Batch Name" := GenLine."Journal Batch Name";
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until TempGLEntry.next() = 0;
            TempGLEntry.reset();
            TempGLEntry.SetCurrentKey("G/L Account No.", Amount);
            TempGLEntry.SetFilter(Amount, '<%1', 0);
            if TempGLEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("Document No.", GenLine."Document No.");
                        TempltGLEntry.SetRange("Journal Batch Name", GenLine."Journal Batch Name");
                        TempltGLEntry.SetRange("G/L Account No.", TempGLEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", TempGLEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", TempGLEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(TempGLEntry, false);
                            TempltGLEntry."Document No." := GenLine."Document No.";
                            TempltGLEntry."Journal Batch Name" := GenLine."Journal Batch Name";
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + TempGLEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(TempGLEntry, false);
                        TempltGLEntry."Document No." := GenLine."Document No.";
                        TempltGLEntry."Journal Batch Name" := GenLine."Journal Batch Name";
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until TempGLEntry.next() = 0;
            TempltGLEntry.reset();
            if TempltGLEntry.FindFirst() then begin
                TempltGLEntry.CalcSums("Debit Amount");
                pTotalAmount := TempltGLEntry."Debit Amount";
            end;
            TempltGLEntry.reset();
            pTempGLEntry.Copy(TempltGLEntry, true);
        end;
    end;



    /// <summary>
    /// SetReportGLEntryPurchase.
    /// </summary>
    /// <param name="PurchaseHeader">Record "Purchase Header".</param>
    /// <param name="pTempGLEntry">Temporary VAR Record "G/L Entry".</param>
    /// <param name="pTotalAmount">VAR Decimal.</param>
    /// <param name="pGroupping">Boolean.</param>
    /// <param name="pFromPosted">Boolean.</param>
    procedure SetReportGLEntryPurchase(PurchaseHeader: Record "Purchase Header"; var pTempGLEntry: Record "G/L Entry" temporary; var pTotalAmount: Decimal; pGroupping: Boolean; pFromPosted: Boolean)
    var
        GlEntry: Record "G/L Entry";
        TempGLEntry, TempltGLEntry : Record "G/L Entry" temporary;
        PreviewPost: Codeunit "NCT EventFunction";
        EntryNo: Integer;
        PurHeader: Record "Purchase Header";
        ltIshandle: Boolean;
    begin
        ltIshandle := false;
        pTotalAmount := 0;
        if not pFromPosted then begin
            PurHeader.GET(PurchaseHeader."Document Type", PurchaseHeader."No.");
            PreviewPost."PurchasePreviewVourcher"(PurHeader, TempGLEntry);
        end else begin
            GlEntry.reset();
            GlEntry.SetRange("Document No.", PurchaseHeader."No.");
            if GlEntry.FindFirst() then
                repeat
                    TempGLEntry.Init();
                    TempGLEntry.TransferFields(GlEntry);
                    TempGLEntry.Insert();
                until GlEntry.Next() = 0;
        end;
        BeforSetPurchaseGLEntry(ltIshandle, PurHeader, pGroupping, pTotalAmount, TempGLEntry, pTempGLEntry);
        if not ltIshandle then begin
            TempGLEntry.reset();
            TempGLEntry.SetCurrentKey("G/L Account No.", Amount);
            TempGLEntry.SetRange("NCT Ref. Document No.", PurHeader."No.");
            TempGLEntry.SetFilter(Amount, '>%1', 0);
            if TempGLEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("G/L Account No.", TempGLEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", TempGLEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", TempGLEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(TempGLEntry, false);
                            TempltGLEntry."Document No." := PurHeader."No.";
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + TempGLEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(TempGLEntry, false);
                        TempltGLEntry."Document No." := PurHeader."No.";
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until TempGLEntry.next() = 0;
            TempGLEntry.reset();
            TempGLEntry.SetCurrentKey("G/L Account No.", Amount);
            TempGLEntry.SetRange("NCT Ref. Document No.", PurHeader."No.");
            TempGLEntry.SetFilter(Amount, '<%1', 0);
            if TempGLEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("G/L Account No.", TempGLEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", TempGLEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", TempGLEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(TempGLEntry, false);
                            TempltGLEntry."Document No." := PurHeader."No.";
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + TempGLEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(TempGLEntry, false);
                        TempltGLEntry."Document No." := PurHeader."No.";
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until TempGLEntry.next() = 0;
            TempltGLEntry.reset();
            if TempltGLEntry.FindFirst() then begin
                TempltGLEntry.CalcSums("Debit Amount");
                pTotalAmount := TempltGLEntry."Debit Amount";
            end;
            TempltGLEntry.reset();
            pTempGLEntry.Copy(TempltGLEntry, true);
        end;
    end;


    /// <summary>
    /// SetReportGLEntrySales.
    /// </summary>
    /// <param name="pSalseHeader">Record "Sales Header".</param>
    /// <param name="pTempGLEntry">Temporary VAR Record "G/L Entry".</param>
    /// <param name="pTotalAmount">VAR Decimal.</param>
    /// <param name="pGroupping">Boolean.</param>
    /// <param name="pFromPosted">Boolean.</param>
    procedure SetReportGLEntrySales(pSalseHeader: Record "Sales Header"; var pTempGLEntry: Record "G/L Entry" temporary; var pTotalAmount: Decimal; pGroupping: Boolean; pFromPosted: Boolean)
    var
        GlEntry: Record "G/L Entry";
        TempGLEntry, TempltGLEntry : Record "G/L Entry" temporary;
        PreviewPost: Codeunit "NCT EventFunction";
        EntryNo: Integer;
        SalesHeader: Record "Sales Header";
        ltIshandle: Boolean;
    begin
        ltIshandle := false;
        pTotalAmount := 0;
        if not pFromPosted then begin
            SalesHeader.GET(pSalseHeader."Document Type", pSalseHeader."No.");
            PreviewPost.SalesPreviewVourcher(SalesHeader, TempGLEntry);
        end else begin
            GlEntry.reset();
            GlEntry.SetRange("Document No.", pSalseHeader."No.");
            if GlEntry.FindFirst() then
                repeat
                    TempGLEntry.Init();
                    TempGLEntry.TransferFields(GlEntry);
                    TempGLEntry.Insert();
                until GlEntry.Next() = 0;
        end;
        BeforSetSalesGLEntry(ltIshandle, SalesHeader, pGroupping, pTotalAmount, TempGLEntry, pTempGLEntry);
        if not ltIshandle then begin
            TempGLEntry.reset();
            TempGLEntry.SetCurrentKey("G/L Account No.", Amount);
            TempGLEntry.SetFilter("Document Type", '<>%1', TempGLEntry."Document Type"::" ");
            TempGLEntry.SetFilter(Amount, '>%1', 0);
            if TempGLEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("G/L Account No.", TempGLEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", TempGLEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", TempGLEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(TempGLEntry, false);
                            TempltGLEntry."Document No." := SalesHeader."No.";
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + TempGLEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(TempGLEntry, false);
                        TempltGLEntry."Document No." := SalesHeader."No.";
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until TempGLEntry.next() = 0;
            TempGLEntry.reset();
            TempGLEntry.SetCurrentKey("G/L Account No.", Amount);
            TempGLEntry.SetFilter("Document Type", '<>%1', TempGLEntry."Document Type"::" ");
            TempGLEntry.SetFilter(Amount, '<%1', 0);
            if TempGLEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("G/L Account No.", TempGLEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", TempGLEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", TempGLEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(TempGLEntry, false);
                            TempltGLEntry."Document No." := SalesHeader."No.";
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + TempGLEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(TempGLEntry, false);
                        TempltGLEntry."Document No." := SalesHeader."No.";
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until TempGLEntry.next() = 0;
            TempltGLEntry.reset();
            if TempltGLEntry.FindFirst() then begin
                TempltGLEntry.CalcSums("Debit Amount");
                pTotalAmount := TempltGLEntry."Debit Amount";
            end;
            TempltGLEntry.reset();
            pTempGLEntry.Copy(TempltGLEntry, true);
        end;
    end;
    /// <summary>
    /// SetReportGLEntryPosted.
    /// </summary>
    /// <param name="pDocumentNo">code[30].</param>
    /// <param name="pPostingDate">Date.</param>
    /// <param name="pTempGLEntry">Temporary VAR Record "G/L Entry".</param>
    /// <param name="pTotalAmount">VAR Decimal.</param>
    /// <param name="pGroupping">Boolean.</param>
    procedure SetReportGLEntryPosted(pDocumentNo: code[30]; pPostingDate: Date; var pTempGLEntry: Record "G/L Entry" temporary; var pTotalAmount: Decimal; pGroupping: Boolean)
    var
        TempltGLEntry: Record "G/L Entry" temporary;
        ltGlEntry: Record "G/L Entry";
        EntryNo: Integer;
        ltIshandle: Boolean;
    begin
        ltIshandle := false;
        pTotalAmount := 0;
        BeforSetPostedGLEntry(ltIshandle, pDocumentNo, pPostingDate, pGroupping, pTotalAmount, pTempGLEntry);
        if not ltIshandle then begin
            ltGlEntry.reset();
            ltGlEntry.SetCurrentKey("G/L Account No.", Amount);
            ltGlEntry.SetRange("Document No.", pDocumentNo);
            ltGlEntry.SetRange("Posting Date", pPostingDate);
            ltGlEntry.SetFilter(Amount, '>%1', 0);
            if ltGlEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("G/L Account No.", ltGlEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", ltGlEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", ltGlEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(ltGlEntry, false);
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + ltGlEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(ltGlEntry, false);
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until ltGlEntry.next() = 0;
            ltGlEntry.reset();
            ltGlEntry.SetCurrentKey("G/L Account No.", Amount);
            ltGlEntry.SetRange("Document No.", pDocumentNo);
            ltGlEntry.SetRange("Posting Date", pPostingDate);
            ltGlEntry.SetFilter(Amount, '<%1', 0);
            if ltGlEntry.FindFirst() then
                repeat
                    if pGroupping then begin
                        TempltGLEntry.reset();
                        TempltGLEntry.SetRange("G/L Account No.", ltGlEntry."G/L Account No.");
                        TempltGLEntry.SetRange("Global Dimension 1 Code", ltGlEntry."Global Dimension 1 Code");
                        TempltGLEntry.SetRange("Global Dimension 2 Code", ltGlEntry."Global Dimension 2 Code");
                        if not TempltGLEntry.FindFirst() then begin
                            EntryNo += 1;
                            TempltGLEntry.init();
                            TempltGLEntry.TransferFields(ltGlEntry, false);
                            TempltGLEntry."Entry No." := EntryNo;
                            TempltGLEntry.Insert();
                        end else begin
                            TempltGLEntry.Amount := TempltGLEntry.Amount + ltGlEntry.Amount;
                            if TempltGLEntry.Amount > 0 then begin
                                TempltGLEntry."Debit Amount" := TempltGLEntry.Amount;
                                TempltGLEntry."Credit Amount" := 0;
                            end else begin
                                TempltGLEntry."Credit Amount" := ABS(TempltGLEntry.Amount);
                                TempltGLEntry."Debit Amount" := 0;
                            end;
                            TempltGLEntry.Modify();
                        end;
                    end else begin
                        EntryNo += 1;
                        TempltGLEntry.init();
                        TempltGLEntry.TransferFields(ltGlEntry, false);
                        TempltGLEntry."Entry No." := EntryNo;
                        TempltGLEntry.Insert();
                    end;

                until ltGlEntry.next() = 0;
            TempltGLEntry.reset();
            if TempltGLEntry.FindFirst() then begin
                TempltGLEntry.CalcSums("Debit Amount");
                pTotalAmount := TempltGLEntry."Debit Amount";
            end;
            TempltGLEntry.reset();
            pTempGLEntry.Copy(TempltGLEntry, true);
        end;
    end;
    /// <summary> 
    /// Description for Get ThaiMonth.
    /// </summary>
    /// <param name="NoOfMonth">Parameter of type Integer.</param>
    /// <returns>Return variable "Text[50]".</returns>
    procedure "Get ThaiMonth"(NoOfMonth: Integer): Text[50]
    begin
        case NoOfMonth OF
            1:
                EXIT('มกราคม');
            2:
                EXIT('กุมภาพันธ์');
            3:
                EXIT('มีนาคม');
            4:
                EXIT('เมษายน');
            5:
                EXIT('พฤษภาคม');
            6:
                EXIT('มิถุนายน');
            7:
                EXIT('กรกฎาคม');
            8:
                EXIT('สิงหาคม');
            9:
                EXIT('กันยายน');
            10:
                EXIT('ตุลาคม');
            11:
                EXIT('พฤศจิกายน');
            12:
                EXIT('ธันวาคม');
        END;

    end;


    /// <summary> 
    /// Description for ConverseDecimalToText.
    /// </summary>
    /// <param name="Deci">Parameter of type Decimal.</param>
    /// <returns>Return variable "Text".</returns>
    procedure "ConverseDecimalToText"(Deci: Decimal): Text
    begin
        exit(FORMAT(Deci, 0, '<Precision,2:2><Standard Format,0>'));
    end;

    /// <summary> 
    /// Description for CompanyInformation.
    /// </summary>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="EngName">Parameter of type Boolean.</param>
    procedure "CompanyInformation"(VAR Text: ARRAY[10] OF Text[250]; EngName: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        Clear(Text);
        CompanyInfo.GET();
        if NOT EngName then begin
            Text[1] := CompanyInfo.Name + ' ' + CompanyInfo."Name 2";
            Text[2] := CompanyInfo.Address + ' ';
            if CompanyInfo."Address 2" <> '' then
                Text[3] := CompanyInfo."Address 2" + ' ';
            Text[3] += CompanyInfo.City + ' ' + CompanyInfo."Post Code";
            Text[4] := 'โทร : ' + CompanyInfo."Phone No." + ' ' + CompanyInfo."Phone No. 2";
            if CompanyInfo."Fax No." <> '' then
                Text[4] += 'แฟกซ์ : ' + CompanyInfo."Fax No.";
            Text[5] := 'อีเมลล์ : ' + CompanyInfo."E-Mail";
            Text[6] := 'เลขประจำตัวผู้เสียภาษี : ' + CompanyInfo."VAT Registration No.";
            if CompanyInfo."NCT Head Office" then
                Text[6] += ' (สำนักงานใหญ่)'
            else
                Text[6] += ' (' + CompanyInfo."NCT VAT Branch Code" + ')';
        end else begin
            Text[1] := CompanyInfo."NCT Name (Eng)" + ' ' + CompanyInfo."NCT Name 2 (Eng)";
            Text[2] := CompanyInfo."NCT Address (Eng)" + ' ';
            if CompanyInfo."NCT Address 2 (Eng)" <> ' ' then
                Text[3] := CompanyInfo."NCT Address 2 (Eng)" + ' ';
            Text[3] += CompanyInfo."NCT City (Eng)" + ' ' + CompanyInfo."Post Code";
            Text[4] := 'Tel. : ' + CompanyInfo."Phone No." + ' ' + CompanyInfo."Phone No. 2";
            if CompanyInfo."Fax No." <> '' then
                Text[4] += 'แฟกซ์ : ' + CompanyInfo."Fax No.";
            Text[5] := 'E-Mail : ' + CompanyInfo."E-Mail";
            Text[6] := 'Tax ID. : ' + CompanyInfo."VAT Registration No.";
            if CompanyInfo."NCT Head Office" then
                Text[6] += ' (Head Office)'
            else
                Text[6] += ' (' + CompanyInfo."NCT VAT Branch Code" + ')';
        end;
        OnAfterGetCompanyInfor(CompanyInfo, Text, EngName);
    end;

    /// <summary> 
    /// Description for CompanyinformationByVat.
    /// </summary>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="VatBus">Parameter of type Code[10].</param>
    /// <param name="EngName">Parameter of type Boolean.</param>
    procedure "CompanyinformationByVat"(VAR Text: ARRAY[10] OF Text[250]; VatBus: Code[20]; EngName: Boolean)
    var
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
    begin
        Clear(Text);
        IF NOT VATBusinessPostingGroup.GET(VatBus) THEN
            VATBusinessPostingGroup.init();

        IF EngName THEN begin
            Text[1] := VATBusinessPostingGroup."NCT Company Name (Eng)" + ' ';
            Text[1] += VATBusinessPostingGroup."NCT Company Name 2 (Eng)";
            Text[2] := VATBusinessPostingGroup."NCT Company Address (Eng)" + ' ';
            if VATBusinessPostingGroup."NCT Company Address 2 (Eng)" <> '' then
                Text[3] := VATBusinessPostingGroup."NCT Company Address 2 (Eng)" + ' ';
            Text[3] += VATBusinessPostingGroup."NCT City (Eng)" + ' ' + VATBusinessPostingGroup."NCT Post code";

            Text[4] := 'Tel. : ' + VATBusinessPostingGroup."NCT Phone No." + ' ';
            if VATBusinessPostingGroup."NCT Fax No." <> '' then
                Text[4] += ' Fax. : ' + VATBusinessPostingGroup."NCT Fax No.";
            Text[5] := 'E-mail : ' + VATBusinessPostingGroup."NCT Email";
            Text[6] := 'Tax ID. : ' + VATBusinessPostingGroup."NCT VAT Registration No.";
            if VATBusinessPostingGroup."NCT Head Office" then
                Text[6] += ' (Head Office)'
            else
                Text[6] += ' (' + VATBusinessPostingGroup."NCT VAT Branch Code" + ')';
        end else begin
            Text[1] := VATBusinessPostingGroup."NCT Company Name (Thai)" + ' ';
            Text[1] += VATBusinessPostingGroup."NCT Company Name 2 (Thai)";
            Text[2] := VATBusinessPostingGroup."NCT Company Address (Thai)" + ' ';
            if VATBusinessPostingGroup."NCT Company Address 2 (Thai)" <> '' then
                Text[3] := VATBusinessPostingGroup."NCT Company Address 2 (Thai)" + ' ';
            Text[3] += VATBusinessPostingGroup."NCT City (Thai)" + ' ' + VATBusinessPostingGroup."NCT Post code";

            Text[4] := 'โทร : ' + VATBusinessPostingGroup."NCT Phone No.";
            if VATBusinessPostingGroup."NCT Fax No." <> '' then
                Text[4] += ' แฟกซ์ : ' + VATBusinessPostingGroup."NCT Fax No.";
            Text[5] := 'อีเมลล์ : ' + VATBusinessPostingGroup."NCT Email";
            Text[6] := 'เลขประจำตัวผู้เสียภาษี : ' + VATBusinessPostingGroup."NCT VAT Registration No.";
            if VATBusinessPostingGroup."NCT Head Office" then
                Text[6] += ' (สำนักงานใหญ่)'
            else
                Text[6] += ' (' + VATBusinessPostingGroup."NCT VAT Branch Code" + ')';

        end;
        OnAfterGetCompanyInforByVat(Text, VatBus, EngName);
    END;

    /// <summary> 
    /// Description for PurchaseInformation.
    /// </summary>
    /// <param name="DocumentType">Parameter of type Enum "Purchase Document Type".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="Tab">Parameter of type Option General,Invoicing,Shipping.</param>
    procedure PurchaseInformation(DocumentType: Enum "Purchase Document Type"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        PurchHeader: Record "Purchase Header";
        Vend: Record Vendor;
        Cust: Record Customer;
        VandorBranch: Record "NCT Customer & Vendor Branch";
    begin
        PurchHeader.GET(DocumentType, DocumentNo);
        CLEAR(Text);
        // CASE DocumentType OF
        //     DocumentType::Quote, DocumentType::Order, DocumentType::Invoice,
        //     DocumentType::"Credit Memo", DocumentType::"Blanket Order", DocumentType::"Return Order", DocumentType::"Requisition":
        //         BEGIN

        CASE Tab OF
            Tab::General:
                BEGIN
                    // if (PurchHeader."Head Office") then begin
                    IF NOT Vend.GET(PurchHeader."Buy-from Vendor No.") THEN
                        Vend.INIT();
                    Text[1] := PurchHeader."Buy-from Vendor Name" + ' ' + PurchHeader."Buy-from Vendor Name 2";
                    Text[2] := PurchHeader."Buy-from Address" + ' ';
                    Text[3] := PurchHeader."Buy-from Address 2" + ' ';
                    Text[3] += PurchHeader."Buy-from City" + ' ' + PurchHeader."Buy-from Post Code";
                    Text[4] := Vend."Phone No." + ' ';
                    if PurchHeader."Currency Code" = '' then begin
                        IF Vend."Fax No." <> '' THEN
                            Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";
                    end else
                        IF Vend."Fax No." <> '' THEN
                            Text[4] += 'Fax. : ' + Vend."Fax No.";
                    Text[5] := PurchHeader."Buy-from Contact";
                    // END else begin
                    if (PurchHeader."NCT VAT Branch Code" <> '') AND (NOT PurchHeader."NCT Head Office") then begin
                        if not VandorBranch.GET(VandorBranch."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."NCT Head Office", PurchHeader."NCT VAT Branch Code") then
                            VandorBranch.Init();
                        if VandorBranch."Name" <> '' then
                            Text[1] := VandorBranch."Name";
                        if VandorBranch."Address" <> '' then begin
                            Text[2] := VandorBranch."Address";
                            Text[3] := VandorBranch."Province" + ' ' + VandorBranch."Post Code";
                        end;
                        if VandorBranch."Phone No." <> '' then
                            Text[4] := VandorBranch."Phone No." + ' ';
                        if PurchHeader."Currency Code" = '' then begin
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += 'แฟกซ์ : ' + VandorBranch."Fax No.";
                        end else
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += 'Fax. : ' + VandorBranch."Fax No.";

                    end;


                    Text[9] := PurchHeader."Buy-from Vendor No.";
                END;
            Tab::Invoicing:
                BEGIN
                    IF NOT Vend.GET(PurchHeader."Pay-to Vendor No.") THEN
                        Vend.INIT();
                    Text[1] := PurchHeader."Pay-to Name" + ' ' + PurchHeader."Pay-to Name 2";
                    Text[2] := PurchHeader."Pay-to Address" + ' ';
                    Text[3] := PurchHeader."Pay-to Address 2" + ' ';
                    Text[3] += PurchHeader."Pay-to City" + ' ' + PurchHeader."Pay-to Post Code";
                    Text[4] := Vend."Phone No." + ' ';
                    if PurchHeader."Currency Code" = '' then begin
                        IF Vend."Fax No." <> '' THEN
                            Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";
                    end else
                        IF Vend."Fax No." <> '' THEN
                            Text[4] += 'Fax. : ' + Vend."Fax No.";
                    Text[5] := PurchHeader."Pay-to Contact";
                    if (PurchHeader."NCT VAT Branch Code" <> '') AND (NOT PurchHeader."NCT Head Office") then begin
                        if not VandorBranch.GET(VandorBranch."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."NCT Head Office", PurchHeader."NCT VAT Branch Code") then
                            VandorBranch.Init();
                        if VandorBranch."Name" <> '' then
                            Text[1] := VandorBranch."Name";
                        if VandorBranch."Address" <> '' then begin
                            Text[2] := VandorBranch."Address";
                            Text[3] := VandorBranch."Province" + ' ' + VandorBranch."Post Code";
                        end;
                        if VandorBranch."Phone No." <> '' then
                            Text[4] := VandorBranch."Phone No." + ' ';
                        if PurchHeader."Currency Code" = '' then begin
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += 'แฟกซ์ : ' + VandorBranch."Fax No.";
                        end else
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += 'Fax. : ' + VandorBranch."Fax No.";

                    end;
                    Text[9] := PurchHeader."Pay-to Vendor No.";
                END;
            Tab::Shipping:
                BEGIN
                    IF NOT Cust.GET(PurchHeader."Sell-to Customer No.") THEN
                        Cust.init();
                    Text[1] := PurchHeader."Ship-to Name" + ' ' + PurchHeader."Ship-to Name 2";
                    Text[2] := PurchHeader."Ship-to Address" + ' ';
                    Text[3] := PurchHeader."Ship-to Address 2" + ' ';
                    Text[3] += PurchHeader."Ship-to City" + ' ' + PurchHeader."Ship-to Post Code";
                    Text[4] := Cust."Phone No." + ' ';
                    if PurchHeader."Currency Code" = '' then begin
                        IF Cust."Fax No." <> '' THEN
                            Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";
                    end else

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += 'Fax. : ' + Cust."Fax No.";
                    Text[5] := PurchHeader."Ship-to Contact";

                END;
        end;
        //     end;
        //  end;
        //if PurchHeader."Head Office" then
        Text[10] := PurchHeader."VAT Registration No.";
        if (PurchHeader."NCT VAT Branch Code" <> '') AND (NOT PurchHeader."NCT Head Office") then begin
            if not VandorBranch.GET(VandorBranch."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."NCT Head Office", PurchHeader."NCT VAT Branch Code") then
                VandorBranch.Init();
            Text[10] := VandorBranch."VAT Registration No.";
        end;
        if PurchHeader."Currency Code" = '' then begin
            if PurchHeader."NCT Head Office" then
                Text[10] += ' (สำนักงานใหญ่)'
            else
                if PurchHeader."NCT VAT Branch Code" <> '' then
                    Text[10] += ' (' + PurchHeader."NCT VAT Branch Code" + ')'
                else
                    Text[10] += ' (สำนักงานใหญ่)';
        end else
            if PurchHeader."NCT Head Office" then
                Text[10] += ' (Head Office)'
            else
                if PurchHeader."NCT VAT Branch Code" <> '' then
                    Text[10] += ' (' + PurchHeader."NCT VAT Branch Code" + ')'
                else
                    Text[10] += ' (Head Office)';
    end;

    /// <summary> 
    /// Description for ConvExchRate.
    /// </summary>
    /// <param name="CurrencyCode">Parameter of type Code[10].</param>
    /// <param name="CurrencyFactor">Parameter of type Decimal.</param>
    /// <param name="VAR Text">Parameter of type Text[30].</param>
    procedure "ConvExchRate"(CurrencyCode: Code[10]; CurrencyFactor: Decimal; VAR Text: Text[30])
    var
        GLSetup: Record "General Ledger Setup";
        Amt1Lbl: Label '%1 (%2)', Locked = true;
    begin
        GLSetup.GET();
        Text := '';
        IF CurrencyCode = '' THEN
            Text := 'THB'
        ELSE
            if CurrencyCode <> 'THB' then
                Text := STRSUBSTNO(Amt1Lbl, COPYSTR(CurrencyCode, 1, 3), ROUND(1 / CurrencyFactor, 0.00001));
    end;



    /// <summary> 
    /// Description for NumberEngToText.
    /// </summary>
    /// <param name="TDecimal">Parameter of type Decimal.</param>
    /// <param name="CurrencyCode">Parameter of type Code[30].</param>
    /// <returns>Return variable TText of type Text.</returns>
    procedure "NumberEngToText"(TDecimal: Decimal; CurrencyCode: Code[10]) TText: Text
    var
        TLow: Decimal;
        TText1: array[2] of Text[1024];
        Amt1Lbl: Label '%3 : %1 %2', Locked = true;
        Amt2Lbl: Label '%1 %2', Locked = true;
    begin
        TDecimal := ROUND(TDecimal, 0.01);
        "InitTextVariable"();
        "EngInterger"(TText1, TDecimal, CurrencyCode);
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        IF TLow < 1 THEN
            TLow := 0;
        if CurrencyCode <> '' then
            TText := STRSUBSTNO(Amt1Lbl, TText1[1], TText1[2], CurrencyCode)
        else
            TText := StrSubstNo(Amt2Lbl, TText1[1], TText1[2]);
        exit(TText);
    end;

    /// <summary> 
    /// Description for NumberThaiToText.
    /// </summary>
    /// <param name="Amount">Parameter of type Decimal.</param>
    /// <returns>Return variable "Text".</returns>
    procedure "NumberThaiToText"(Amount: Decimal): Text
    var
        AmountText: Text;
        x: Integer;
        l: Integer;
        P: Integer;
        adigit: text[1];
        dflag: Boolean;
        AmtThaiText: text;
    begin
        AmountText := FORMAT(Amount, 0);
        x := STRPOS(AmountText, '.');
        CASE TRUE OF
            x = 0:
                AmountText := AmountText + '.00';
            x = STRLEN(AmountText) - 1:
                AmountText := AmountText + '0';
            x > STRLEN(AmountText) - 2:
                AmountText := COPYSTR(AmountText, 1, x + 2);
        END;
        l := STRLEN(AmountText);
        REPEAT
            dflag := FALSE;
            p := STRLEN(AmountText) - l + 1;
            adigit := COPYSTR(AmountText, p, 1);
            IF (l IN [4, 12, 20]) AND (l < STRLEN(AmountText)) AND (adigit = '1') THEN
                dflag := TRUE;
            AmtThaiText := AmtThaiText + "FormatDigitThai"(adigit, l - 3, dflag);
            l := l - 1;
        UNTIL l = 3;

        IF COPYSTR(AmountText, STRLEN(AmountText) - 2, 3) = '.00' THEN
            AmtThaiText := AmtThaiText + 'บาทถ้วน'
        ELSE BEGIN
            IF AmtThaiText <> '' THEN
                AmtThaiText := AmtThaiText + 'บาท';
            l := 2;
            REPEAT
                dflag := FALSE;
                p := STRLEN(AmountText) - l + 1;
                adigit := COPYSTR(AmountText, p, 1);
                IF (l = 1) AND (adigit = '1') AND (COPYSTR(AmountText, p - 1, 1) <> '0') THEN
                    dflag := TRUE;
                AmtThaiText := AmtThaiText + "FormatDigitThai"(adigit, l, dflag);
                l := l - 1;
            UNTIL l = 0;
            AmtThaiText := AmtThaiText + 'สตางค์';
        END;

        EXIT(AmtThaiText);
    end;

    /// <summary>
    /// FormatDigitThai.
    /// </summary>
    /// <param name="adigit">text[1].</param>
    /// <param name="pos">Integer.</param>
    /// <param name="dflag">Boolean.</param>
    /// <returns>Return value of type Text.</returns>
    Local procedure "FormatDigitThai"(adigit: text[1]; pos: Integer; dflag: Boolean): Text
    var
        fdigit: Text[30];
        fcount: Text[30];
    begin
        CASE adigit OF
            '1':

                IF (pos IN [1, 9, 17]) AND dflag THEN
                    fdigit := 'เอ็ด'
                ELSE
                    IF pos IN [2, 10, 18] THEN
                        fdigit := ''
                    ELSE
                        fdigit := 'หนึ่ง';
            '2':

                IF pos IN [2, 10, 18] THEN
                    fdigit := 'ยี่'
                ELSE
                    fdigit := 'สอง';
            '3':
                fdigit := 'สาม';
            '4':
                fdigit := 'สี่';
            '5':
                fdigit := 'ห้า';
            '6':
                fdigit := 'หก';
            '7':
                fdigit := 'เจ็ด';
            '8':
                fdigit := 'แปด';
            '9':
                fdigit := 'เก้า';
            '0':

                IF pos IN [9, 17, 25] THEN
                    fdigit := 'ล้าน';
            '-':
                fdigit := 'ลบ';
        END;
        IF (adigit <> '0') AND (adigit <> '-') THEN
            CASE pos OF
                2, 10, 18:
                    fcount := 'สิบ';
                3, 11, 19:
                    fcount := 'ร้อย';
                5, 13, 21:
                    fcount := 'พัน';
                6, 14, 22:
                    fcount := 'หมื่น';
                7, 15, 23:
                    fcount := 'แสน';
                9, 17, 25:
                    fcount := 'ล้าน';
            END;
        EXIT(fdigit + fcount);
    end;
    /// <summary>
    /// InitTextVariable.
    /// </summary>
    Local procedure "InitTextVariable"()
    var

        Text032Lbl: Label 'ONE';
        Text033Lbl: Label 'TWO';
        Text034Lbl: Label 'THREE';
        Text035Lbl: Label 'FOUR';
        Text036Lbl: Label 'FIVE';
        Text037Lbl: Label 'SIX';
        Text038Lbl: Label 'SEVEN';
        Text039Lbl: Label 'EIGHT';
        Text040Lbl: Label 'NINE';
        Text041Lbl: Label 'TEN';
        Text042Lbl: Label 'ELEVEN';
        Text043Lbl: Label 'TWELVE';
        Text044Lbl: Label 'THIRTEEN';
        Text045Lbl: Label 'FOURTEEN';
        Text046Lbl: Label 'FIFTEEN';
        Text047Lbl: Label 'SIXTEEN';
        Text048Lbl: Label 'SEVENTEEN';
        Text049Lbl: Label 'EIGHTEEN';
        Text050Lbl: Label 'NINETEEN';
        Text051Lbl: Label 'TWENTY';
        Text052Lbl: Label 'THIRTY';
        Text053Lbl: Label 'FORTY';
        Text054Lbl: Label 'FIFTY';
        Text055Lbl: Label 'SIXTY';
        Text056Lbl: Label 'SEVENTY';
        Text057Lbl: Label 'EIGHTY';
        Text058Lbl: Label 'NINETY';
        Text059Lbl: Label 'THOUSAND';
        Text060Lbl: Label 'MILLION';
        Text061Lbl: Label 'BILLION';
    begin
        OnesText[1] := Text032Lbl;
        OnesText[2] := Text033Lbl;
        OnesText[3] := Text034Lbl;
        OnesText[4] := Text035Lbl;
        OnesText[5] := Text036Lbl;
        OnesText[6] := Text037Lbl;
        OnesText[7] := Text038Lbl;
        OnesText[8] := Text039Lbl;
        OnesText[9] := Text040Lbl;
        OnesText[10] := Text041Lbl;
        OnesText[11] := Text042Lbl;
        OnesText[12] := Text043Lbl;
        OnesText[13] := Text044Lbl;
        OnesText[14] := Text045Lbl;
        OnesText[15] := Text046Lbl;
        OnesText[16] := Text047Lbl;
        OnesText[17] := Text048Lbl;
        OnesText[18] := Text049Lbl;
        OnesText[19] := Text050Lbl;

        TensText[1] := '';
        TensText[2] := Text051Lbl;
        TensText[3] := Text052Lbl;
        TensText[4] := Text053Lbl;
        TensText[5] := Text054Lbl;
        TensText[6] := Text055Lbl;
        TensText[7] := Text056Lbl;
        TensText[8] := Text057Lbl;
        TensText[9] := Text058Lbl;

        ExponentText[1] := '';
        ExponentText[2] := Text059Lbl;
        ExponentText[3] := Text060Lbl;
        ExponentText[4] := Text061Lbl;
    end;
    /// <summary>
    /// EngInterger.
    /// </summary>
    /// <param name="VAR NoText">ARRAY[2] OF Text[80].</param>
    /// <param name="No">Decimal.</param>
    /// <param name="CurrencyCode">Code[10].</param>
    Local procedure "EngInterger"(VAR NoText: ARRAY[2] OF Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        varzero: Code[10];
        Text027Lbl: Label 'HUNDRED';
        Text026Lbl: Label 'ZERO';
        Text028Lbl: Label 'AND';
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            "AddToNoText"(NoText, NoTextIndex, PrintExponent, Text026Lbl)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, Text027Lbl);
                END;
                IF Tens >= 2 THEN BEGIN
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        IF CurrencyCode = '' THEN BEGIN
            IF No = 0 THEN BEGIN
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'BAHT');
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ONLY ')
            END
            ELSE BEGIN
                //  "AddToNoText"(NoText,NoTextIndex,PrintExponent,'BAHT');
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, Text028Lbl);
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'POINT');
                Ones := No * 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                //...Customize
                varzero := '';
                IF (No * 100) < 10 THEN
                    varzero := '0';
                //"AddToNoText"(NoText, NoTextIndex, PrintExponent, varzero + FORMAT((No * 100), 0, 0) + '/100');

                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[1], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1));
                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[2], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1));


                if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] <> 0) then
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]] + ' ' + OnesText[TempCurrencyPointInterger[2]])
                else begin
                    if (TempCurrencyPointInterger[1] = 0) And (TempCurrencyPointInterger[2] <> 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ZERO ' + OnesText[TempCurrencyPointInterger[2]]);
                    if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] = 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]]);

                end;
            END;
        END ELSE
            IF No = 0 THEN
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ONLY ')
            ELSE BEGIN
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'POINT');
                //...Customize
                varzero := '';
                IF (No * 100) < 10 THEN
                    varzero := '0';
                // "AddToNoText"(NoText, NoTextIndex, PrintExponent, varzero + FORMAT((No * 100), 0, 0) + '/100');
                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[1], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1));
                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[2], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1));

                if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] <> 0) then
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]] + ' ' + OnesText[TempCurrencyPointInterger[2]])
                else begin
                    if (TempCurrencyPointInterger[1] = 0) And (TempCurrencyPointInterger[2] <> 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ZERO ' + OnesText[TempCurrencyPointInterger[2]]);
                    if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] = 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]]);

                end;
            END;
    end;

    /// <summary> 
    /// Description for AddToNoText.
    /// </summary>
    /// <param name="VAR NoText">Parameter of type ARRAY[2] OF Text[80].</param>
    /// <param name="VAR NoTextIndex">Parameter of type Integer.</param>
    /// <param name="VAR PrintExponent">Parameter of type Boolean.</param>
    /// <param name="AddText">Parameter of type Text[30].</param>
    local procedure "AddToNoText"(VAR NoText: ARRAY[2] OF Text[80]; VAR NoTextIndex: Integer; VAR PrintExponent: Boolean; AddText: Text[30])
    var
        Text029Msg: Label '%1 results in a written number that is too long.', Locked = true;
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029Msg, AddText);
        END;

        NoText[NoTextIndex] := COPYSTR(DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<'), 1, 80);
    end;

    /// <summary> 
    /// Description for SalesInformation.
    /// </summary>
    /// <param name="DocumentType">Parameter of type Enum "Sales Document Type".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="Tab">Parameter of type Option General,Invoicing,Shipping.</param>
    procedure "SalesInformation"(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        SalesHeader: Record "Sales Header";
        Cust: Record Customer;
        Shipto: Record "Ship-to Address";
        CustBranch: Record "NCT Customer & Vendor Branch";
    begin
        CLEAR(Text);
        SalesHeader.GET(DocumentType, DocumentNo);
        CASE Tab OF
            Tab::General:
                BEGIN
                    //  if SalesHeader."Head Office" then begin
                    IF NOT Cust.GET(SalesHeader."Sell-to Customer No.") THEN
                        Cust.INIT();
                    Text[1] := SalesHeader."Sell-to Customer Name" + ' ' + SalesHeader."Sell-to Customer Name 2";
                    Text[2] := SalesHeader."Sell-to Address" + ' ';
                    Text[3] := SalesHeader."Sell-to Address 2" + ' ';
                    Text[3] += SalesHeader."Sell-to City" + ' ' + SalesHeader."Sell-to Post Code";
                    Text[4] := Cust."Phone No." + ' ';
                    if SalesHeader."Currency Code" = '' then begin

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                    end else

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += 'Fax. : ' + Cust."Fax No.";
                    Text[5] := SalesHeader."Sell-to Contact";
                    // end else begin
                    if (SalesHeader."NCT VAT Branch Code" <> '') AND (NOT SalesHeader."NCT Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::Customer, SalesHeader."Sell-to Customer No.", SalesHeader."NCT Head Office", SalesHeader."NCT VAT Branch Code") then
                            CustBranch.Init();
                        if CustBranch."Name" <> '' then
                            Text[1] := CustBranch."Name";
                        if CustBranch."Address" <> '' then begin
                            Text[2] := CustBranch."Address";
                            Text[3] := CustBranch."Province" + ' ' + CustBranch."Post Code";
                        end;
                        if CustBranch."Phone No." <> '' then
                            Text[4] := CustBranch."Phone No." + ' ';
                        if SalesHeader."Currency Code" = '' then begin
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += 'แฟกซ์ : ' + CustBranch."Fax No.";
                        end else
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += 'Fax. : ' + CustBranch."Fax No.";
                    end;
                    Text[9] := SalesHeader."Sell-to Customer No.";
                END;
            Tab::Invoicing:
                BEGIN
                    IF NOT Cust.GET(SalesHeader."Bill-to Customer No.") THEN
                        Cust.INIT();
                    Text[1] := SalesHeader."Bill-to Name" + ' ' + SalesHeader."Bill-to Name 2";
                    Text[2] := SalesHeader."Bill-to Address" + ' ';
                    Text[3] := SalesHeader."Bill-to Address 2" + ' ';
                    Text[3] += SalesHeader."Bill-to City" + ' ' + SalesHeader."Bill-to Post Code";
                    Text[4] := Cust."Phone No." + ' ';
                    if SalesHeader."Currency Code" = '' then begin
                        IF Cust."Fax No." <> '' THEN
                            Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                    end else

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += 'Fax. : ' + Cust."Fax No.";
                    Text[5] := SalesHeader."Bill-to Contact";
                    if (SalesHeader."NCT VAT Branch Code" <> '') AND (NOT SalesHeader."NCT Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::Customer, SalesHeader."Sell-to Customer No.", SalesHeader."NCT Head Office", SalesHeader."NCT VAT Branch Code") then
                            CustBranch.Init();
                        if CustBranch."Name" <> '' then
                            Text[1] := CustBranch."Name";
                        if CustBranch."Address" <> '' then begin
                            Text[2] := CustBranch."Address";
                            Text[3] := CustBranch."Province" + ' ' + CustBranch."Post Code";
                        end;
                        if CustBranch."Phone No." <> '' then
                            Text[4] := CustBranch."Phone No." + ' ';
                        if SalesHeader."Currency Code" = '' then begin
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += 'แฟกซ์ : ' + CustBranch."Fax No.";
                        end else
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += 'Fax. : ' + CustBranch."Fax No.";
                    end;
                    Text[9] := SalesHeader."Bill-to Customer No.";
                END;
            Tab::Shipping:
                BEGIN
                    IF NOT Shipto.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") THEN
                        Shipto.INIT();

                    Text[1] := SalesHeader."Ship-to Name" + ' ' + SalesHeader."Ship-to Name 2";
                    Text[2] := SalesHeader."Ship-to Address" + ' ';
                    Text[3] := SalesHeader."Ship-to Address 2" + ' ';
                    Text[3] += SalesHeader."Ship-to City" + ' ' + SalesHeader."Ship-to Post Code";
                    Text[4] := Shipto."Phone No." + ' ';
                    if SalesHeader."Currency Code" = '' then begin

                        IF Shipto."Fax No." <> '' THEN
                            Text[4] += 'แฟกซ์ : ' + Shipto."Fax No.";

                    end else

                        IF Shipto."Fax No." <> '' THEN
                            Text[4] += 'Fax. : ' + Shipto."Fax No.";
                    Text[5] := SalesHeader."Ship-to Contact";

                END;
        end;

        //end;
        // end; 
        Text[10] := SalesHeader."VAT Registration No.";
        if (SalesHeader."NCT VAT Branch Code" <> '') AND (NOT SalesHeader."NCT Head Office") then begin
            if not CustBranch.GET(CustBranch."Source Type"::customer, SalesHeader."Sell-to Customer No.", SalesHeader."NCT Head Office", SalesHeader."NCT VAT Branch Code") then
                CustBranch.Init();
            Text[10] := CustBranch."VAT Registration No.";
        end;
        if SalesHeader."Currency Code" = '' then begin

            if SalesHeader."NCT Head Office" then
                Text[10] += ' (สำนักงานใหญ่)'
            else
                if SalesHeader."NCT VAT Branch Code" <> '' then
                    Text[10] += ' (' + SalesHeader."NCT VAT Branch Code" + ')'
                else
                    Text[10] += ' (สำนักงานใหญ่)';
        end else

            if SalesHeader."NCT Head Office" then
                Text[10] += ' (Head Office)'
            else
                if SalesHeader."NCT VAT Branch Code" <> '' then
                    Text[10] += ' (' + SalesHeader."NCT VAT Branch Code" + ')'
                else
                    Text[10] += ' (Head Office)';

    end;

    /// <summary> 
    /// Description for VendInfo.
    /// </summary>
    /// <param name="VendorNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    procedure "VendInfo"(VendorNo: Code[20]; VAR Text: ARRAY[10] OF Text[250])
    var
        Vendor: Record Vendor;
    begin
        CLEAR(Text);
        IF NOT Vendor.GET(VendorNo) THEN
            Vendor.INIT();
        Text[1] := Vendor.Name + ' ' + Vendor."Name 2";
        Text[2] := Vendor.Address + ' ';
        Text[3] := Vendor."Address 2" + ' ' + Vendor.City + ' ' + Vendor."Post Code";
        Text[4] := Vendor."Phone No." + ' ';
        IF (Vendor."Fax No." <> '') THEN
            if vendor."Currency Code" = '' then
                Text[4] += 'แฟกซ์ ' + Vendor."Fax No."
            else
                Text[4] += 'Fax. ' + Vendor."Fax No.";
        Text[5] := Vendor."E-Mail";
        Text[6] := Vendor.Contact;
        Text[9] := Vendor."No.";
        Text[10] := Vendor."VAT Registration No.";
    end;

    /// <summary> 
    /// Description for CusInfo.
    /// </summary>
    /// <param name="CustNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    procedure "CusInfo"(CustNo: Code[20]; VAR Text: ARRAY[10] OF Text[250])
    var
        Cust: Record Customer;
    begin
        CLEAR(Text);
        IF NOT Cust.GET(CustNo) THEN
            Cust.INIT();
        Text[1] := Cust.Name + ' ' + Cust."Name 2";
        Text[2] := Cust.Address + ' ';
        Text[3] := Cust."Address 2" + ' ' + Cust.City + ' ' + Cust."Post Code";
        Text[4] := Cust."Phone No." + ' ';
        IF (Cust."Fax No." <> '') THEN
            if Cust."Currency Code" = '' then
                Text[4] += 'แฟกซ์ ' + Cust."Fax No."
            else
                Text[4] += 'Fax. ' + Cust."Fax No.";
        Text[5] := Cust."E-Mail";
        Text[6] := Cust.Contact;
        Text[9] := Cust."No.";
        Text[10] := Cust."VAT Registration No.";

    end;

    /// <summary> 
    /// Description for JnlFindApplyEntries.
    /// </summary>
    /// <param name="JnlTemplateName">Parameter of type Code[30].</param>
    /// <param name="JnlBatchName">Parameter of type code[30].</param>
    /// <param name="PostingDate">Parameter of type Date.</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR CVLedgEntryBuf">Parameter of type Record "CV Ledger Entry Buffer" TEMPORARY.</param>
    procedure JnlFindApplyEntries(JnlTemplateName: Code[30]; JnlBatchName: code[30]; PostingDate: Date; DocumentNo: Code[20]; VAR CVLedgEntryBuf: Record "CV Ledger Entry Buffer" TEMPORARY)
    var
        GenJnlLine: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CvNo: Code[30];
    begin
        GenJnlLine.RESET();
        GenJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Document No.", "Posting Date");
        GenJnlLine.SETRANGE("Journal Template Name", JnlTemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", JnlBatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        GenJnlLine.SETRANGE("Posting Date", PostingDate);
        IF GenJnlLine.FindSet() THEN
            REPEAT
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) OR
                   (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor) THEN BEGIN
                    CVNo := GenJnlLine."Bal. Account No.";
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
                        CVNo := GenJnlLine."Account No.";
                    IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                        VendLedgEntry.RESET();
                        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
                        VendLedgEntry.SETRANGE("Vendor No.", CVNo);
                        VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                        //VendLedgEntry.SETRANGE(Open,TRUE);
                        IF VendLedgEntry.FINDFIRST() THEN
                            REPEAT
                                VendLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                                //GenPostLine.TransferVendLedgEntry(CVLedgEntryBuf,VendLedgEntry,TRUE);
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            UNTIL VendLedgEntry.NEXT() = 0;
                    END ELSE
                        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                            VendLedgEntry.RESET();
                            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Document Type", "Document No.", Open);
                            VendLedgEntry.SETRANGE("Vendor No.", CVNo);
                            VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                            VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                            //VendLedgEntry.SETRANGE(Open,TRUE);
                            IF VendLedgEntry.FINDFIRST() THEN BEGIN
                                VendLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                                //TmpGenPostLine.TransferVendLedgEntry(CVLedgEntryBuf,VendLedgEntry,TRUE);
                                //CVLedgEntryBuf."Amount to Apply" := VendLedgEntry."Remaining Amount";
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            END;
                        END;
                END;
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) OR
                   (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) THEN BEGIN
                    CVNo := GenJnlLine."Bal. Account No.";
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
                        CVNo := GenJnlLine."Account No.";
                    IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                        CustLedgEntry.RESET();
                        CustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
                        CustLedgEntry.SETRANGE("Customer No.", CVNo);
                        CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                        //CustLedgEntry.SETRANGE(Open,TRUE);
                        IF CustLedgEntry.FINDFIRST() THEN
                            REPEAT
                                CustLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                //TmpGenPostLine.TransferCustLedgEntry(CVLedgEntryBuf,CustLedgEntry,TRUE);
                                CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            UNTIL CustLedgEntry.NEXT() = 0;
                    END ELSE
                        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                            CustLedgEntry.RESET();
                            CustLedgEntry.SETCURRENTKEY("Customer No.", "Document Type", "Document No.", Open);
                            CustLedgEntry.SETRANGE("Customer No.", CVNo);
                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                            //CustLedgEntry.SETRANGE(Open,TRUE);
                            IF CustLedgEntry.FINDFIRST() THEN BEGIN
                                CustLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                //TmpGenPostLine.TransferCustLedgEntry(CVLedgEntryBuf,CustLedgEntry,TRUE);
                                CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
                                //CVLedgEntryBuf."Amount to Apply" := CustLedgEntry."Remaining Amount";
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            END;
                        END;
                END;

            UNTIL GenJnlLine.NEXT() = 0;
    end;
    /// <summary>
    /// PostedJnlFindApplyEntries.
    /// </summary>
    /// <param name="JnlTemplateName">Code[30].</param>
    /// <param name="JnlBatchName">code[30].</param>
    /// <param name="PostingDate">Date.</param>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR CVLedgEntryBuf">Record "CV Ledger Entry Buffer" TEMPORARY.</param>
    procedure PostedJnlFindApplyEntries(JnlTemplateName: Code[30]; JnlBatchName: code[30]; PostingDate: Date; DocumentNo: Code[20]; VAR CVLedgEntryBuf: Record "CV Ledger Entry Buffer" TEMPORARY)
    var
        GenJnlLine: Record "Posted Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        DetailVendor: Record "Detailed Vendor Ledg. Entry";
        DetailCust: Record "Detailed Cust. Ledg. Entry";
        CvNo: Code[30];
    begin
        GenJnlLine.RESET();
        GenJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Document No.", "Posting Date");
        GenJnlLine.SETRANGE("Journal Template Name", JnlTemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", JnlBatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        GenJnlLine.SETRANGE("Posting Date", PostingDate);
        IF GenJnlLine.FindSet() THEN
            REPEAT
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) OR
                   (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor) THEN BEGIN
                    CVNo := GenJnlLine."Bal. Account No.";
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
                        CVNo := GenJnlLine."Account No.";
                    IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                        DetailVendor.reset();
                        DetailVendor.SETRANGE("Vendor No.", CVNo);
                        DetailVendor.SetRange("Document No.", GenJnlLine."Applies-to ID");
                        DetailVendor.SetFilter("NCT Invoice Entry No.", '<>%1', 0);
                        if DetailVendor.FindSet() then
                            repeat
                                DetailVendor.CalcSums(Amount);
                                DetailVendor.CalcFields("NCT Invoice Entry No.");
                                VendLedgEntry.GET(DetailVendor."NCT Invoice Entry No.");
                                VendLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                  "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                                CVLedgEntryBuf."Amount to Apply" := DetailVendor.Amount;
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            until DetailVendor.Next() = 0;
                    END ELSE
                        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                            VendLedgEntry.RESET();
                            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Document Type", "Document No.", Open);
                            VendLedgEntry.SETRANGE("Vendor No.", CVNo);
                            VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                            VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                            //VendLedgEntry.SETRANGE(Open,TRUE);
                            IF VendLedgEntry.FINDFIRST() THEN BEGIN
                                VendLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                                //TmpGenPostLine.TransferVendLedgEntry(CVLedgEntryBuf,VendLedgEntry,TRUE);
                                //CVLedgEntryBuf."Amount to Apply" := VendLedgEntry."Remaining Amount";
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            END;
                        END;
                END;
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) OR
                   (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) THEN BEGIN
                    CVNo := GenJnlLine."Bal. Account No.";
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
                        CVNo := GenJnlLine."Account No.";
                    IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                        DetailCust.reset();
                        DetailCust.SETRANGE("Customer No.", CVNo);
                        DetailCust.SetRange("Document No.", GenJnlLine."Applies-to ID");
                        DetailCust.SetFilter("NCT Invoice Entry No.", '<>%1', 0);
                        if DetailCust.FindSet() then
                            REPEAT
                                DetailCust.CalcSums(Amount);
                                DetailCust.CalcFields("NCT Invoice Entry No.");
                                CustLedgEntry.GET(DetailVendor."NCT Invoice Entry No.");
                                CustLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                //TmpGenPostLine.TransferCustLedgEntry(CVLedgEntryBuf,CustLedgEntry,TRUE);
                                CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
                                CVLedgEntryBuf."Amount to Apply" := CustLedgEntry.Amount;
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            UNTIL DetailCust.NEXT() = 0;
                    END ELSE
                        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                            CustLedgEntry.RESET();
                            CustLedgEntry.SETCURRENTKEY("Customer No.", "Document Type", "Document No.", Open);
                            CustLedgEntry.SETRANGE("Customer No.", CVNo);
                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                            //CustLedgEntry.SETRANGE(Open,TRUE);
                            IF CustLedgEntry.FINDFIRST() THEN BEGIN
                                CustLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                //TmpGenPostLine.TransferCustLedgEntry(CVLedgEntryBuf,CustLedgEntry,TRUE);
                                CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
                                //CVLedgEntryBuf."Amount to Apply" := CustLedgEntry."Remaining Amount";
                                if not CVLedgEntryBuf.INSERT() then
                                    CVLedgEntryBuf.Modify();
                            END;
                        END;
                END;

            UNTIL GenJnlLine.NEXT() = 0;
    end;
    /// <summary>
    /// PostedSalesInvoiceStatistics.
    /// </summary>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR TotalAmt">ARRAY[100] OF Decimal.</param>
    /// <param name="VAR VATText">Text[30].</param>
    procedure "PostedSalesInvoiceStatistics"(DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])

    var
        DocumentTotals: Codeunit "Document Totals";
        TotalSalesInvoice: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        VATAmount: Decimal;
    begin
        CLEAR(TotalAmt);
        SalesInvoiceLine.reset();
        SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        if SalesInvoiceLine.FindFirst() then
            DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoice, VATAmount, SalesInvoiceLine);

        TotalAmt[1] := TotalSalesInvoice.Amount + TotalSalesInvoice."Invoice Discount Amount";
        TotalAmt[2] := TotalSalesInvoice."Invoice Discount Amount";
        TotalAmt[3] := TotalSalesInvoice.Amount;
        TotalAmt[4] := VATAmount;
        TotalAmt[5] := TotalSalesInvoice."Amount Including VAT";
        if VATAmount <> 0 then begin
            SalesInvoiceLine.reset();
            SalesInvoiceLine.SetRange("Document No.", DocumentNo);
            SalesInvoiceLine.SetFilter("VAT %", '<>%1', 0);
            if SalesInvoiceLine.FindFirst() then
                VATText := STRSUBSTNO(Text002Msg, SalesInvoiceLine."VAT %");
        end;

    end;
    /// <summary>
    /// PostedSalesCrMemoStatistics.
    /// </summary>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR TotalAmt">ARRAY[100] OF Decimal.</param>
    /// <param name="VAR VATText">Text[30].</param>
    procedure "PostedSalesCrMemoStatistics"(DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])
    var
        DocumentTotals: Codeunit "Document Totals";
        TotalSalesCreditMemo: Record "Sales Cr.Memo Header";
        SalesCreditLine: Record "Sales Cr.Memo Line";
        VATAmount: Decimal;
    begin
        CLEAR(TotalAmt);
        SalesCreditLine.reset();
        SalesCreditLine.SetRange("Document No.", DocumentNo);
        if SalesCreditLine.FindFirst() then
            DocumentTotals.CalculatePostedSalesCreditMemoTotals(TotalSalesCreditMemo, VATAmount, SalesCreditLine);

        TotalAmt[1] := TotalSalesCreditMemo.Amount + TotalSalesCreditMemo."Invoice Discount Amount";
        TotalAmt[2] := TotalSalesCreditMemo."Invoice Discount Amount";
        TotalAmt[3] := TotalSalesCreditMemo.Amount;
        TotalAmt[4] := VATAmount;
        TotalAmt[5] := TotalSalesCreditMemo."Amount Including VAT";



        if VATAmount <> 0 then begin
            SalesCreditLine.reset();
            SalesCreditLine.SetRange("Document No.", DocumentNo);
            SalesCreditLine.SetFilter("VAT %", '<>%1', 0);
            if SalesCreditLine.FindFirst() then
                VATText := STRSUBSTNO(Text002Msg, SalesCreditLine."VAT %");
        end;

    end;
    /// <summary> 
    /// Description for SalesStatistic.
    /// </summary>
    /// <param name="DocumentType">Parameter of type Enum "Sales Document Type".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR TotalAmt">Parameter of type ARRAY[100] OF Decimal.</param>
    /// <param name="VAR VATText">Parameter of type Text[30].</param>
    procedure SalesStatistic(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])
    var

        SalesHeader: Record "Sales Header";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct : Decimal;
        TotalSalesLine, TotalSalesLine2 : Record "Sales Line";

    begin
        CLEAR(TotalAmt);
        IF NOT SalesHeader.GET(DocumentType, DocumentNo) THEN
            EXIT;
        DocumentTotals.CalculateSalesSubPageTotals(SalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        TotalAmt[1] := TotalSalesLine."Line Amount";
        TotalAmt[2] := InvoiceDiscountAmount;
        TotalAmt[3] := TotalSalesLine.Amount;
        TotalAmt[4] := VATAmount;
        TotalAmt[5] := TotalSalesLine."Amount Including VAT";
        if VATAmount <> 0 then begin
            TotalSalesLine2.reset();
            TotalSalesLine2.SetRange("Document Type", DocumentType);
            TotalSalesLine2.SetRange("Document No.", DocumentNo);
            TotalSalesLine2.SetFilter("VAT %", '<>%1', 0);
            if TotalSalesLine2.FindFirst() then
                VATText := STRSUBSTNO(Text002Msg, TotalSalesLine2."VAT %");
        end;
    end;

    /// <summary> 
    /// Description for SalesBillingReceiptInformation.
    /// </summary>
    /// <param name="MyText">Parameter of type array[10] of text[250].</param>
    /// <param name="DocumentType">Parameter of type Option "Sales Billing","Sales Receipt","Purchase Billing".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    procedure SalesBillingReceiptInformation(var MyText: array[10] of text[250]; DocumentType: Enum "NCT Billing Document Type"; DocumentNo: Code[20])
    var
        BillingReceiptHeader: Record "NCT Billing Receipt Header";
        Cust: Record Customer;
        vendor: Record Vendor;
        Tel: Text[250];
        VatRegis: Text[250];

    begin
        CLEAR(MyText);
        if not BillingReceiptHeader.GET(DocumentType, DocumentNo) then
            exit;
        if DocumentType = DocumentType::"Purchase Billing" then begin
            vendor.get(BillingReceiptHeader."Bill/Pay-to Cust/Vend No.");
            Tel := vendor."Phone No." + ' ';
            if Vendor."Currency Code" = '' then begin
                if vendor."Fax No." <> '' then
                    tel += 'แฟกซ์ : ' + vendor."Fax No.";
                VatRegis := BillingReceiptHeader."VAT Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (สำนักงานใหญ่)'
                else
                    VatRegis += ' (' + BillingReceiptHeader."VAT Branch Code" + ')';
            end else begin
                if vendor."Fax No." <> '' then
                    tel += 'Fax : ' + vendor."Fax No.";
                VatRegis := BillingReceiptHeader."VAT Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (Head Office)'
                else
                    VatRegis += ' (' + BillingReceiptHeader."VAT Branch Code" + ')';
            end;
        end else begin
            Cust.get(BillingReceiptHeader."Bill/Pay-to Cust/Vend No.");
            Tel := Cust."Phone No." + ' ';
            if Cust."Currency Code" = '' then begin
                if Cust."Fax No." <> '' then
                    tel += 'แฟกซ์ : ' + Cust."Fax No.";
                VatRegis := BillingReceiptHeader."VAT Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (สำนักงานใหญ่)'
                else
                    if BillingReceiptHeader."VAT Branch Code" <> '' then
                        VatRegis += ' (' + BillingReceiptHeader."VAT Branch Code" + ')'
                    else
                        VatRegis += ' (สำนักงานใหญ่)';
            end else begin
                if Cust."Fax No." <> '' then
                    tel += 'Fax : ' + Cust."Fax No.";
                VatRegis := BillingReceiptHeader."Vat Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (Head Office)'
                else
                    if BillingReceiptHeader."VAT Branch Code" <> '' then
                        VatRegis += ' (' + BillingReceiptHeader."VAT Branch Code" + ')'
                    else
                        VatRegis += ' (Head Office)';
            end;
        end;


        MyText[1] := BillingReceiptHeader."Bill/Pay-to Cust/Vend Name" + ' ' + BillingReceiptHeader."Bill/Pay-to Cust/Vend Name 2";
        MyText[2] := BillingReceiptHeader."Bill/Pay-to Address" + ' ';
        MyText[3] := BillingReceiptHeader."Bill/Pay-to Address 2" + ' ';
        MyText[3] += BillingReceiptHeader."Bill/Pay-to City" + ' ' + BillingReceiptHeader."Bill/Pay-to Post Code";
        MyText[4] := Tel;
        MyText[5] := BillingReceiptHeader."Bill/Pay-to Contact";
        MyText[9] := BillingReceiptHeader."Bill/Pay-to Cust/Vend No.";
        MyText[10] := VatRegis;


    end;
    /// <summary>
    /// PurchStatistic.
    /// </summary>
    /// <param name="DocumentType">Enum "Purchase Document Type".</param>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR TotalAmt">ARRAY[100] OF Decimal.</param>
    /// <param name="VAR VATText">Text[30].</param>
    procedure PurchStatistic(DocumentType: Enum "Purchase Document Type"; DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])
    var

        PurchaseHeader: Record "Purchase Header";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct : Decimal;
        TotalPurchaseLine, TotalPurchaseLine2 : Record "Purchase Line";

    begin
        CLEAR(TotalAmt);
        IF NOT PurchaseHeader.GET(DocumentType, DocumentNo) THEN
            EXIT;
        DocumentTotals.CalculatePurchaseSubPageTotals(PurchaseHeader, TotalPurchaseLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        TotalAmt[1] := TotalPurchaseLine."Line Amount";
        TotalAmt[2] := InvoiceDiscountAmount;
        TotalAmt[3] := TotalPurchaseLine.Amount;
        TotalAmt[4] := VATAmount;
        TotalAmt[5] := TotalPurchaseLine."Amount Including VAT";
        if VATAmount <> 0 then begin
            TotalPurchaseLine2.reset();
            TotalPurchaseLine2.SetRange("Document Type", DocumentType);
            TotalPurchaseLine2.SetRange("Document No.", DocumentNo);
            TotalPurchaseLine2.SetFilter("VAT %", '<>%1', 0);
            if TotalPurchaseLine2.FindFirst() then
                VATText := STRSUBSTNO(Text002Msg, TotalPurchaseLine2."VAT %");
        end;
    end;

    /// <summary>
    /// PostedPurchaseInvoiceStatistics.
    /// </summary>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR TotalAmt">ARRAY[100] OF Decimal.</param>
    /// <param name="VAR VATText">Text[30].</param>
    procedure PostedPurchaseInvoiceStatistics(DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])

    var
        DocumentTotals: Codeunit "Document Totals";
        TotalPurchInvoice: Record "Purch. Inv. Header";
        PurchInvoiceLine: Record "Purch. Inv. Line";
        VATAmount: Decimal;
    begin
        CLEAR(TotalAmt);
        PurchInvoiceLine.reset();
        PurchInvoiceLine.SetRange("Document No.", DocumentNo);
        if PurchInvoiceLine.FindFirst() then
            DocumentTotals.CalculatePostedPurchInvoiceTotals(TotalPurchInvoice, VATAmount, PurchInvoiceLine);

        TotalAmt[1] := TotalPurchInvoice.Amount + TotalPurchInvoice."Invoice Discount Amount";
        TotalAmt[2] := TotalPurchInvoice."Invoice Discount Amount";
        TotalAmt[3] := TotalPurchInvoice.Amount;
        TotalAmt[4] := VATAmount;
        TotalAmt[5] := TotalPurchInvoice."Amount Including VAT";
        if VATAmount <> 0 then begin
            PurchInvoiceLine.reset();
            PurchInvoiceLine.SetRange("Document No.", DocumentNo);
            PurchInvoiceLine.SetFilter("VAT %", '<>%1', 0);
            if PurchInvoiceLine.FindFirst() then
                VATText := STRSUBSTNO(Text002Msg, PurchInvoiceLine."VAT %");
        end;
    end;
    /// <summary>
    /// PostedPurchaseCreditMemoStatistics.
    /// </summary>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR TotalAmt">ARRAY[100] OF Decimal.</param>
    /// <param name="VAR VATText">Text[30].</param>
    procedure "PostedPurchaseCreditMemoStatistics"(DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])

    var
        DocumentTotals: Codeunit "Document Totals";
        TotalPurchCreditMemo: Record "Purch. Cr. Memo Hdr.";
        PurchCreditLine: Record "Purch. Cr. Memo Line";
        VATAmount: Decimal;
    begin
        CLEAR(TotalAmt);
        PurchCreditLine.reset();
        PurchCreditLine.SetRange("Document No.", DocumentNo);
        if PurchCreditLine.FindFirst() then
            DocumentTotals.CalculatePostedPurchCreditMemoTotals(TotalPurchCreditMemo, VATAmount, PurchCreditLine);

        TotalAmt[1] := TotalPurchCreditMemo.Amount + TotalPurchCreditMemo."Invoice Discount Amount";
        TotalAmt[2] := TotalPurchCreditMemo."Invoice Discount Amount";
        TotalAmt[3] := TotalPurchCreditMemo.Amount;
        TotalAmt[4] := VATAmount;
        TotalAmt[5] := TotalPurchCreditMemo."Amount Including VAT";
        if VATAmount <> 0 then begin
            PurchCreditLine.reset();
            PurchCreditLine.SetRange("Document No.", DocumentNo);
            PurchCreditLine.SetFilter("VAT %", '<>%1', 0);
            if PurchCreditLine.FindFirst() then
                VATText := STRSUBSTNO(Text002Msg, PurchCreditLine."VAT %");
        end;

    end;
    /// <summary>
    /// GetSalesComment.
    /// </summary>
    /// <param name="DocumentType">Enum "Sales Comment Document Type".</param>
    /// <param name="DocumentNo">Code[30].</param>
    /// <param name="LineNo">Integer.</param>
    /// <param name="SalesComment">VAR array[100] of text[250].</param>
    procedure GetSalesComment(DocumentType: Enum "Sales Comment Document Type"; DocumentNo: Code[30];
                                                LineNo: Integer; var SalesComment: array[100] of text[250])
    var
        SalesCommentLine: Record "Sales Comment Line";
        i: Integer;

    begin
        i := 0;
        CLEAR(SalesComment);
        SalesCommentLine.RESET();
        SalesCommentLine.SETRANGE("Document Type", DocumentType);
        SalesCommentLine.SETRANGE("No.", DocumentNo);
        SalesCommentLine.SetRange("Document Line No.", LineNo);
        SalesCommentLine.SETFILTER(Comment, '<>%1', '');
        IF SalesCommentLine.FINDSET() THEN
            REPEAT
                i += 1;
                if i <= 100 then
                    SalesComment[i] := SalesCommentLine.Comment;
            UNTIL SalesCommentLine.NEXT() = 0;


    end;
    /// <summary>
    /// GetPurchaseComment.
    /// </summary>
    /// <param name="DocumentType">Enum "Purchase Comment Document Type".</param>
    /// <param name="DocumentNo">Code[30].</param>
    /// <param name="LineNo">Integer.</param>
    /// <param name="PurchCommentLine">VAR array[100] of text[250].</param>
    procedure GetPurchaseComment(DocumentType: Enum "Purchase Comment Document Type"; DocumentNo: Code[30];
                                                   LineNo: Integer; var PurchCommentLine: array[100] of text[250])
    var
        PurchaseCommentLine: Record "Purch. Comment Line";
        i: Integer;
    begin
        i := 0;
        CLEAR(PurchCommentLine);
        PurchaseCommentLine.RESET();
        PurchaseCommentLine.SETRANGE("Document Type", DocumentType);
        PurchaseCommentLine.SETRANGE("No.", DocumentNo);
        PurchaseCommentLine.SetRange("Document Line No.", LineNo);
        PurchaseCommentLine.SETFILTER(Comment, '<>%1', '');
        IF PurchaseCommentLine.FINDSET() THEN
            REPEAT
                i += 1;
                if i <= 100 then
                    PurchCommentLine[i] := PurchaseCommentLine.Comment;
            UNTIL PurchaseCommentLine.NEXT() = 0;

    end;
    /// <summary>
    /// PurchasePostedVendorInformation.
    /// </summary>
    /// <param name="DocumentType">Option Receipt,"Return Shipment","Posted Invoice","Posted Credit Memo".</param>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR Text">ARRAY[10] OF Text[250].</param>
    /// <param name="Tab">Option General,Invoicing,Shipping.</param>
    procedure PurchasePostedVendorInformation(DocumentType: Option Receipt,"Return Shipment","Posted Invoice","Posted Credit Memo"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        Vend: Record Vendor;
        CUst: Record Customer;
        ReturnShptHeader: Record "Return Shipment Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        VendBranch: Record "NCT Customer & Vendor Branch";
    begin
        CLEAR(Text);
        CASE DocumentType OF
            DocumentType::Receipt:
                BEGIN
                    PurchRcptHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                // if PurchRcptHeader."Head Office" then begin
                                IF NOT Vend.GET(PurchRcptHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := PurchRcptHeader."Buy-from Vendor Name" + ' ' + PurchRcptHeader."Buy-from Vendor Name 2";
                                Text[2] := PurchRcptHeader."Buy-from Address" + ' ';
                                Text[3] := PurchRcptHeader."Buy-from Address 2" + ' ';
                                Text[3] += PurchRcptHeader."Buy-from City" + ' ' + PurchRcptHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchRcptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := PurchRcptHeader."Buy-from Contact";

                                //end else begin
                                if (PurchRcptHeader."NCT VAT Branch Code" <> '') AND (NOT PurchRcptHeader."NCT Head Office") then begin
                                    if not VendBranch.GET(VendBranch."Source Type"::Vendor, PurchRcptHeader."Buy-from Vendor No.", PurchRcptHeader."NCT Head Office", PurchRcptHeader."NCT VAT Branch Code") then
                                        VendBranch.Init();
                                    Text[1] := VendBranch."Name";
                                    Text[2] := VendBranch."Address";
                                    Text[3] := VendBranch."Province" + ' ' + VendBranch."Post Code";
                                    Text[4] := VendBranch."Phone No." + ' ';
                                    if PurchRcptHeader."Currency Code" = '' then begin
                                        IF VendBranch."Fax No." <> '' THEN
                                            Text[4] += 'แฟกซ์ : ' + VendBranch."Fax No.";
                                    end else
                                        IF VendBranch."Fax No." <> '' THEN
                                            Text[4] += 'Fax. : ' + VendBranch."Fax No.";

                                end;
                                Text[9] := PurchRcptHeader."Buy-from Vendor No.";
                            end;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(PurchRcptHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := PurchRcptHeader."Pay-to Name" + ' ' + PurchRcptHeader."Pay-to Name 2";
                                Text[2] := PurchRcptHeader."Pay-to Address" + ' ';
                                Text[3] := PurchRcptHeader."Pay-to Address 2" + ' ';
                                Text[3] += PurchRcptHeader."Pay-to City" + ' ' + PurchRcptHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchRcptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := PurchRcptHeader."Pay-to Contact";
                                Text[9] := PurchRcptHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(PurchRcptHeader."Sell-to Customer No.") THEN
                                    Cust.init();
                                Text[1] := PurchRcptHeader."Ship-to Name" + ' ' + PurchRcptHeader."Ship-to Name 2";
                                Text[2] := PurchRcptHeader."Ship-to Address" + ' ';
                                Text[3] := PurchRcptHeader."Ship-to Address 2" + ' ';
                                Text[3] += PurchRcptHeader."Ship-to City" + ' ' + PurchRcptHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if PurchRcptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Cust."Fax No.";
                                Text[5] := PurchRcptHeader."Ship-to Contact";

                            END;
                    end;

                    //  if PurchRcptHeader."Head Office" then
                    Text[10] := PurchRcptHeader."VAT Registration No.";
                    if (PurchRcptHeader."NCT VAT Branch Code" <> '') AND (NOT PurchRcptHeader."NCT Head Office") then begin
                        if not VendBranch.GET(VendBranch."Source Type"::Vendor, PurchRcptHeader."Buy-from Vendor No.", PurchRcptHeader."NCT Head Office", PurchRcptHeader."NCT VAT Branch Code") then
                            VendBranch.Init();
                        Text[10] := VendBranch."VAT Registration No.";
                    end;
                    if PurchRcptHeader."Currency Code" = '' then begin
                        if PurchRcptHeader."NCT Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            if PurchRcptHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + PurchRcptHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (สำนักงานใหญ่)';
                    end else
                        if PurchRcptHeader."NCT Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            if PurchRcptHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + PurchRcptHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (Head Office)';
                END;
            DocumentType::"Return Shipment":
                BEGIN
                    ReturnShptHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Vend.GET(ReturnShptHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := ReturnShptHeader."Buy-from Vendor Name" + ' ' + ReturnShptHeader."Buy-from Vendor Name 2";
                                Text[2] := ReturnShptHeader."Buy-from Address" + ' ';
                                Text[3] := ReturnShptHeader."Buy-from Address 2" + ' ';
                                Text[3] += ReturnShptHeader."Buy-from City" + ' ' + ReturnShptHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if ReturnShptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := ReturnShptHeader."Buy-from Contact";
                                Text[9] := ReturnShptHeader."Buy-from Vendor No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(ReturnShptHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := ReturnShptHeader."Pay-to Name" + ' ' + ReturnShptHeader."Pay-to Name 2";
                                Text[2] := ReturnShptHeader."Pay-to Address" + ' ';
                                Text[3] := ReturnShptHeader."Pay-to Address 2" + ' ';
                                Text[3] += ReturnShptHeader."Pay-to City" + ' ' + ReturnShptHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if ReturnShptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := ReturnShptHeader."Pay-to Contact";
                                Text[9] := ReturnShptHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(ReturnShptHeader."Sell-to Customer No.") THEN
                                    Cust.init();
                                Text[1] := ReturnShptHeader."Ship-to Name" + ' ' + ReturnShptHeader."Ship-to Name 2";
                                Text[2] := ReturnShptHeader."Ship-to Address" + ' ';
                                Text[3] := ReturnShptHeader."Ship-to Address 2" + ' ';
                                Text[3] += ReturnShptHeader."Ship-to City" + ' ' + ReturnShptHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if ReturnShptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Cust."Fax No.";
                                Text[5] := ReturnShptHeader."Ship-to Contact";

                            END;
                    end;
                END;
            DocumentType::"Posted Invoice":
                BEGIN
                    PurchInvHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Vend.GET(PurchInvHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := PurchInvHeader."Buy-from Vendor Name" + ' ' + PurchInvHeader."Buy-from Vendor Name 2";
                                Text[2] := PurchInvHeader."Buy-from Address" + ' ';
                                Text[3] := PurchInvHeader."Buy-from Address 2" + ' ';
                                Text[3] += PurchInvHeader."Buy-from City" + ' ' + PurchInvHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchInvHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := PurchInvHeader."Buy-from Contact";
                                Text[9] := PurchInvHeader."Buy-from Vendor No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(PurchInvHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := PurchInvHeader."Pay-to Name" + ' ' + PurchInvHeader."Pay-to Name 2";
                                Text[2] := PurchInvHeader."Pay-to Address" + ' ';
                                Text[3] := PurchInvHeader."Pay-to Address 2" + ' ';
                                Text[3] += PurchInvHeader."Pay-to City" + ' ' + PurchInvHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchInvHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := PurchInvHeader."Pay-to Contact";
                                Text[9] := PurchInvHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(PurchInvHeader."Sell-to Customer No.") THEN
                                    Cust.init();
                                Text[1] := PurchInvHeader."Ship-to Name" + ' ' + PurchInvHeader."Ship-to Name 2";
                                Text[2] := PurchInvHeader."Ship-to Address" + ' ';
                                Text[3] := PurchInvHeader."Ship-to Address 2" + ' ';
                                Text[3] += PurchInvHeader."Ship-to City" + ' ' + PurchInvHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if PurchInvHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Cust."Fax No.";
                                Text[5] := PurchInvHeader."Ship-to Contact";

                            END;
                    end;
                    Text[10] := PurchInvHeader."VAT Registration No.";
                    if (PurchInvHeader."NCT VAT Branch Code" <> '') AND (NOT PurchInvHeader."NCT Head Office") then begin
                        if not VendBranch.GET(VendBranch."Source Type"::Vendor, PurchInvHeader."Buy-from Vendor No.", PurchInvHeader."NCT Head Office", PurchInvHeader."NCT VAT Branch Code") then
                            VendBranch.Init();
                        Text[10] := VendBranch."VAT Registration No.";
                    end;
                    if PurchInvHeader."Currency Code" = '' then begin
                        if PurchInvHeader."NCT Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            if PurchInvHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + PurchInvHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (สำนักงานใหญ่)';
                    end else
                        if PurchInvHeader."NCT Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            if PurchInvHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + PurchInvHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (Head Office)';
                END;
            DocumentType::"Posted Credit Memo":
                BEGIN
                    PurchCrMemoHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Vend.GET(PurchCrMemoHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := PurchCrMemoHeader."Buy-from Vendor Name" + ' ' + PurchCrMemoHeader."Buy-from Vendor Name 2";
                                Text[2] := PurchCrMemoHeader."Buy-from Address" + ' ';
                                Text[3] := PurchCrMemoHeader."Buy-from Address 2" + ' ';
                                Text[3] += PurchCrMemoHeader."Buy-from City" + ' ' + PurchCrMemoHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchCrMemoHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := PurchCrMemoHeader."Buy-from Contact";
                                Text[9] := PurchCrMemoHeader."Buy-from Vendor No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(PurchCrMemoHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT();
                                Text[1] := PurchCrMemoHeader."Pay-to Name" + ' ' + PurchCrMemoHeader."Pay-to Name 2";
                                Text[2] := PurchCrMemoHeader."Pay-to Address" + ' ';
                                Text[3] := PurchCrMemoHeader."Pay-to Address 2" + ' ';
                                Text[3] += PurchCrMemoHeader."Pay-to City" + ' ' + PurchCrMemoHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchCrMemoHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Vend."Fax No.";

                                end else

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Vend."Fax No.";
                                Text[5] := PurchCrMemoHeader."Pay-to Contact";
                                Text[9] := PurchCrMemoHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(PurchCrMemoHeader."Sell-to Customer No.") THEN
                                    Cust.init();
                                Text[1] := PurchCrMemoHeader."Ship-to Name" + ' ' + PurchCrMemoHeader."Ship-to Name 2";
                                Text[2] := PurchCrMemoHeader."Ship-to Address" + ' ';
                                Text[3] := PurchCrMemoHeader."Ship-to Address 2" + ' ';
                                Text[3] += PurchCrMemoHeader."Ship-to City" + ' ' + PurchCrMemoHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if PurchCrMemoHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Cust."Fax No.";
                                Text[5] := PurchCrMemoHeader."Ship-to Contact";

                            END;
                    END;
                    Text[10] := PurchCrMemoHeader."VAT Registration No.";
                    if (PurchCrMemoHeader."NCT VAT Branch Code" <> '') AND (NOT PurchCrMemoHeader."NCT Head Office") then begin
                        if not VendBranch.GET(VendBranch."Source Type"::Vendor, PurchCrMemoHeader."Buy-from Vendor No.", PurchCrMemoHeader."NCT Head Office", PurchCrMemoHeader."NCT VAT Branch Code") then
                            VendBranch.Init();
                        Text[10] := VendBranch."VAT Registration No.";
                    end;
                    if PurchCrMemoHeader."Currency Code" = '' then begin
                        if PurchCrMemoHeader."NCT Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            if PurchCrMemoHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + PurchCrMemoHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (สำนักงานใหญ่)';
                    end else
                        if PurchCrMemoHeader."NCT Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            if PurchCrMemoHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + PurchCrMemoHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (Head Office)';
                end;

        END;
    end;

    /// <summary>
    /// SalesPostedCustomerInformation.
    /// </summary>
    /// <param name="DocumentType">Option Shipment,"Return Receipt","Posted Invoice","Posted Credit Memo".</param>
    /// <param name="DocumentNo">Code[20].</param>
    /// <param name="VAR Text">ARRAY[10] OF Text[250].</param>
    /// <param name="Tab">Option General,Invoicing,Shipping.</param>
    procedure SalesPostedCustomerInformation(DocumentType: Option Shipment,"Return Receipt","Posted Invoice","Posted Credit Memo"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Shipto: Record "Ship-to Address";
        Cust: Record Customer;
        CustBranch: Record "NCT Customer & Vendor Branch";

    begin
        CLEAR(Text);
        CASE DocumentType OF
            DocumentType::Shipment:
                BEGIN
                    SalesShptHeader.GET(DocumentNo);
                    CASE Tab OF

                        Tab::General:
                            BEGIN
                                //  if SalesShptHeader."Head Office" then begin
                                IF NOT Cust.GET(SalesShptHeader."Sell-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := SalesShptHeader."Sell-to Customer Name" + ' ' + SalesShptHeader."Sell-to Customer Name 2";
                                Text[2] := SalesShptHeader."Sell-to Address" + ' ';
                                Text[3] := SalesShptHeader."Sell-to Address 2" + ' ';
                                Text[3] += SalesShptHeader."Sell-to City" + ' ' + SalesShptHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesShptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Cust."Fax No.";
                                Text[5] := SalesShptHeader."Sell-to Contact";

                                if (SalesShptHeader."NCT VAT Branch Code" <> '') AND (NOT SalesShptHeader."NCT Head Office") then begin
                                    if not CustBranch.GET(CustBranch."Source Type"::customer, SalesShptHeader."Sell-to Customer No.", SalesShptHeader."NCT Head Office", SalesShptHeader."NCT VAT Branch Code") then
                                        CustBranch.Init();
                                    Text[1] := CustBranch."Name";
                                    Text[2] := CustBranch."Address";
                                    Text[3] := CustBranch."Province" + ' ' + CustBranch."Post Code";
                                    Text[4] := CustBranch."Phone No." + ' ';
                                    if SalesShptHeader."Currency Code" = '' then begin
                                        IF CustBranch."Fax No." <> '' THEN
                                            Text[4] += 'แฟกซ์ : ' + CustBranch."Fax No.";
                                    end else
                                        IF CustBranch."Fax No." <> '' THEN
                                            Text[4] += 'Fax. : ' + CustBranch."Fax No.";

                                end;

                                Text[9] := SalesShptHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(SalesShptHeader."Bill-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := SalesShptHeader."Bill-to Name" + ' ' + SalesShptHeader."Bill-to Name 2";
                                Text[2] := SalesShptHeader."Bill-to Address" + ' ';
                                Text[3] := SalesShptHeader."Bill-to Address 2" + ' ';
                                Text[3] += SalesShptHeader."Bill-to City" + ' ' + SalesShptHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesShptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";
                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Cust."Fax No.";
                                Text[5] := SalesShptHeader."Bill-to Contact";
                                Text[9] := SalesShptHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(SalesShptHeader."Sell-to Customer No.", SalesShptHeader."Ship-to Code") THEN
                                    Shipto.INIT();

                                Text[1] := SalesShptHeader."Ship-to Name" + ' ' + SalesShptHeader."Ship-to Name 2";
                                Text[2] := SalesShptHeader."Ship-to Address" + ' ';
                                Text[3] := SalesShptHeader."Ship-to Address 2" + ' ';
                                Text[3] += SalesShptHeader."Ship-to City" + ' ' + SalesShptHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if SalesShptHeader."Currency Code" = '' then begin

                                    IF Shipto."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Shipto."Fax No.";

                                end else

                                    IF Shipto."Fax No." <> '' THEN
                                        Text[4] += 'Fax. : ' + Shipto."Fax No.";
                                Text[5] := SalesShptHeader."Ship-to Contact";

                            END;
                    end;
                    //  if SalesShptHeader."Head Office" then
                    Text[10] := SalesShptHeader."VAT Registration No.";
                    if (SalesShptHeader."NCT VAT Branch Code" <> '') AND (NOT SalesShptHeader."NCT Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::customer, SalesShptHeader."Sell-to Customer No.", SalesShptHeader."NCT Head Office", SalesShptHeader."NCT VAT Branch Code") then
                            CustBranch.Init();
                        Text[10] := CustBranch."VAT Registration No.";
                    end;
                    if SalesShptHeader."Currency Code" = '' then begin
                        if SalesShptHeader."NCT Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            if SalesShptHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + SalesShptHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (สำนักงานใหญ่)';
                    end else
                        if SalesShptHeader."NCT Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            if SalesShptHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + SalesShptHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (Head Office)';
                end;
            DocumentType::"Return Receipt":
                BEGIN
                    ReturnRcptHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Cust.GET(ReturnRcptHeader."Sell-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := ReturnRcptHeader."Sell-to Customer Name" + ' ' + ReturnRcptHeader."Sell-to Customer Name 2";
                                Text[2] := ReturnRcptHeader."Sell-to Address" + ' ';
                                Text[3] := ReturnRcptHeader."Sell-to Address 2" + ' ';
                                Text[3] += ReturnRcptHeader."Sell-to City" + ' ' + ReturnRcptHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if ReturnRcptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");
                                Text[5] := ReturnRcptHeader."Sell-to Contact";
                                Text[9] := ReturnRcptHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(ReturnRcptHeader."Bill-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := ReturnRcptHeader."Bill-to Name" + ' ' + ReturnRcptHeader."Bill-to Name 2";
                                Text[2] := ReturnRcptHeader."Bill-to Address" + ' ';
                                Text[3] := ReturnRcptHeader."Bill-to Address 2" + ' ';
                                Text[3] += ReturnRcptHeader."Bill-to City" + ' ' + ReturnRcptHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if ReturnRcptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += 'แฟกซ์ : ' + Cust."Fax No.";

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");
                                Text[5] := ReturnRcptHeader."Bill-to Contact";
                                Text[9] := ReturnRcptHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(ReturnRcptHeader."Sell-to Customer No.", ReturnRcptHeader."Ship-to Code") THEN
                                    Shipto.INIT();

                                Text[1] := ReturnRcptHeader."Ship-to Name" + ' ' + ReturnRcptHeader."Ship-to Name 2";
                                Text[2] := ReturnRcptHeader."Ship-to Address" + ' ';
                                Text[3] := ReturnRcptHeader."Ship-to Address 2" + ' ';
                                Text[3] += ReturnRcptHeader."Ship-to City" + ' ' + ReturnRcptHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if ReturnRcptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");
                                Text[5] := ReturnRcptHeader."Ship-to Contact";

                            END;
                    end;
                end;
            DocumentType::"Posted Invoice":
                BEGIN
                    SalesInvHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Cust.GET(SalesInvHeader."Sell-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := SalesInvHeader."Sell-to Customer Name" + ' ' + SalesInvHeader."Sell-to Customer Name 2";
                                Text[2] := SalesInvHeader."Sell-to Address" + ' ';
                                Text[3] := SalesInvHeader."Sell-to Address 2" + ' ';
                                Text[3] += SalesInvHeader."Sell-to City" + ' ' + SalesInvHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesInvHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");
                                Text[5] := SalesInvHeader."Sell-to Contact";
                                Text[9] := SalesInvHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(SalesInvHeader."Bill-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := SalesInvHeader."Bill-to Name" + ' ' + SalesInvHeader."Bill-to Name 2";
                                Text[2] := SalesInvHeader."Bill-to Address" + ' ';
                                Text[3] := SalesInvHeader."Bill-to Address 2" + ' ';
                                Text[3] += SalesInvHeader."Bill-to City" + ' ' + SalesInvHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesInvHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");
                                Text[5] := SalesInvHeader."Bill-to Contact";
                                Text[9] := SalesInvHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(SalesInvHeader."Sell-to Customer No.", SalesInvHeader."Ship-to Code") THEN
                                    Shipto.INIT();

                                Text[1] := SalesInvHeader."Ship-to Name" + ' ' + SalesInvHeader."Ship-to Name 2";
                                Text[2] := SalesInvHeader."Ship-to Address" + ' ';
                                Text[3] := SalesInvHeader."Ship-to Address 2" + ' ';
                                Text[3] += SalesInvHeader."Ship-to City" + ' ' + SalesInvHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if SalesInvHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");
                                Text[5] := SalesInvHeader."Ship-to Contact";

                            END;
                    end;
                    Text[10] := SalesInvHeader."VAT Registration No.";
                    if (SalesInvHeader."NCT VAT Branch Code" <> '') AND (NOT SalesInvHeader."NCT Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::customer, SalesInvHeader."Sell-to Customer No.", SalesInvHeader."NCT Head Office", SalesInvHeader."NCT VAT Branch Code") then
                            CustBranch.Init();
                        Text[10] := CustBranch."VAT Registration No.";
                    end;
                    if SalesInvHeader."Currency Code" = '' then begin
                        if SalesInvHeader."NCT Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            if SalesInvHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + SalesInvHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (สำนักงานใหญ่)';
                    end else
                        if SalesInvHeader."NCT Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            if SalesInvHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + SalesInvHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (Head Office)';
                end;
            DocumentType::"Posted Credit Memo":
                BEGIN
                    SalesCrMemoHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Cust.GET(SalesCrMemoHeader."Sell-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := SalesCrMemoHeader."Sell-to Customer Name" + ' ' + SalesCrMemoHeader."Sell-to Customer Name 2";
                                Text[2] := SalesCrMemoHeader."Sell-to Address" + ' ';
                                Text[3] := SalesCrMemoHeader."Sell-to Address 2" + ' ';
                                Text[3] += SalesCrMemoHeader."Sell-to City" + ' ' + SalesCrMemoHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesCrMemoHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");
                                Text[5] := SalesCrMemoHeader."Sell-to Contact";
                                Text[9] := SalesCrMemoHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(SalesCrMemoHeader."Bill-to Customer No.") THEN
                                    Cust.INIT();
                                Text[1] := SalesCrMemoHeader."Bill-to Name" + ' ' + SalesCrMemoHeader."Bill-to Name 2";
                                Text[2] := SalesCrMemoHeader."Bill-to Address" + ' ';
                                Text[3] := SalesCrMemoHeader."Bill-to Address 2" + ' ';
                                Text[3] += SalesCrMemoHeader."Bill-to City" + ' ' + SalesCrMemoHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesCrMemoHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");
                                Text[5] := SalesCrMemoHeader."Bill-to Contact";
                                Text[9] := SalesCrMemoHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."Ship-to Code") THEN
                                    Shipto.INIT();

                                Text[1] := SalesCrMemoHeader."Ship-to Name" + ' ' + SalesCrMemoHeader."Ship-to Name 2";
                                Text[2] := SalesCrMemoHeader."Ship-to Address" + ' ';
                                Text[3] := SalesCrMemoHeader."Ship-to Address 2" + ' ';
                                Text[3] += SalesCrMemoHeader."Ship-to City" + ' ' + SalesCrMemoHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if SalesCrMemoHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                                end else

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");
                                Text[5] := SalesCrMemoHeader."Ship-to Contact";

                            END;
                    end;
                    Text[10] := SalesCrMemoHeader."VAT Registration No.";
                    if (SalesCrMemoHeader."NCT VAT Branch Code" <> '') AND (NOT SalesCrMemoHeader."NCT Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::customer, SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."NCT Head Office", SalesCrMemoHeader."NCT VAT Branch Code") then
                            CustBranch.Init();
                        Text[10] := CustBranch."VAT Registration No.";
                    end;
                    if SalesCrMemoHeader."Currency Code" = '' then begin
                        if SalesCrMemoHeader."NCT Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            if SalesCrMemoHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + SalesCrMemoHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (สำนักงานใหญ่)';
                    end else
                        if SalesCrMemoHeader."NCT Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            if SalesCrMemoHeader."NCT VAT Branch Code" <> '' then
                                Text[10] += ' (' + SalesCrMemoHeader."NCT VAT Branch Code" + ')'
                            else
                                Text[10] += ' (Head Office)';
                end;
        end;


    end;




    // end;
    /// <summary>
    /// GetName.
    /// </summary>
    /// <param name="Var_Name">Text[250].</param>
    /// <returns>Return variable Name of type Text[50].</returns>
    procedure "GetName"(Var_Name: Text[250]) Name: Text[50]
    var
        Pos: Integer;
    begin
        Name := Var_Name;
        Pos := STRPOS(Name, '\');
        WHILE Pos > 0 DO BEGIN
            Name := COPYSTR(Name, Pos + 1);
            Pos := STRPOS(Name, '\')
        END;
    end;
    /// <summary>
    /// GetNameFAClass.
    /// </summary>
    /// <param name="pCode">Code[10].</param>
    /// <returns>Return value of type Text[50].</returns>
    procedure "GetNameFAClass"(pCode: Code[10]): Text[50]
    var
        FaClass: Record "FA Class";
    begin
        IF FAClass.GET(pCode) THEN
            EXIT(FAClass.Name)
        ELSE
            EXIT('*****');
    end;
    /// <summary>
    /// GetNameFASubClass.
    /// </summary>
    /// <param name="pCode">Code[10].</param>
    /// <returns>Return value of type Text[50].</returns>
    procedure "GetNameFASubClass"(pCode: Code[10]): Text[50]
    var
        FASubclass: Record "FA Subclass";
    begin
        IF FASubclass.GET(pCode) THEN
            EXIT(FASubclass.Name)
        ELSE
            EXIT('*****');
    end;
    /// <summary>
    /// GetNameFALocation.
    /// </summary>
    /// <param name="pCode">Code[10].</param>
    /// <returns>Return value of type Text[50].</returns>
    procedure "GetNameFALocation"(pCode: Code[10]): Text[50]
    var
        FALocation: Record "FA Location";
    begin
        IF FALocation.GET(pCode) THEN
            EXIT(FALocation.Name)
        ELSE
            EXIT('*****');
    end;

    local procedure "CustInvDiscRecExists"(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SETRANGE(Code, InvDiscCode);
        EXIT(CustInvDisc.FindFirst());
    end;

    local procedure "VendInvDiscRecExists"(InvDiscCode: Code[20]): Boolean
    var
        VendInvDisc: Record "Vendor Invoice Disc.";
    begin
        VendInvDisc.SETRANGE(Code, InvDiscCode);
        EXIT(VendInvDisc.FindFirst());
    end;


    /// <summary>
    /// InsertDimensionEntry.
    /// </summary>
    /// <param name="DimensionSetID">VAR Integer.</param>
    /// <param name="DimCode">code[30].</param>
    /// <param name="Dimvalue">code[30].</param>
    procedure InsertDimensionEntry(var DimensionSetID: Integer; DimCode: code[30]; Dimvalue: code[30])
    var
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, DimensionSetID);

        TempDimSetEntry.reset();
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if TempDimSetEntry.FindFirst() then
            TempDimSetEntry.Delete();

        if (Dimvalue <> '') and (DimCode <> '') then begin
            TempDimSetEntry.init();
            TempDimSetEntry."Dimension Set ID" := DimensionSetID;
            TempDimSetEntry.validate("Dimension Code", DimCode);
            TempDimSetEntry.Insert(true);
            TempDimSetEntry.Validate("Dimension Value Code", Dimvalue);
            TempDimSetEntry.Modify();
        end;
        TempDimSetEntry.reset();
        DimensionSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

    end;
    /// <summary>
    /// SaveDimensionDefault.
    /// </summary>
    /// <param name="TableID">Integer.</param>
    /// <param name="MyNo">Code[30].</param>
    /// <param name="DimCode">Code[30].</param>
    /// <param name="DimValue">Code[30].</param>
    procedure SaveDimensionDefault(TableID: Integer; MyNo: Code[30]; DimCode: Code[30]; DimValue: Code[30])
    var
        DimensionDefault: record "Default Dimension";
    begin
        DimensionDefault.reset();
        DimensionDefault.SetRange("Table ID", TableID);
        DimensionDefault.SetRange("No.", MyNo);
        DimensionDefault.SetRange("Dimension Code", DimCode);
        if DimensionDefault.FindFirst() then
            DimensionDefault.Delete(true);

        if (DimCode <> '') and (DimValue <> '') then begin
            DimensionDefault.init();
            DimensionDefault.validate("Table ID", TableID);
            DimensionDefault.Validate("No.", MyNo);
            DimensionDefault.Validate("Dimension Code", DimCode);
            DimensionDefault.Insert(true);
            DimensionDefault.Validate("Dimension Value Code", DimValue);
            DimensionDefault.Modify();
        end;

    end;
    /// <summary>
    /// GetMonthNameEng.
    /// </summary>
    /// <param name="MonthNumber">Integer.</param>
    /// <returns>Return value of type Text[50].</returns>
    procedure GetMonthNameEng(MonthNumber: Integer): Text[50];
    begin
        case MonthNumber of
            1:
                exit('Jan');
            2:
                exit('Feb');
            3:
                exit('Mar');
            4:
                exit('Apr');
            5:
                exit('May');
            6:
                exit('Jun');
            7:
                exit('Jul');
            8:
                exit('Aug');
            9:
                exit('Sep');
            10:
                exit('Oct');
            11:
                exit('Nov');
            12:
                exit('Dec');
            else
                exit('');
        end;
    end;
    /// <summary>
    /// GetMonthFullNameEng.
    /// </summary>
    /// <param name="MonthNumber">Integer.</param>
    /// <returns>Return value of type Text[50].</returns>
    procedure GetMonthFullNameEng(MonthNumber: Integer): Text[50];
    begin
        case MonthNumber of
            1:
                exit('January');
            2:
                exit('February');
            3:
                exit('March');
            4:
                exit('April');
            5:
                exit('May');
            6:
                exit('June');
            7:
                exit('July');
            8:
                exit('August');
            9:
                exit('September');
            10:
                exit('October');
            11:
                exit('November');
            12:
                exit('December');
            else
                exit('');
        end;
    end;





    /// <summary>
    /// RereleaseBilling.
    /// </summary>
    /// <param name="BillingHeader">Record "NCT Billing Receipt Header".</param>
    procedure RereleaseBilling(BillingHeader: Record "NCT Billing Receipt Header")

    begin
        IF BillingHeader."Status" IN [BillingHeader."Status"::Released, BillingHeader.Status::"Created to Journal", BillingHeader.Status::Posted] THEN
            EXIT;
        BillingHeader.CheckBeforRelease();
        BillingHeader.TESTFIELD("Bill/Pay-to Cust/Vend No.");
        BillingLine.RESET();
        BillingLine.SETRANGE("Document Type", BillingHeader."Document Type");
        BillingLine.SETRANGE("Document No.", BillingHeader."No.");
        IF NOT BillingLine.FindFirst() THEN
            ERROR(Text001Msg, BillingHeader."Document Type", BillingHeader."No.");

        BillingHeader."Status" := BillingHeader."Status"::Released;
        BillingHeader.MODIFY();
    end;
    /// <summary>
    /// ReopenBilling.
    /// </summary>
    /// <param name="BillingHeader">Record "NCT Billing Receipt Header".</param>
    procedure "ReopenBilling"(BillingHeader: Record "NCT Billing Receipt Header")
    begin
        //  WITH BillingHeader DO BEGIN
        IF BillingHeader."Status" in [BillingHeader."Status"::Open, BillingHeader.Status::"Created to Journal", BillingHeader.Status::Posted] THEN
            EXIT;
        BillingHeader.CheckbeforReOpen();
        BillingHeader."Status" := BillingHeader."Status"::Open;
        BillingHeader.MODIFY();
        //   END;
    end;


    [IntegrationEvent(false, false)]
    local procedure BeforSetPurchaseGLEntry(var Ishandle: Boolean; PurchaseHeader: Record "Purchase Header"; pGroupping: boolean; var pTotalAmt: Decimal; var FromTempGLEntry: Record "G/L Entry" temporary; var ToTempGLEntry: Record "G/L Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure BeforSetSalesGLEntry(var Ishandle: Boolean; SalesHeader: Record "Sales Header"; pGroupping: boolean; var pTotalAmt: Decimal; var FromTempGLEntry: Record "G/L Entry" temporary; var ToTempGLEntry: Record "G/L Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure BeforSetGenLineGLEntry(var Ishandle: Boolean; GenLines: Record "Gen. Journal Line"; pGroupping: boolean; var pTotalAmt: Decimal; var FromTempGLEntry: Record "G/L Entry" temporary; var ToTempGLEntry: Record "G/L Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure BeforSetPostedGLEntry(var Ishandle: Boolean; pDocumentNo: code[30]; pPostingDate: Date; pGroupping: boolean; var pTotalAmt: Decimal; var ToTempGLEntry: Record "G/L Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCompanyInfor(pCompany: Record "Company Information"; VAR pText: ARRAY[10] OF Text[250]; pEngName: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCompanyInforByVat(VAR pText: ARRAY[10] OF Text[250]; pVatBus: code[20]; pEngName: Boolean)
    begin
    end;



    var
        BillingLine: Record "NCT Billing Receipt Line";
        Text001Msg: Label 'There is nothing to release for %1 %2.', Locked = true;

        Text002Msg: Label 'VAT %1%', MaxLength = 1024, Locked = true;
        OnesText: array[20] of text[50];
        TensText: array[10] of Text[50];
        ExponentText: array[5] of text[50];
        TempCurrencyPointInterger: array[20] of Integer;

}