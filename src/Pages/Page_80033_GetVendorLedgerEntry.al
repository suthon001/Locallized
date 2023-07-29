/// <summary>
/// Page Get Vendor Ledger Entry (ID 80033).
/// </summary>
page 80033 "NCT Get Vendor Ledger Entry"
{

    SourceTable = "Vendor Ledger Entry";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Caption = 'Get Vendor Ledger Entry';
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
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
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
                field("Original Amount"; -Rec."Original Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Amount field.';
                    Caption = 'Original Amount';
                }
                field("NCT Billing Amount"; Rec."NCT Billing Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NCT Billing Amount field.';
                    Caption = 'Billing Amount ';
                }
                field("Billing Remaining Amt.(LCY)"; Rec."NCT Billing Remaining Amt.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Billing Remaining Amt.field.';
                    Caption = 'Remaining Amount';
                }


            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Remaining Amount", "Original Amount", Amount, rec."NCT Billing Amount");
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
    end;

    local procedure CreateLines()
    var
        VendEntry: Record "Vendor Ledger Entry" temporary;
        BillRcptLine: Record "NCT Billing Receipt Line";
        ltPuchaseInvoiceHeader: Record "Purch. Inv. Header";
        PurchaseInvoiceLine: Record "Purch. Inv. Line";
        ltPurchaseCRHeader: Record "Purch. Cr. Memo Hdr.";
        PurchaseCRLine: Record "Purch. Cr. Memo Line";
    begin
        VendEntry.COPY(Rec, true);
        CurrPage.SETSELECTIONFILTER(VendEntry);
        IF VendEntry.FindSet() THEN
            REPEAT
                VendEntry.CalcFields("Original Amt. (LCY)", VendEntry."Original Amount");
                BillRcptLine.INIT();
                BillRcptLine."Document Type" := DocumentType;
                BillRcptLine."Document No." := DocumentNo;
                BillRcptLine."Line No." := GetLastLine();
                BillRcptLine.INSERT();

                BillRcptLine."Source Ledger Entry No." := VendEntry."Entry No.";
                BillRcptLine."Source Document Date" := VendEntry."Document Date";
                BillRcptLine."Source Document No." := VendEntry."Document No.";
                BillRcptLine."Source Ext. Document No." := VendEntry."External Document No.";
                BillRcptLine."Source Due Date" := VendEntry."Due Date";
                BillRcptLine."Source Amount (LCY)" := ABS(VendEntry."Original Amt. (LCY)");
                BillRcptLine."Source Amount" := ABS(VendEntry."Original Amount");
                BillRcptLine."Source Description" := VendEntry.Description;
                BillRcptLine."Source Currency Code" := VendEntry."Currency Code";
                BillRcptLine."Source Document Type" := BillRcptLine."Source Document Type"::Invoice;
                if VendEntry."Document Type" = VendEntry."Document Type"::Invoice then begin
                    BillRcptLine."Amount" := ABS(VendEntry."NCT Billing Remaining Amt.");
                    if ltPuchaseInvoiceHeader.GET(VendEntry."Document No.") then
                        BillRcptLine."Source Ext. Document No." := ltPuchaseInvoiceHeader."Vendor Invoice No.";

                    PurchaseInvoiceLine.reset();
                    PurchaseInvoiceLine.SetRange("Document No.", BillRcptLine."Source Document No.");
                    PurchaseInvoiceLine.SetFilter("VAT %", '<>%1', 0);
                    if PurchaseInvoiceLine.FindFirst() then
                        BillRcptLine."Vat %" := PurchaseInvoiceLine."VAT %";

                end else begin
                    BillRcptLine."Amount" := ABS(VendEntry."NCT Billing Remaining Amt.") * -1;
                    if ltPurchaseCRHeader.GET(VendEntry."Document No.") then
                        BillRcptLine."Source Ext. Document No." := ltPurchaseCRHeader."Vendor Cr. Memo No.";

                    PurchaseCRLine.reset();
                    PurchaseCRLine.SetRange("Document No.", BillRcptLine."Source Document No.");
                    PurchaseCRLine.SetFilter("VAT %", '<>%1', 0);
                    if PurchaseCRLine.FindFirst() then
                        BillRcptLine."Vat %" := PurchaseCRLine."VAT %";

                end;
                BillRcptLine.CalAmtExcludeVat();
                BillRcptLine.Modify();
            UNTIL VendEntry.NEXT() = 0;

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
    /// <param name="pVendorNo">code[20].</param>
    /// <param name="pDocumentType">Enum "Document Type".</param>
    /// <param name="pDocumentNo">code[30].</param>
    procedure SetTableData(pVendorNo: code[20]; pDocumentType: Enum "NCT Billing Document Type"; pDocumentNo: code[20])
    var
        VendorLedger: Record "Vendor Ledger Entry";

    begin
        DocumentType := pDocumentType;
        DocumentNo := pDocumentNo;
        VendorLedger.reset();
        VendorLedger.SetRange("Vendor No.", pVendorNo);
        VendorLedger.SetFilter("Document Type", '%1|%2', VendorLedger."Document Type"::Invoice, VendorLedger."Document Type"::"Credit Memo");
        VendorLedger.setrange(Open, true);
        if VendorLedger.FindSet() then
            repeat
                VendorLedger.CalcFields("Remaining Amount", "NCT Billing Amount");
                if (ABS(VendorLedger."Remaining Amount") - abs(VendorLedger."NCT Billing Amount")) > 0 then begin
                    rec.Init();
                    rec.TransferFields(VendorLedger);
                    if VendorLedger."Document Type" = VendorLedger."Document Type"::Invoice then
                        rec."NCT Billing Remaining Amt." := (ABS(VendorLedger."Remaining Amount") - abs(VendorLedger."NCT Billing Amount"))
                    else
                        rec."NCT Billing Remaining Amt." := -(ABS(VendorLedger."Remaining Amount") - abs(VendorLedger."NCT Billing Amount"));
                    rec.Insert();
                end;
            until VendorLedger.Next() = 0;
    end;



    var
        BillRcptHeader: Record "NCT Billing Receipt Header";
        DocumentNo: code[20];
        DocumentType: Enum "NCT Billing Document Type";
}