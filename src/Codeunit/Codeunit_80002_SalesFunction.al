/// <summary>
/// Codeunit NCT Sales Function (ID 80002).
/// </summary>
codeunit 80002 "NCT Sales Function"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesCrMemoHeader."NCT Applies-to ID" := SalesHeader."Applies-to ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesInvHeader."NCT Requested Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesInvHeader."NCT Applies-to ID" := SalesHeader."Applies-to ID";
    end;

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
        QuoteSalesHeader."NCT Sales Order No." := OrderSalesHeader."No.";
        QuoteSalesHeader.Modify();
        MESSAGE('Create to Document No. ' + OrderSalesHeader."No.");
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", 'OnBeforeRun', '', false, false)]
    local procedure OnBeforeRun(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var

    begin
        if SalesHeader."NCT Sales Order No." <> '' then begin
            MESSAGE('Document has been convers to Order %1', SalesHeader."NCT Sales Order No.");
            IsHandled := true;
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure "OnBeforeInsertSalesOrderHeader"(SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        SalesQuoteHeader.TestField("NCT Make Order No. Series");
        SalesOrderHeader."No." := NoseriesMgt.GetNextNo(SalesQuoteHeader."NCT Make Order No. Series", WorkDate(), True);
        SalesOrderHeader."No. Series" := SalesQuoteHeader."NCT Make Order No. Series";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnBeforeInsertSalesOrderLine', '', false, false)]
    local procedure OnBeforeInsertSalesOrderLineBlanket(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; BlanketOrderSalesLine: Record "Sales Line"; BlanketOrderSalesHeader: Record "Sales Header");
    begin
        SalesOrderLine."NCT Ref. SQ No." := BlanketOrderSalesLine."Document No.";
        SalesOrderLine."NCT Ref. SQ Line No." := BlanketOrderSalesLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderLine', '', false, false)]
    local procedure OnBeforeInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; SalesQuoteLine: Record "Sales Line"; SalesQuoteHeader: Record "Sales Header");
    begin
        SalesOrderLine."NCT Ref. SQ No." := SalesQuoteLine."Document No.";
        SalesOrderLine."NCT Ref. SQ Line No." := SalesQuoteLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnAfterInsertSalesOrderLine', '', false, false)]
    local procedure OnAfterInsertSalesOrderLine(SalesQuoteLine: Record "Sales Line");
    begin

        SalesQuoteLine."Outstanding Qty. (Base)" := 0;
        SalesQuoteLine."Outstanding Quantity" := 0;
        SalesQuoteLine."Completely Shipped" := (SalesQuoteLine.Quantity <> 0) and (SalesQuoteLine."Outstanding Quantity" = 0);
        SalesQuoteLine.Modify();

    end;



    [IntegrationEvent(false, false)]
    local procedure HandleMessagebeforPostSales(var Handle: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure "OnAfterInitOutstandingQty"(var SalesLine: Record "Sales Line")
    begin
        if SalesLine."Document Type" IN [SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order] then begin
            SalesLine."Outstanding Quantity" := SalesLine.Quantity - SalesLine."Quantity Shipped" - SalesLine."NCT Qty. to Cancel";
            SalesLine."Outstanding Qty. (Base)" := SalesLine."Quantity (Base)" - SalesLine."Qty. Shipped (Base)" - SalesLine."NCT Qty. to Cancel (Base)";
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPrepareSales', '', TRUE, TRUE)]

    /// <summary> 
    /// Description for InvoiceBufferSales.
    /// </summary>
    /// <param name="SalesLine">Parameter of type Record "Sales Line".</param>
    local procedure OnAfterPrepareSales(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        VendCust: Record "NCT Customer & Vendor Branch";
    begin
        IF SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") THEN BEGIN
            InvoicePostingBuffer."NCT Tax Invoice No." := SalesHeader."No.";
            InvoicePostingBuffer."NCT Head Office" := SalesHeader."NCT Head Office";
            InvoicePostingBuffer."NCT VAT Branch Code" := SalesHeader."NCT VAT Branch Code";
            InvoicePostingBuffer."NCT VAT Registration No." := SalesHeader."VAT Registration No.";
            InvoicePostingBuffer."NCT Tax Invoice Date" := SalesHeader."Document Date";
            InvoicePostingBuffer."NCT Tax Invoice Name" := SalesHeader."Bill-to Name";
            InvoicePostingBuffer."NCT Tax Invoice Name 2" := SalesHeader."Bill-to Name 2";
            InvoicePostingBuffer."NCT Tax Invoice Base" := SalesLine.Amount;
            InvoicePostingBuffer."NCT Tax Invoice Amount" := SalesLine."Amount Including VAT" - SalesLine.Amount;
            InvoicePostingBuffer."NCT Address" := SalesHeader."Bill-to Address";
            InvoicePostingBuffer."NCT Address 2" := SalesHeader."Bill-to Address 2";
            InvoicePostingBuffer."NCT City" := SalesHeader."Bill-to City";
            InvoicePostingBuffer."NCT Post Code" := SalesHeader."Bill-to Post Code";
            if not SalesHeader."NCT Head Office" then
                if VendCust.Get(VendCust."Source Type"::Customer, SalesHeader."Bill-to Customer No.", SalesHeader."NCT Head Office", SalesHeader."NCT VAT Branch Code") then begin
                    if VendCust."Name" <> '' then
                        if VendCust."Title Name" <> '' then
                            InvoicePostingBuffer."NCT Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
                        else
                            InvoicePostingBuffer."NCT Tax Invoice Name" := VendCust."Name";
                    if VendCust."Address" <> '' then
                        InvoicePostingBuffer."NCT Address" := VendCust."Address";
                    if VendCust."Address 2" <> '' then
                        InvoicePostingBuffer."NCT Address 2" := VendCust."Address 2";
                    if VendCust."Province" <> '' then
                        InvoicePostingBuffer."NCT city" := VendCust."Province";
                    if VendCust."Post Code" <> '' then
                        InvoicePostingBuffer."NCT Post Code" := VendCust."Post Code";
                end;


        END;
        InvoicePostingBuffer."NCT Description Line" := SalesLine.Description;
        InvoicePostingBuffer."NCT Document Line No." := SalesLine."Line No.";

        IF (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"G/L Account") OR (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"Fixed Asset") THEN
            InvoicePostingBuffer."NCT Line No." := SalesLine."Line No.";

    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', TRUE, TRUE)]

    local procedure "OnAfterInvPostBufferPrepareSales"(var InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        VendCust: Record "NCT Customer & Vendor Branch";
    begin
        IF SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") THEN BEGIN
            InvoicePostBuffer."NCT Tax Invoice No." := SalesHeader."No.";
            InvoicePostBuffer."NCT Head Office" := SalesHeader."NCT Head Office";
            InvoicePostBuffer."NCT VAT Branch Code" := SalesHeader."NCT VAT Branch Code";
            InvoicePostBuffer."NCT VAT Registration No." := SalesHeader."VAT Registration No.";
            InvoicePostBuffer."NCT Tax Invoice Date" := SalesHeader."Document Date";
            InvoicePostBuffer."NCT Tax Invoice Name" := SalesHeader."Bill-to Name";
            InvoicePostBuffer."NCT Tax Invoice Name 2" := SalesHeader."Bill-to Name 2";
            InvoicePostBuffer."NCT Tax Invoice Base" := SalesLine.Amount;
            InvoicePostBuffer."NCT Tax Invoice Amount" := SalesLine."Amount Including VAT" - SalesLine.Amount;
            InvoicePostBuffer."NCT Address" := SalesHeader."Bill-to Address";
            InvoicePostBuffer."NCT Address 2" := SalesHeader."Bill-to Address 2";
            InvoicePostBuffer."NCT City" := SalesHeader."Bill-to City";
            InvoicePostBuffer."NCT Post Code" := SalesHeader."Bill-to Post Code";
            if not SalesHeader."NCT Head Office" then
                if VendCust.Get(VendCust."Source Type"::Customer, SalesHeader."Bill-to Customer No.", SalesHeader."NCT Head Office", SalesHeader."NCT VAT Branch Code") then begin
                    if VendCust."Name" <> '' then
                        if VendCust."Title Name" <> '' then
                            InvoicePostBuffer."NCT Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
                        else
                            InvoicePostBuffer."NCT Tax Invoice Name" := VendCust."Name";
                    if VendCust."Address" <> '' then
                        InvoicePostBuffer."NCT Address" := VendCust."Address";
                    if VendCust."Address 2" <> '' then
                        InvoicePostBuffer."NCT Address 2" := VendCust."Address 2";
                    if VendCust."Province" <> '' then
                        InvoicePostBuffer."NCT city" := VendCust."Province";
                    if VendCust."Post Code" <> '' then
                        InvoicePostBuffer."NCT Post Code" := VendCust."Post Code";
                end;


        END;
        InvoicePostBuffer."NCT Description Line" := SalesLine.Description;
        InvoicePostBuffer."NCT Document Line No." := SalesLine."Line No.";

        IF (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"G/L Account") OR (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset") THEN
            InvoicePostBuffer."NCT Line No." := SalesLine."Line No.";

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
        if SalesHeader."NCT Sales Order No." <> '' then begin
            MESSAGE(StrSubstNo(text001Msg, SalesHeader."NCT Sales Order No."));
            IsHandled := true;
            Result := false;
        end;
    end;

}
