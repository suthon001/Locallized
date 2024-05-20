/// <summary>
/// Report NCT AP Voucher (ID 80001).
/// </summary>
report 80001 "NCT AP Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'AP Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80001_APVoucher.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.") where(Amount = filter(<> 0));
            UseTemporary = true;
            column(DimThaiCaption1; DimThaiCaption1) { }
            column(DimThaiCaption2; DimThaiCaption2) { }
            column(DimEngCaption1; DimEngCaption1) { }
            column(DimEngCaption2; DimEngCaption2) { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(G_L_Account_Name; AccountName) { }
            column(Debit_Amount; "Debit Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(PostingDate; format(PurHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentDate; format(PurHeader."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DueDate; format(PurHeader."Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; PurHeader."No.") { }
            column(ExchangeRate; ExchangeRate) { }
            column(PostingDescription; PurHeader."Posting Description") { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(VendText_1; VendText[1]) { }
            column(VendText_2; VendText[2]) { }
            column(VendText_3; VendText[3]) { }
            column(VendText_4; VendText[4]) { }
            column(VendText_5; VendText[5]) { }
            column(VendText_9; VendText[9]) { }
            column(VendText_10; VendText[10]) { }
            column(CreateDocBy; PurHeader."NCT Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(AmtText; AmtText) { }
            column(HaveItemLine; HaveItemLine) { }
            column(HaveItemCharge; HaveItemCharge) { }
            column(HaveItemVAT; HaveItemVAT) { }
            column(HAVEWHT; HAVEWHT) { }

            trigger OnPreDataItem()
            var
                NewDate: Date;
            begin

                FunctionCenter.SetReportGLEntryPurchase(PurHeader, GLEntry, TempAmt, groupping, FromPosted);
                companyInfor.get();
                companyInfor.CalcFields(Picture);
                if PurHeader."Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, PurHeader."VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, PurHeader."VAT Bus. Posting Group", true);
                if not FromPosted then
                    FunctionCenter."PurchaseInformation"(PurHeader."Document Type", PurHeader."No.", VendText, 1)
                else
                    FunctionCenter.PurchasePostedVendorInformation(2, PurHeader."No.", VendText, 0);
                FunctionCenter."ConvExchRate"(PurHeader."Currency Code", PurHeader."Currency Factor", ExchangeRate);
                if PurHeader."Currency Code" = '' then
                    AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')'
                else
                    AmtText := '(' + FunctionCenter.NumberEngToText(TempAmt, PurHeader."Currency Code") + ')';
                NewDate := DT2Date(PurHeader."NCT Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                "CheckLineData"();
                FunctionCenter.GetGlobalDimCaption(DimThaiCaption1, DimEngCaption1, DimThaiCaption2, DimEngCaption2);
            end;

            trigger OnAfterGetRecord()
            begin
                if not glAccount.GET("G/L Account No.") then
                    glAccount.Init();
                AccountName := glAccount.Name;
                if AccountName = '' then
                    AccountName := COPYSTR("NCT Journal Description", 1, 100);

            end;
        }
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.") where(Type = const(Item));
            UseTemporary = true;
            column(No_; "No.") { }
            column(Description; Description + ' ' + "Description 2") { }
            column(Location_Code; "Location Code") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Quantity; Quantity) { }
            column(Direct_Unit_Cost; "Direct Unit Cost") { }
            column(Amount; Amount) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Line_Amount; "Line Amount") { }
            column(Receipt_No_; "Receipt No.") { }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", PurHeader."Document Type");
                SetRange("Document No.", PurHeader."No.");
            end;
        }
        dataitem("PurchaseLineTaxInvoice"; "Purchase Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.") where("NCT Tax Invoice No." = filter(<> ''));
            UseTemporary = true;
            column(Tax_Invoice_No_; "NCT Tax Invoice No.") { }
            column(Tax_Invoice_Date; format("NCT Tax Invoice Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Tax_Invoice_Name; "NCT Tax Invoice Name") { }
            column(Tax_Invoice_Amount; "NCT Tax Invoice Amount") { }
            column(Tax_Invoice_Base; "NCT Tax Invoice Base") { }
            column(Vat_Registration_No_; "NCT Vat Registration No.") { }
            column(BranchCode; BranchCode) { }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", PurHeader."Document Type");
                SetRange("Document No.", PurHeader."No.");
            end;

            trigger OnAfterGetRecord()
            begin
                if "NCT Head Office" then
                    BranchCode := 'สำนักงานใหญ่'
                else
                    BranchCode := "NCT VAT Branch Code";

            end;
        }
        dataitem(PurchaseItemCharge; "Purchase Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.")
            where(Type = const("Charge (Item)"));
            UseTemporary = true;

            dataitem(ItemChargeAssignment; "Item Charge Assignment (Purch)")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Document Line No.", "Line NO.");
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                UseTemporary = true;
                column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }
                column(Item_No_; "Item No.") { }
                column(ItemChangeDescription; Description) { }
                column(Amount_to_Assign; "Amount to Assign") { }
                column(Qty__to_Assign; "Qty. to Assign") { }
                column(vgVendorNoItemCharge; vgVendorNoItemCharge) { }
                column(vgQtyonReceiptItemCharge; vgQtyonReceiptItemCharge) { }
                column(vgUOMFromItemCharge; vgUOMFromItemCharge) { }
                trigger OnAfterGetRecord()
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    Item: Record Item;
                begin
                    IF NOT Item.GET("Item No.") THEN
                        Item.init();
                    vgUOMFromItemCharge := Item."Base Unit of Measure";


                    IF NOT PurchRcptHeader.GET("Applies-to Doc. No.") then
                        PurchRcptHeader.init();
                    vgVendorNoItemCharge := PurchRcptHeader."Buy-from Vendor No.";


                    if not PurchRcptLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.") then
                        PurchRcptLine.Init();

                    vgQtyonReceiptItemCharge := PurchRcptLine.Quantity;
                end;
            }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", PurHeader."Document Type");
                SetRange("Document No.", PurHeader."No.");
            end;
        }
        dataitem(WHTLINE; "Purchase Line")
        {

            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") where("NCT WHT Product Posting Group" = filter(<> ''));
            UseTemporary = true;
            column(NCT_WHT_Bus__Posting_Group; "NCT WHT Business Posting Group") { }
            column(NCT_WHT_Product_Posting_Group; "NCT WHT Product Posting Group") { }
            column(NCT_WHT_Option; format("NCT WHT Option")) { }
            column(NCT_WHT_Base; "NCT WHT Base") { }
            column(NCT_WHT_Amount; "NCT WHT Amount") { }
            column(NCT_WHT__; "NCT WHT %") { }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", PurHeader."Document Type");
                SetRange("Document No.", PurHeader."No.");
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(gvgroupping; groupping)
                {
                    ApplicationArea = all;
                    ToolTip = 'Grouping data';
                    Caption = 'Grouping G/L Account';
                }
            }
        }
        trigger OnInit()
        begin
            groupping := true;
        end;
    }

    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure "CheckLineData"()
    begin
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        HaveItemLine := PurchaseLine.Count <> 0;
        PurchaseLine.SetRange(Type);
        PurchaseLine.SetFilter("NCT Tax Invoice No.", '<>%1', '');
        HaveItemVAT := PurchaseLine.Count <> 0;

        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"Charge (Item)");
        HaveItemCharge := PurchaseLine.Count <> 0;


        PurchaseLine.RESET();
        PurchaseLine.SETRANGE("Document Type", PurHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurHeader."No.");
        PurchaseLine.SETFILTER("NCT WHT Product Posting Group", '<>%1', '');
        HAVEWHT := PurchaseLine.Count <> 0;
    end;

    /// <summary>
    /// SetDataTable.
    /// </summary>
    /// <param name="pVariant">Variant.</param>
    procedure SetDataTable(pVariant: Variant)
    var
        ltRecordRef: RecordRef;
        ltPurchaseLine: Record "Purchase Line";
        ltPurchInvLine: Record "Purch. Inv. Line";
        ltValueEntry: Record "Value Entry";
        ltItemLedger: Record "Item Ledger Entry";
        ItemchagePurch: Record "Item Charge Assignment (Purch)";
    begin
        ltRecordRef.GetTable(pVariant);
        if ltRecordRef.FindFirst() then begin
            if ltRecordRef.Number = Database::"Purchase Header" then begin
                FromPosted := false;
                ltRecordRef.SetTable(PurHeader);
                PurHeader.Insert();
                ltPurchaseLine.reset();
                ltPurchaseLine.SetRange("Document Type", PurHeader."Document Type");
                ltPurchaseLine.SetRange("Document No.", PurHeader."No.");
                if ltPurchaseLine.FindSet() then
                    repeat
                        PurchaseLine.Init();
                        PurchaseLine.TransferFields(ltPurchaseLine);
                        PurchaseLine.Insert();
                        if PurchaseLine.Type = PurchaseLine.Type::"Charge (Item)" then begin
                            ItemchagePurch.reset();
                            ItemchagePurch.SetRange("Document Type", PurHeader."Document Type");
                            ItemchagePurch.SetRange("Document No.", PurHeader."No.");
                            ItemchagePurch.SetRange("Document Line No.", ltPurchaseLine."Line No.");
                            if ItemchagePurch.FindSet() then
                                repeat
                                    ItemChargeAssignment.Init();
                                    ItemChargeAssignment.TransferFields(ItemchagePurch);
                                    ItemChargeAssignment.Insert();
                                until ItemchagePurch.Next() = 0;
                        end;
                    until ltPurchaseLine.Next() = 0;
            end;
            if ltRecordRef.Number = Database::"Purch. Inv. Header" then begin
                FromPosted := true;
                ltRecordRef.SetTable(PurInvoice);
                PurHeader.TransferFields(PurInvoice, false);
                PurHeader."Document Type" := PurHeader."Document Type"::Invoice;
                PurHeader."No." := PurInvoice."No.";
                PurHeader.Insert();
                ltPurchInvLine.reset();
                ltPurchInvLine.SetRange("Document No.", PurHeader."No.");
                if ltPurchInvLine.FindSet() then
                    repeat
                        PurchaseLine.Init();
                        PurchaseLine.TransferFields(ltPurchInvLine, false);
                        PurchaseLine."Document Type" := PurHeader."Document Type";
                        PurchaseLine."Document No." := PurHeader."No.";
                        PurchaseLine."Line No." := ltPurchInvLine."Line No.";
                        PurchaseLine.Insert();
                        if ltPurchInvLine.Type = ltPurchInvLine.Type::"Charge (Item)" then begin
                            ltValueEntry.reset();
                            ltValueEntry.SetRange("Document No.", ltPurchInvLine."Document No.");
                            ltValueEntry.SetRange("Document Line No.", ltPurchInvLine."Line No.");
                            ltValueEntry.SetFilter("Item Charge No.", '<>%1', '');
                            if ltValueEntry.FindSet() then
                                repeat
                                    if not ltItemLedger.GET(ltValueEntry."Item Ledger Entry No.") then
                                        ltItemLedger.Init();

                                    ItemChargeAssignment.Init();
                                    ItemChargeAssignment."Document Type" := PurHeader."Document Type";
                                    ItemChargeAssignment."Document No." := PurHeader."No.";
                                    ItemChargeAssignment."Document Line No." := ltValueEntry."Document Line No.";
                                    ItemChargeAssignment."Line No." := ltValueEntry."Entry No.";
                                    ItemChargeAssignment."Applies-to Doc. No." := ltItemLedger."Document No.";
                                    ItemChargeAssignment."Item No." := ltItemLedger."Item No.";
                                    ItemChargeAssignment.Description := ltItemLedger.Description;
                                    ItemChargeAssignment."Amount to Assign" := ltValueEntry."Cost Amount (Actual)";
                                    ItemChargeAssignment."Qty. to Assign" := ltValueEntry."Valued Quantity";
                                    ItemChargeAssignment.Insert();

                                until ltValueEntry.Next() = 0;
                        end;
                    until ltPurchInvLine.Next() = 0;
            end;
            PurchaseLine.Reset();
            "Purchase Line".Copy(PurchaseLine, true);
            PurchaseLineTaxInvoice.Copy(PurchaseLine, true);
            PurchaseItemCharge.Copy(PurchaseLine, true);
            WHTLINE.Copy(PurchaseLine, true);
        end;

    end;
    // /// <summary> 
    // /// Description for SetGLEntry.
    // /// </summary>
    // /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    // procedure "SetGLEntry"(PurchaseHeader: Record "Purchase Header")
    // begin
    //     PurHeader.GET(PurchaseHeader."Document Type", PurchaseHeader."No.");
    // end;

    var

        PurHeader: Record "Purchase Header" temporary;
        PurInvoice: Record "Purch. Inv. Header" temporary;
        PurchaseLine: Record "Purchase Line" temporary;
        FunctionCenter: Codeunit "NCT Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        VendText: array[10] Of Text[250];
        BranchCode: Text[50];
        SplitDate: Array[3] of Text[20];
        vgUOMFromItemCharge: Code[10];
        vgVendorNoItemCharge: Code[20];
        vgQtyonReceiptItemCharge: Decimal;
        AmtText: Text[1024];
        TempAmt: Decimal;
        HaveItemLine: Boolean;
        HaveItemCharge: Boolean;
        HaveItemVAT, HAVEWHT : Boolean;
        groupping: Boolean;
        AccountName: text[100];
        glAccount: Record "G/L Account";
        DimThaiCaption1, DimThaiCaption2, DimEngCaption1, DimEngCaption2 : text;
        FromPosted: Boolean;

}
