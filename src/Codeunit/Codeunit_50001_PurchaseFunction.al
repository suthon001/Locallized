codeunit 50001 "Purchase Function"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInitFromPurchLine', '', True, True)]
    local procedure "OnAfterInitFromPurchaseLine"(PurchLine: Record "Purchase Line"; PurchInvHeader: Record "Purch. Inv. Header"; var PurchInvLine: Record "Purch. Inv. Line")
    var
        FaDepBook: Record "FA Depreciation Book";
    begin
        // if PurchInvLine."Deposit Entry No." <> 0 then begin
        //     PurchInvLine."CalculateDeposit"();
        // end;
        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
            FaDepBook.reset();
            FaDepBook.SetRange("FA No.", PurchLine."No.");
            if FaDepBook.FindFirst() then begin
                FaDepBook.Validate("Depreciation Starting Date", PurchInvHeader."Posting Date");
                FaDepBook.Modify();
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeDeletePurchQuote', '', false, false)]
    local procedure OnBeforeDeletePurchQuote(var IsHandled: Boolean; var QuotePurchHeader: Record "Purchase Header"; var OrderPurchHeader: Record "Purchase Header")
    begin
        IsHandled := true;
        QuotePurchHeader."Purchase Order No." := OrderPurchHeader."No.";
        QuotePurchHeader.Modify();
        MESSAGE('Create to Document No. ' + OrderPurchHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnAfterInsertPurchOrderLine', '', false, false)]
    local procedure OnAfterInsertPurchOrderLine(var PurchaseQuoteLine: Record "Purchase Line")
    begin
        PurchaseQuoteLine."Outstanding Qty. (Base)" := 0;
        PurchaseQuoteLine."Outstanding Quantity" := 0;
        PurchaseQuoteLine."Make to PO Qty." := 0;
        PurchaseQuoteLine."Make to PO Qty. (Base)" := 0;
        PurchaseQuoteLine.Modify();
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnCreatePurchHeaderOnBeforeInitRecord', '', false, false)]
    local procedure OnCreatePurchHeaderOnBeforeInitRecord(var PurchOrderHeader: Record "Purchase Header"; var PurchHeader: Record "Purchase Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin


        PurchHeader.TestField("Make PO No.Series No.");
        NoSeriesMgt.InitSeries(PurchOrderHeader."Make PO No.Series No.", PurchHeader."Make PO No.Series No.", PurchHeader."Posting Date", PurchOrderHeader."No.", PurchOrderHeader."No. Series");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeInsertPurchOrderLine', '', false, false)]
    local procedure OnBeforeInsertPurchOrderLine(PurchQuoteLine: Record "Purchase Line"; var PurchOrderLine: Record "Purchase Line")
    begin
        PurchOrderLine."Ref. PQ No." := PurchQuoteLine."Document No.";
        PurchOrderLine."Ref. PQ Line No." := PurchQuoteLine."Line No.";
        PurchOrderLine."Make Order By" := UserId;
        PurchOrderLine."Make Order DateTime" := CurrentDateTime;
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
    begin
        Handle := true;
        "HandleMessagebeforPostPurchase"(Handle);
        if Handle then begin
            if not Confirm(strsubstno('Do you want to Post %1 ?', format(PurchaseHeader."Document Type"))) then
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
    local procedure "HandleMessagebeforPostPurchase"(var Handle: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure "OnAfterInitOutstandingQty"(var PurchaseLine: Record "Purchase Line")
    begin
        if PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Quote, PurchaseLine."Document Type"::Order] then begin
            PurchaseLine."Outstanding Quantity" := PurchaseLine.Quantity - PurchaseLine."Quantity Received" - PurchaseLine."Qty. to Cancel";
            PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine."Quantity (Base)" - PurchaseLine."Qty. Received (Base)" - PurchaseLine."Qty. to Cancel (Base)";
            PurchaseLine."Make to PO Qty." := PurchaseLine."Outstanding Quantity";
            PurchaseLine."Make to PO Qty. (Base)" := PurchaseLine."Outstanding Qty. (Base)";
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure "InvoiceBufferPurchase"(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        VendCust: Record "Customer & Vendor Branch";
    begin
        //with InvoicePostBuffer do begin

        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");
        InvoicePostBuffer."Vendor Invoice No." := PurchHeader."Vendor Invoice No.";
        InvoicePostBuffer."Tax Vendor No." := PurchHeader."Pay-to Vendor No.";
        InvoicePostBuffer."VAT Registration No." := PurchHeader."VAT Registration No.";
        InvoicePostBuffer."Head Office" := PurchHeader."Head Office";
        InvoicePostBuffer."Branch Code" := PurchHeader."Branch Code";
        InvoicePostBuffer."Tax Invoice Date" := PurchHeader."Document Date";
        InvoicePostBuffer."Tax Invoice Name" := PurchHeader."Buy-from Vendor Name" + ' ' + PurchHeader."Buy-from Vendor Name 2";
        InvoicePostBuffer."Address" := PurchHeader."Buy-from Address" + ' ' + PurchHeader."Buy-from Address 2";
        InvoicePostBuffer."city" := PurchHeader."Buy-from city";
        InvoicePostBuffer."Post Code" := PurchHeader."Buy-from Post Code";
        InvoicePostBuffer."Document Line No." := PurchaseLine."Line No.";
        if PurchHeader."Branch Code" <> '' then
            if VendCust.Get(VendCust."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."Head Office", PurchHeader."Branch Code") then begin
                if VendCust."Name" <> '' then
                    InvoicePostBuffer."Tax Invoice Name" := VendCust."Name";
                InvoicePostBuffer."Address" := VendCust."Address";
                InvoicePostBuffer."city" := VendCust."Province";
                InvoicePostBuffer."Post Code" := VendCust."Post Code";
            end;
        InvoicePostBuffer."Description Line" := PurchaseLine.Description + ' ' + PurchaseLine."Description 2";
        IF PurchaseLine."Tax Invoice No." <> '' THEN BEGIN
            InvoicePostBuffer."Tax Vendor No." := PurchaseLine."Tax Vendor No.";
            InvoicePostBuffer."Head Office" := PurchaseLine."Head Office";
            InvoicePostBuffer."Branch Code" := PurchaseLine."Branch Code";
            InvoicePostBuffer."Tax Invoice No." := PurchaseLine."Tax Invoice No.";
            InvoicePostBuffer."Additional Grouping Identifier" := PurchaseLine."Tax Invoice No.";
            InvoicePostBuffer."Tax Invoice Date" := PurchaseLine."Tax Invoice Date";
            InvoicePostBuffer."Tax Invoice Name" := PurchaseLine."Tax Invoice Name";
            IF InvoicePostBuffer."VAT %" <> 0 THEN BEGIN
                InvoicePostBuffer."Tax Invoice Base" := PurchaseLine.Amount;
                InvoicePostBuffer."Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                if PurchaseLine."Tax Invoice Base" <> 0 then begin
                    InvoicePostBuffer."Tax Invoice Base" := PurchaseLine."Tax Invoice Base";
                    InvoicePostBuffer."Tax Invoice Amount" := PurchaseLine."Tax Invoice Amount";
                end;
            END ELSE
                if PurchaseLine."Tax Invoice Base" <> 0 then begin
                    InvoicePostBuffer."Tax Invoice Base" := PurchaseLine."Tax Invoice Base";
                    if PurchaseLine."Tax Invoice Amount" <> 0 then
                        InvoicePostBuffer."Tax Invoice Amount" := PurchaseLine."Tax Invoice Amount"
                    else
                        InvoicePostBuffer."Tax Invoice Amount" := PurchaseLine."Tax Invoice Amount"
                end else begin
                    InvoicePostBuffer."Tax Invoice Base" := PurchaseLine.Amount;
                    InvoicePostBuffer."Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                end;
        END;

        IF PurchaseLine."VAT Registration No." <> '' THEN
            InvoicePostBuffer."VAT Registration No." := PurchaseLine."VAT Registration No."
        ELSE
            InvoicePostBuffer."VAT Registration No." := PurchHeader."VAT Registration No.";

        IF (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"G/L Account") OR (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset") THEN
            InvoicePostBuffer."Line No." := PurchaseLine."Line No.";
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
    begin
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Released);
        if PurchaseHeader."Purchase Order No." <> '' then begin
            MESSAGE(StrSubstNo('this document has been order no. %1', PurchaseHeader."Purchase Order No."));
            IsHandled := true;
        end;
    end;



}