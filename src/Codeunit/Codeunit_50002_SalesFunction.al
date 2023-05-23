codeunit 50002 "Sales Function"
{


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure "OnBeforConfirmSalesPost"(var DefaultOption: Integer; var HideDialog: Boolean; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Handle: Boolean;
        ConfirmMsg: Label 'Do you want to Post %1 ?', Locked = true;
    begin
        Handle := true;
        HandleMessagebeforPostSales(Handle);
        if Handle then begin
            if not Confirm(strsubstno(ConfirmMsg, format(SalesHeader."Document Type"))) then
                IsHandled := true;

            if not IsHandled then begin
                DefaultOption := 1;
                HideDialog := true;

                if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                    SalesHeader.Ship := true;
                    SalesHeader.Invoice := false;
                    DefaultOption := 1;
                end;
                if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
                    SalesHeader.Ship := false;
                    SalesHeader.Invoice := true;
                    DefaultOption := 2;
                end;
                if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
                    SalesHeader.Receive := True;
                    SalesHeader.Invoice := false;
                    DefaultOption := 1;
                end;
            end else
                HideDialog := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateSellToCustomerName', '', false, false)]
    local procedure OnBeforeValidateSellToCustomerName(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeDeleteSalesQuote', '', false, false)]
    local procedure "OnBeferDeleteSalesQuote"(var IsHandled: Boolean; var QuoteSalesHeader: Record "Sales Header"; var OrderSalesHeader: Record "Sales Header")
    begin
        IsHandled := true;
        QuoteSalesHeader."Sales Order No." := OrderSalesHeader."No.";
        QuoteSalesHeader.Modify();
        MESSAGE('Create to Document No. ' + OrderSalesHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeOnRun', '', false, false)]
    local procedure "OnBeforeOnRun"(var SalesHeader: Record "Sales Header")
    var

    begin
        if SalesHeader."Sales Order No." <> '' then begin
            MESSAGE('Document has been convers to Order %1', SalesHeader."Sales Order No.");
            exit;
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure "OnBeforeInsertSalesOrderHeader"(SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        //   with SalesQuoteHeader do begin
        SalesQuoteHeader.TestField("Make Order No. Series");
        NoSeriesMgt.InitSeries(SalesQuoteHeader."Make Order No. Series", SalesQuoteHeader."Make Order No. Series", SalesQuoteHeader."Posting Date", SalesOrderHeader."No.", SalesOrderHeader."No. Series");
        //   end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnBeforeInsertSalesOrderLine', '', false, false)]
    local procedure OnAfterInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; BlanketOrderSalesLine: Record "Sales Line"; BlanketOrderSalesHeader: Record "Sales Header");
    begin
        SalesOrderLine."Ref. SQ No." := BlanketOrderSalesLine."Document No.";
        SalesOrderLine."Ref. SQ Line No." := BlanketOrderSalesLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderLine', '', false, false)]
    local procedure OnBeforeInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; SalesQuoteLine: Record "Sales Line"; SalesQuoteHeader: Record "Sales Header");
    begin
        SalesOrderLine."Ref. SQ No." := SalesQuoteLine."Document No.";
        SalesOrderLine."Ref. SQ Line No." := SalesQuoteLine."Line No.";
    end;

    [IntegrationEvent(false, false)]
    local procedure HandleMessagebeforPostSales(var Handle: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure "OnAfterInitOutstandingQty"(var SalesLine: Record "Sales Line")
    begin
        if SalesLine."Document Type" IN [SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order] then begin
            SalesLine."Outstanding Quantity" := SalesLine.Quantity - SalesLine."Quantity Shipped" - SalesLine."Qty. to Cancel";
            SalesLine."Outstanding Qty. (Base)" := SalesLine."Quantity (Base)" - SalesLine."Qty. Shipped (Base)" - SalesLine."Qty. to Cancel (Base)";
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPrepareSales', '', TRUE, TRUE)]

    /// <summary> 
    /// Description for InvoiceBufferSales.
    /// </summary>
    /// <param name="InvoicePostBuffer">Parameter of type Record "Invoice Post. Buffer".</param>
    /// <param name="SalesLine">Parameter of type Record "Sales Line".</param>
    local procedure "InvoiceBufferSales"(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        VendCust: Record "Customer & Vendor Branch";
    begin
        IF SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") THEN BEGIN
            InvoicePostingBuffer."Head Office" := SalesHeader."Head Office";
            InvoicePostingBuffer."Branch Code" := SalesHeader."Branch Code";
            InvoicePostingBuffer."VAT Registration No." := SalesHeader."VAT Registration No.";
            InvoicePostingBuffer."Tax Invoice Date" := SalesHeader."Document Date";
            InvoicePostingBuffer."Tax Invoice Name" := SalesHeader."Sell-to Customer Name";
            InvoicePostingBuffer."Tax Invoice Name 2" := SalesHeader."Sell-to Customer Name 2";
            InvoicePostingBuffer."Address" := SalesHeader."Sell-to Address";
            InvoicePostingBuffer."Address 2" := SalesHeader."Sell-to Address 2";
            InvoicePostingBuffer."City" := SalesHeader."Sell-to city";
            InvoicePostingBuffer."Post Code" := SalesHeader."Sell-to Post Code";
            if SalesHeader."Branch Code" <> '' then
                if VendCust.Get(VendCust."Source Type"::Customer, SalesHeader."Sell-to Customer No.", SalesHeader."Head Office", SalesHeader."Branch Code") then begin
                    InvoicePostingBuffer."Tax Invoice Name" := VendCust."Name";
                    InvoicePostingBuffer."Address" := VendCust."Address";
                    InvoicePostingBuffer."Address 2" := VendCust."Address 2";
                    InvoicePostingBuffer."city" := VendCust."Province";
                    InvoicePostingBuffer."Post Code" := VendCust."Post Code";
                end;


        END;
        //InvoicePostBuffer."Tax Invoice Base" := SalesLine.Amount;
        // InvoicePostBuffer."Tax Invoice Amount" := SalesLine."Amount Including VAT" - SalesLine.Amount;
        InvoicePostingBuffer."Description Line" := SalesLine.Description;
        InvoicePostingBuffer."Document Line No." := SalesLine."Line No.";

        IF (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"G/L Account") OR (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"Fixed Asset") THEN
            InvoicePostingBuffer."Line No." := SalesLine."Line No.";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckSalesApprovalPossible', '', false, false)]
    local procedure "OnSendSalesDocForApproval"(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
    begin
        SalesLine.reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Location Code", '%1', '');
        if SalesLine.FindFirst() then begin
            Item.Get(SalesLine."No.");
            if NOT (Item.Type IN [Item.Type::Service, item.Type::"Non-Inventory"]) then
                SalesLine.TestField("Location Code");
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", 'OnBeforeConfirmConvertToOrder', '', false, false)]
    local procedure OnBeforeConfirmConvertToOrder(SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var Result: Boolean)
    var
        text001Msg: Label 'this document has been order no. %1', Locked = true;
    begin
        SalesHeader.TestField(Status, SalesHeader.Status::Released);
        if SalesHeader."Sales Order No." <> '' then begin
            MESSAGE(StrSubstNo(text001Msg, SalesHeader."Sales Order No."));
            IsHandled := true;
            Result := false;
        end;
    end;

}
