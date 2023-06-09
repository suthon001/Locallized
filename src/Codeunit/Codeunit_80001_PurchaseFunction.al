/// <summary>
/// Codeunit NCT Purchase Function (ID 80001).
/// </summary>
codeunit 80001 "NCT Purchase Function"
{
    EventSubscriberInstance = StaticAutomatic;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnFinalizePostingOnBeforeUpdateAfterPosting', '', false, false)]
    local procedure OnFinalizePostingOnBeforeUpdateAfterPosting(var PurchHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        WHTAppEntry: Record "NCT WHT Applied Entry";
        LastLineNo: Integer;
    begin
        LastLineNo := 0;

        if PurchHeader."Document Type" in [PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo"] then begin

            PurchaseLine.reset();
            PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
            PurchaseLine.SetRange("Document No.", PurchHeader."No.");
            PurchaseLine.SetFilter("NCT WHT %", '<>%1', 0);
            OnbeforInsertWHTAPPLY(PurchHeader, PurchaseLine);
            if PurchaseLine.FindSet() then
                repeat
                    LastLineNo := LastLineNo + 10000;
                    WHTAppEntry.init();
                    WHTAppEntry."Document No." := PurchaseLine."Document No.";
                    WHTAppEntry."Document Line No." := PurchaseLine."Line No.";
                    WHTAppEntry."Entry Type" := WHTAppEntry."Entry Type"::Initial;
                    WHTAppEntry."Line No." := LastLineNo;
                    WHTAppEntry."WHT Bus. Posting Group" := PurchaseLine."NCT WHT Business Posting Group";
                    WHTAppEntry."WHT Prod. Posting Group" := PurchaseLine."NCT WHT Product Posting Group";
                    WHTAppEntry.Description := PurchaseLine.Description;
                    WHTAppEntry."WHT %" := PurchaseLine."NCT WHT %";
                    WHTAppEntry."WHT Base" := PurchaseLine."NCT WHT Base";
                    WHTAppEntry."WHT Amount" := PurchaseLine."NCT WHT Amount";
                    WHTAppEntry."WHT Name" := PurchHeader."Buy-from Vendor Name";
                    WHTAppEntry."WHT Name 2" := PurchHeader."Buy-from Vendor Name 2";
                    WHTAppEntry."WHT Address" := PurchHeader."Buy-from Address";
                    WHTAppEntry."WHT Address 2" := PurchHeader."Buy-from Address 2";
                    WHTAppEntry."WHT City" := PurchHeader."Buy-from City";
                    WHTAppEntry."VAT Registration No." := PurchHeader."VAT Registration No.";
                    WHTAppEntry."WHT Option" := PurchaseLine."NCT WHT Option";
                    WHTAppEntry."Branch Code" := PurchHeader."NCT Branch Code";
                    WHTAppEntry."Head Office" := PurchHeader."NCT Head Office";
                    WHTAppEntry."WHT Post Code" := PurchHeader."Buy-from Post Code";
                    WHTAppEntry.Insert(true);
                until PurchaseLine.Next() = 0;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInitFromPurchLine', '', True, True)]
    local procedure "OnAfterInitFromPurchaseLine"(PurchLine: Record "Purchase Line"; PurchInvHeader: Record "Purch. Inv. Header"; var PurchInvLine: Record "Purch. Inv. Line")
    var
        FaDepBook: Record "FA Depreciation Book";
    begin
        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
            FaDepBook.reset();
            FaDepBook.SetRange("FA No.", PurchLine."No.");
            if FaDepBook.FindFirst() then begin
                FaDepBook.Validate("Depreciation Starting Date", PurchInvHeader."Posting Date");
                FaDepBook.Modify();
            end;

        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnAfterInsertPurchOrderLine', '', false, false)]
    local procedure OnAfterInsertPurchOrderLine(var PurchaseQuoteLine: Record "Purchase Line")
    begin
        PurchaseQuoteLine."Outstanding Qty. (Base)" := 0;
        PurchaseQuoteLine."Outstanding Quantity" := 0;
        PurchaseQuoteLine.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeInsertPurchOrderLine', '', false, false)]
    local procedure OnBeforeInsertPurchOrderLine(PurchQuoteLine: Record "Purchase Line"; var PurchOrderLine: Record "Purchase Line")
    begin
        PurchOrderLine."NCT Ref. PQ No." := PurchQuoteLine."Document No.";
        PurchOrderLine."NCT Ref. PQ Line No." := PurchQuoteLine."Line No.";
        PurchOrderLine."NCT Make Order By" := COPYSTR(UserId, 1, 50);
        PurchOrderLine."NCT Make Order DateTime" := CurrentDateTime;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    /// <summary> 
    /// Description for OnBeforConfirmPurchasePost.
    /// </summary>
    /// <param name="DefaultOption">Parameter of type Integer.</param>
    /// <param name="HideDialog">Parameter of type Boolean.</param>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    local procedure "OnBeforConfirmPurchasePost"(var DefaultOption: Integer; var HideDialog: Boolean; var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        Handle: Boolean;
        ConfirmMsg: Label 'Do you want to Post %1 ?', Locked = true;
    begin
        Handle := true;
        HandleMessagebeforPostPurchase(Handle);
        if Handle then begin
            if not Confirm(strsubstno(ConfirmMsg, format(PurchaseHeader."Document Type"))) then
                IsHandled := true;


            if not IsHandled then begin
                HideDialog := true;
                if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
                    PurchaseHeader.Receive := true;
                    PurchaseHeader.Invoice := false;
                    DefaultOption := 1;
                end;
                if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then begin
                    PurchaseHeader.Receive := false;
                    PurchaseHeader.Invoice := true;
                    DefaultOption := 2;
                end;
                if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order" then begin
                    PurchaseHeader.Ship := true;
                    PurchaseHeader.Invoice := false;
                    DefaultOption := 1;
                end;
            end else
                HideDialog := false;
        end;
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterInsertLines', '', true, true)]
    local procedure "OnAfterInsertLines"(var PurchHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        ReceiptHeader: Record "Purch. Rcpt. Header";
    begin
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchHeader."No.");
        PurchaseLine.SetFilter("Receipt No.", '<>%1', '');
        if PurchaseLine.FindFirst() then begin
            ReceiptHeader.get(PurchaseLine."Receipt No.");
            PurchHeader."Vendor Invoice No." := ReceiptHeader."Vendor Shipment No.";
            PurchHeader.Modify();
        end;
    end;



    [IntegrationEvent(false, false)]
    local procedure HandleMessagebeforPostPurchase(var Handle: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure "OnAfterInitOutstandingQty"(var PurchaseLine: Record "Purchase Line")
    begin
        if PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Quote, PurchaseLine."Document Type"::Order] then begin
            PurchaseLine."Outstanding Quantity" := PurchaseLine.Quantity - PurchaseLine."Quantity Received" - PurchaseLine."NCT Qty. to Cancel";
            PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine."Quantity (Base)" - PurchaseLine."Qty. Received (Base)" - PurchaseLine."NCT Qty. to Cancel (Base)";
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPreparePurchase', '', true, true)]
    local procedure "InvoiceBufferPurchase"(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var PurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        VendCust: Record "NCT Customer & Vendor Branch";
        Vend: Record Vendor;
    begin
        //with InvoicePostBuffer do begin

        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        Vend.GET(PurchHeader."Buy-from Vendor No.");
        PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");

        InvoicePostingBuffer."NCT Tax Vendor No." := PurchHeader."Pay-to Vendor No.";
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            InvoicePostingBuffer."NCT Tax Invoice No." := PurchHeader."Vendor Invoice No."
        else
            InvoicePostingBuffer."NCT Tax Invoice No." := PurchHeader."Vendor Cr. Memo No.";
        InvoicePostingBuffer."NCT VAT Registration No." := PurchHeader."VAT Registration No.";
        if InvoicePostingBuffer."NCT VAT Registration No." = '' then
            InvoicePostingBuffer."NCT VAT Registration No." := Vend."VAT Registration No.";
        InvoicePostingBuffer."NCT Head Office" := PurchHeader."NCT Head Office";
        InvoicePostingBuffer."NCT Branch Code" := PurchHeader."NCT Branch Code";
        InvoicePostingBuffer."NCT Tax Invoice Date" := PurchHeader."Document Date";
        InvoicePostingBuffer."NCT Tax Invoice Name" := PurchHeader."Buy-from Vendor Name";
        InvoicePostingBuffer."NCT Tax Invoice Name 2" := PurchHeader."Buy-from Vendor Name 2";
        InvoicePostingBuffer."NCT Address" := PurchHeader."Buy-from Address";
        InvoicePostingBuffer."NCT Address 2" := PurchHeader."Buy-from Address 2";
        InvoicePostingBuffer."NCT city" := PurchHeader."Buy-from city";
        InvoicePostingBuffer."NCT Post Code" := PurchHeader."Buy-from Post Code";
        InvoicePostingBuffer."NCT Document Line No." := PurchaseLine."Line No.";

        if VendCust.Get(VendCust."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."NCT Head Office", PurchHeader."NCT Branch Code") then begin
            if VendCust."Title Name" <> VendCust."Title Name"::" " then
                InvoicePostingBuffer."NCT Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
            else
                InvoicePostingBuffer."NCT Tax Invoice Name" := VendCust."Name";
            InvoicePostingBuffer."NCT Address" := VendCust."Address";
            InvoicePostingBuffer."NCT Address 2" := VendCust."Address 2";
            InvoicePostingBuffer."NCT city" := VendCust."Province";
            InvoicePostingBuffer."NCT Post Code" := VendCust."Post Code";
        end;
        InvoicePostingBuffer."NCT Description Line" := PurchaseLine.Description;
        InvoicePostingBuffer."NCT Tax Invoice Base" := PurchaseLine.Amount;
        InvoicePostingBuffer."NCT Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
        IF PurchaseLine."NCT Tax Invoice No." <> '' THEN BEGIN
            InvoicePostingBuffer."NCT Tax Vendor No." := PurchaseLine."NCT Tax Vendor No.";
            InvoicePostingBuffer."NCT Head Office" := PurchaseLine."NCT Head Office";
            InvoicePostingBuffer."NCT Branch Code" := PurchaseLine."NCT Branch Code";
            InvoicePostingBuffer."NCT Tax Invoice No." := PurchaseLine."NCT Tax Invoice No.";
            InvoicePostingBuffer."Additional Grouping Identifier" := PurchaseLine."NCT Tax Invoice No.";
            InvoicePostingBuffer."NCT Tax Invoice Date" := PurchaseLine."NCT Tax Invoice Date";
            InvoicePostingBuffer."NCT Tax Invoice Name" := PurchaseLine."NCT Tax Invoice Name";
            InvoicePostingBuffer."NCT Tax Invoice Name 2" := PurchaseLine."NCT Tax Invoice Name 2";
            IF InvoicePostingBuffer."VAT %" <> 0 THEN BEGIN
                InvoicePostingBuffer."NCT Tax Invoice Base" := PurchaseLine.Amount;
                InvoicePostingBuffer."NCT Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                if PurchaseLine."NCT Tax Invoice Base" <> 0 then begin
                    InvoicePostingBuffer."NCT Tax Invoice Base" := PurchaseLine."NCT Tax Invoice Base";
                    InvoicePostingBuffer."NCT Tax Invoice Amount" := PurchaseLine."NCT Tax Invoice Amount";
                end;
            END ELSE begin
                InvoicePostingBuffer."NCT Tax Invoice Base" := PurchaseLine."NCT Tax Invoice Base";
                InvoicePostingBuffer."NCT Tax Invoice Amount" := PurchaseLine."Line Amount";
            end;
        END;

        IF PurchaseLine."NCT VAT Registration No." <> '' THEN
            InvoicePostingBuffer."NCT VAT Registration No." := PurchaseLine."NCT VAT Registration No."
        ELSE
            InvoicePostingBuffer."NCT VAT Registration No." := PurchHeader."VAT Registration No.";

        IF (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"G/L Account") OR (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"Fixed Asset") THEN
            InvoicePostingBuffer."NCT Line No." := PurchaseLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure "OnAfterInvPostBufferPreparePurchase"(var InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var PurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        VendCust: Record "NCT Customer & Vendor Branch";
        Vend: Record Vendor;
    begin
        //with InvoicePostBuffer do begin

        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");
        Vend.GET(PurchHeader."Buy-from Vendor No.");
        InvoicePostBuffer."NCT Tax Vendor No." := PurchHeader."Pay-to Vendor No.";
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            InvoicePostBuffer."NCT Tax Invoice No." := PurchHeader."Vendor Invoice No."
        else
            InvoicePostBuffer."NCT Tax Invoice No." := PurchHeader."Vendor Cr. Memo No.";
        InvoicePostBuffer."NCT Tax Vendor No." := PurchHeader."Pay-to Vendor No.";
        InvoicePostBuffer."NCT VAT Registration No." := PurchHeader."VAT Registration No.";
        if InvoicePostBuffer."NCT VAT Registration No." = '' then
            InvoicePostBuffer."NCT VAT Registration No." := Vend."VAT Registration No.";
        InvoicePostBuffer."NCT Head Office" := PurchHeader."NCT Head Office";
        InvoicePostBuffer."NCT Branch Code" := PurchHeader."NCT Branch Code";
        InvoicePostBuffer."NCT Tax Invoice Date" := PurchHeader."Document Date";
        InvoicePostBuffer."NCT Tax Invoice Name" := PurchHeader."Pay-to Name";
        InvoicePostBuffer."NCT Tax Invoice Name 2" := PurchHeader."Pay-to Name 2";
        InvoicePostBuffer."NCT Address" := PurchHeader."Buy-from Address";
        InvoicePostBuffer."NCT Address 2" := PurchHeader."Buy-from Address 2";
        InvoicePostBuffer."NCT city" := PurchHeader."Buy-from city";
        InvoicePostBuffer."NCT Post Code" := PurchHeader."Buy-from Post Code";
        InvoicePostBuffer."NCT Document Line No." := PurchaseLine."Line No.";
        if VendCust.Get(VendCust."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."NCT Head Office", PurchHeader."NCT Branch Code") then begin
            if VendCust."Title Name" <> VendCust."Title Name"::" " then
                InvoicePostBuffer."NCT Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
            else
                InvoicePostBuffer."NCT Tax Invoice Name" := VendCust."Name";
            InvoicePostBuffer."NCT Address" := VendCust."Address";
            InvoicePostBuffer."NCT Address 2" := VendCust."Address 2";
            InvoicePostBuffer."NCT city" := VendCust."Province";
            InvoicePostBuffer."NCT Post Code" := VendCust."Post Code";
        end;
        InvoicePostBuffer."NCT Description Line" := PurchaseLine.Description;
        InvoicePostBuffer."NCT Tax Invoice Base" := PurchaseLine.Amount;
        InvoicePostBuffer."NCT Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
        IF PurchaseLine."NCT Tax Invoice No." <> '' THEN BEGIN
            if PurchaseLine."NCT Tax Vendor No." <> '' then
                InvoicePostBuffer."NCT Tax Vendor No." := PurchaseLine."NCT Tax Vendor No.";
            InvoicePostBuffer."NCT Head Office" := PurchaseLine."NCT Head Office";
            InvoicePostBuffer."NCT Branch Code" := PurchaseLine."NCT Branch Code";
            InvoicePostBuffer."NCT Tax Invoice No." := PurchaseLine."NCT Tax Invoice No.";
            InvoicePostBuffer."Additional Grouping Identifier" := PurchaseLine."NCT Tax Invoice No.";
            InvoicePostBuffer."NCT Tax Invoice Date" := PurchaseLine."NCT Tax Invoice Date";
            InvoicePostBuffer."NCT Tax Invoice Name" := PurchaseLine."NCT Tax Invoice Name";
            InvoicePostBuffer."NCT Tax Invoice Name 2" := PurchaseLine."NCT Tax Invoice Name 2";
            IF InvoicePostBuffer."VAT %" <> 0 THEN BEGIN
                InvoicePostBuffer."NCT Tax Invoice Base" := PurchaseLine.Amount;
                InvoicePostBuffer."NCT Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                if PurchaseLine."NCT Tax Invoice Base" <> 0 then begin
                    InvoicePostBuffer."NCT Tax Invoice Base" := PurchaseLine."NCT Tax Invoice Base";
                    InvoicePostBuffer."NCT Tax Invoice Amount" := PurchaseLine."NCT Tax Invoice Amount";
                end;
            END ELSE begin
                InvoicePostBuffer."NCT Tax Invoice Base" := PurchaseLine."NCT Tax Invoice Base";
                InvoicePostBuffer."NCT Tax Invoice Amount" := PurchaseLine."Line Amount";
            end;
        END;

        IF PurchaseLine."NCT VAT Registration No." <> '' THEN
            InvoicePostBuffer."NCT VAT Registration No." := PurchaseLine."NCT VAT Registration No."
        ELSE
            InvoicePostBuffer."NCT VAT Registration No." := PurchHeader."VAT Registration No.";

        IF (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"G/L Account") OR (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset") THEN
            InvoicePostBuffer."NCT Line No." := PurchaseLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    local procedure "OnSendPurchaseDocForApproval"(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
    begin
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("Location Code", '%1', '');
        if PurchaseLine.FindFirst() then begin
            Item.Get(PurchaseLine."No.");
            if NOT (Item.Type IN [Item.Type::Service, item.Type::"Non-Inventory"]) then
                PurchaseLine.TestField("Location Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order (Yes/No)", 'OnBeforePurchQuoteToOrder', '', false, false)]
    local procedure OnBeforePurchQuoteToOrder(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        text001Msg: Label 'this document has been order no. %1', Locked = true;
    begin
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Released);
        if PurchaseHeader."NCT Purchase Order No." <> '' then begin
            MESSAGE(StrSubstNo(text001Msg, PurchaseHeader."NCT Purchase Order No."));
            IsHandled := true;
        end;
    end;

    [BusinessEvent(false)]
    local procedure OnbeforInsertWHTAPPLY(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    begin
    end;


}