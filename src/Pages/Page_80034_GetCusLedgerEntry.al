/// <summary>
/// Page NCT Get Cus. Ledger Entry (ID 80034).
/// </summary>
page 80034 "NCT Get Cus. Ledger Entry"
{

    SourceTable = "Cust. Ledger Entry";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Caption = 'Get Cust. Ledger Entry';
    SourceTableTemporary = true;
    PageType = List;
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater("GROUP")
            {
                Caption = 'Lines';
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the Customer account that the entry is linked to.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Customer entry''s posting date.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Amount field.';
                    Caption = 'Original Amount';
                }
                field(BillingReceiptAmount; BillingReceiptAmount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NCT Amount field.';
                    Editable = false;
                    CaptionClass = captionField;
                }
                field("NCT Remaining Amt."; Rec."NCT Remaining Amt.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Billing Remaining Amt.(LCY) field.';
                    Caption = 'Remaining Amount';
                }

            }
        }
    }

    trigger OnAfterGetRecord()

    begin
        Rec.CalcFields("Remaining Amount", "Original Amount", Amount, rec."NCT Billing Amount", rec."NCT Receipt Amount");
        if BillRcptHeader."Document Type" = BillRcptHeader."Document Type"::"Sales Billing" then
            BillingReceiptAmount := rec."NCT Billing Amount"
        else
            BillingReceiptAmount := rec."NCT Receipt Amount";

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            CreateLines();
    end;

    /// <summary>
    /// SetDocument.
    /// </summary>
    /// <param name="BillingRcptHeader">Record "Billing Receipt Header".</param>
    procedure SetDocument(BillingRcptHeader: Record "NCT Billing Receipt Header")
    begin
        BillRcptHeader.GET(BillingRcptHeader."Document Type", BillingRcptHeader."No.");
        if BillingRcptHeader."Document Type" = BillingRcptHeader."Document Type"::"Sales Receipt" then
            captionField := 'Receipt Amount';
        if BillingRcptHeader."Document Type" = BillingRcptHeader."Document Type"::"Sales Billing" then
            captionField := 'Billing Amount';
    end;

    local procedure CreateLines()
    var
        CUstLedger: Record "Cust. Ledger Entry" temporary;
        BillRcptLine: Record "NCT Billing Receipt Line";
        ltBillRcptLHeader: Record "NCT Billing Receipt Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrLine: Record "Sales Cr.Memo Line";
        TOtalReceipt: Decimal;
    begin
        TOtalReceipt := 0;
        CUstLedger.COPY(Rec, true);
        CurrPage.SETSELECTIONFILTER(CUstLedger);
        IF CUstLedger.FindSet() THEN
            REPEAT
                CUstLedger.CalcFields("Original Amt. (LCY)", CUstLedger."Original Amount");
                BillRcptLine.INIT();
                BillRcptLine."Document Type" := DocumentType;
                BillRcptLine."Document No." := DocumentNo;
                BillRcptLine."Line No." := GetLastLine();
                BillRcptLine.INSERT();

                BillRcptLine."Source Ledger Entry No." := CUstLedger."Entry No.";
                BillRcptLine."Source Document Date" := CUstLedger."Document Date";
                BillRcptLine."Source Document No." := CUstLedger."Document No.";
                BillRcptLine."Source Due Date" := CUstLedger."Due Date";
                if CUstLedger."Document Type" = CUstLedger."Document Type"::Invoice then begin
                    BillRcptLine."Source Amount (LCY)" := ABS(CUstLedger."Original Amt. (LCY)");
                    BillRcptLine."Source Amount" := ABS(CUstLedger."Original Amount");
                end else begin
                    BillRcptLine."Source Amount (LCY)" := -ABS(CUstLedger."Original Amt. (LCY)");
                    BillRcptLine."Source Amount" := -ABS(CUstLedger."Original Amount");
                end;
                BillRcptLine."Source Description" := CUstLedger.Description;
                BillRcptLine."Source Currency Code" := CUstLedger."Currency Code";
                BillRcptLine."Source Ext. Document No." := CUstLedger."External Document No.";
                if CUstLedger."Document Type" = CUstLedger."Document Type"::Invoice then begin
                    BillRcptLine."Source Document Type" := BillRcptLine."Source Document Type"::Invoice;
                    BillRcptLine."Amount" := ABS(CUstLedger."NCT Remaining Amt.");

                    SalesInvoiceLine.reset();
                    SalesInvoiceLine.SetRange("Document No.", BillRcptLine."Source Document No.");
                    SalesInvoiceLine.SetFilter("VAT %", '<>%1', 0);
                    if SalesInvoiceLine.FindFirst() then
                        BillRcptLine."Vat %" := SalesInvoiceLine."VAT %";

                end else begin
                    BillRcptLine."Source Document Type" := BillRcptLine."Source Document Type"::"Credit Memo";
                    BillRcptLine."Amount" := -ABS(CUstLedger."NCT Remaining Amt.");

                    SalesCrLine.reset();
                    SalesCrLine.SetRange("Document No.", BillRcptLine."Source Document No.");
                    SalesCrLine.SetFilter("VAT %", '<>%1', 0);
                    if SalesCrLine.FindFirst() then
                        BillRcptLine."Vat %" := SalesCrLine."VAT %";
                end;

                BillRcptLine.CalAmtExcludeVat();
                BillRcptLine.Modify();
                TOtalReceipt := TOtalReceipt + BillRcptLine."Amount";
            UNTIL CUstLedger.NEXT() = 0;
        if DocumentType = DocumentType::"Sales Receipt" then
            if TOtalReceipt <> 0 then begin
                ltBillRcptLHeader.GET(DocumentType, DocumentNo);
                ltBillRcptLHeader."Receive & Payment Amount" := TotalReceipt;
                ltBillRcptLHeader.Modify();
            end;
    end;


    local procedure GetLastLine(): Integer;
    var
        BillRcptLine: Record "NCT Billing Receipt Line";
    begin
        BillRcptLine.reset();
        BillRcptLine.SetFilter("Document Type", '%1', DocumentType);
        BillRcptLine.SetFilter("Document No.", '%1', DocumentNo);
        if BillRcptLine.FindLast() then
            exit(BillRcptLine."Line No." + 10000);
        exit(10000);
    end;


    /// <summary>
    /// SetTableData.
    /// </summary>
    /// <param name="pCustomer">code[20].</param>
    /// <param name="pDocumentType">Enum "Document Type".</param>
    /// <param name="pDocumentNo">code[30].</param>
    procedure SetTableData(pCustomer: code[20]; pDocumentType: Enum "NCT Billing Document Type"; pDocumentNo: code[20])
    var
        CustLedger: Record "Cust. Ledger Entry";
    begin
        DocumentType := pDocumentType;
        DocumentNo := pDocumentNo;
        CustLedger.reset();
        CustLedger.SetRange("Customer No.", pCustomer);
        CustLedger.SetFilter("Document Type", '%1|%2', CustLedger."Document Type"::Invoice, CustLedger."Document Type"::"Credit Memo");
        CustLedger.setrange(Open, true);
        if CustLedger.FindSet() then
            repeat
                CustLedger.CalcFields("Remaining Amount", "NCT Billing Amount", "NCT Receipt Amount");
                if pDocumentType = pDocumentType::"Sales Billing" then
                    if (ABS(CustLedger."Remaining Amount") - abs(CustLedger."NCT Billing Amount")) > 0 then begin
                        rec.Init();
                        rec.TransferFields(CustLedger);
                        if CustLedger."Document Type" = CustLedger."Document Type"::Invoice then
                            rec."NCT Remaining Amt." := (ABS(CustLedger."Remaining Amount") - abs(CustLedger."NCT Billing Amount"))
                        else
                            rec."NCT Remaining Amt." := -(ABS(CustLedger."Remaining Amount") - abs(CustLedger."NCT Billing Amount"));
                        rec.Insert();
                    end;
                if pDocumentType = pDocumentType::"Sales Receipt" then
                    if (ABS(CustLedger."Remaining Amount") - abs(CustLedger."NCT Receipt Amount")) > 0 then begin
                        rec.Init();
                        rec.TransferFields(CustLedger);
                        if CustLedger."Document Type" = CustLedger."Document Type"::Invoice then
                            rec."NCT Remaining Amt." := (ABS(CustLedger."Remaining Amount") - abs(CustLedger."NCT Receipt Amount"))
                        else
                            rec."NCT Remaining Amt." := -(ABS(CustLedger."Remaining Amount") - abs(CustLedger."NCT Receipt Amount"));
                        rec.Insert();
                    end;
            until CustLedger.Next() = 0;
    end;



    var
        BillRcptHeader: Record "NCT Billing Receipt Header";
        DocumentNo: code[20];
        DocumentType: Enum "NCT Billing Document Type";
        BillingReceiptAmount: Decimal;
        captionField: Text;
}