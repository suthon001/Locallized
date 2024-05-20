/// <summary>
/// Report NCT AR Voucher (ID 80003).
/// </summary>
report 80003 "NCT AR Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'AR Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80003_ARVoucher.rdl';
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
            column(External_Document_No_; SalesHeader."External Document No.") { }
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(PostingDate; format(SalesHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentDate; format(SalesHeader."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; SalesHeader."No.") { }
            column(ExchangeRate; ExchangeRate) { }
            column(PostingDescription; SalesHeader."Posting Description") { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(CustText_1; CustText[1]) { }
            column(CustText_2; CustText[2]) { }
            column(CustText_3; CustText[3]) { }
            column(CustText_4; CustText[4]) { }
            column(CustText_5; CustText[5]) { }
            column(CustText_9; CustText[9]) { }
            column(CustText_10; CustText[10]) { }
            column(CreateDocBy; SalesHeader."NCT Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(HaveItemLine; HaveItemLine) { }
            column(HaveItemCharge; HaveItemCharge) { }
            column(AmtText; AmtText) { }
            trigger OnPreDataItem()
            var
                NewDate: Date;
            begin


                FunctionCenter.SetReportGLEntrySales(SalesHeader, GLEntry, TempAmt, groupping, FromPosted);
                companyInfor.get();
                companyInfor.CalcFields(Picture);
                if SalesHeader."Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, SalesHeader."VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, SalesHeader."VAT Bus. Posting Group", true);
                if not FromPosted then
                    FunctionCenter."SalesInformation"(SalesHeader."Document Type", SalesHeader."No.", CustText, 1)
                else
                    FunctionCenter.SalesPostedCustomerInformation(2, SalesHeader."No.", CustText, 0);
                FunctionCenter."ConvExchRate"(SalesHeader."Currency Code", SalesHeader."Currency Factor", ExchangeRate);
                if SalesHeader."Currency Code" = '' then
                    AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')'
                else
                    AmtText := '(' + FunctionCenter.NumberEngToText(TempAmt, SalesHeader."Currency Code") + ')';
                NewDate := DT2Date(SalesHeader."NCT Create DateTime");
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
            end;
        }
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.") where(Type = const(Item));
            UseTemporary = true;

            column(No_; "No.") { }
            column(Description; Description + ' ' + "Description 2") { }
            column(Location_Code; "Location Code") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Quantity; Quantity) { }
            column(Unit_Price; "Unit Price") { }
            column(Amount; Amount) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Line_Amount; "Line Amount") { }
            column(Shipment_No_; "Shipment No.") { }


            trigger OnPreDataItem()
            begin
                SetRange("Document Type", SalesHeader."Document Type");
                SetRange("Document No.", SalesHeader."No.");

            end;




        }

        dataitem(SalesItemCharge; "Sales Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.")
            where(Type = const("Charge (Item)"));
            UseTemporary = true;

            dataitem(ItemChargeAssignment; "Item Charge Assignment (Sales)")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Document Line No.", "Line NO.");
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                UseTemporary = true;
                column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }
                column(Item_No_; "Item No.") { }
                column(ItemChangeDescription; Description) { }
                column(Amount_to_Assign; "Amount to Assign") { }
                column(Qty__to_Assign; "Qty. to Assign") { }
                column(vgCustNoItemCharge; vgCustNoItemCharge) { }
                column(vgQtyonShipItemCharge; vgQtyonShipItemCharge) { }
                column(vgUOMFromItemCharge; vgUOMFromItemCharge) { }

                trigger OnAfterGetRecord()
                var
                    SalesShipHeader: Record "Sales Shipment Header";
                    SalesShipLine: Record "Sales Shipment Line";
                    Item: Record Item;
                begin
                    IF NOT Item.GET("Item No.") THEN
                        Item.init();
                    vgUOMFromItemCharge := Item."Base Unit of Measure";


                    IF NOT SalesShipHeader.GET("Applies-to Doc. No.") then
                        SalesShipHeader.init();
                    vgCustNoItemCharge := SalesShipHeader."Sell-to Customer No.";


                    if not SalesShipLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.") then
                        SalesShipLine.Init();

                    vgQtyonShipItemCharge := SalesShipLine.Quantity;
                end;
            }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", SalesHeader."Document Type");
                SetRange("Document No.", SalesHeader."No.");

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
    /// SetDataTable.
    /// </summary>
    /// <param name="pVariant">Variant.</param>
    procedure SetDataTable(pVariant: Variant)
    var
        ltRecordRef: RecordRef;
        ltSalesLine: Record "Sales Line";
        ltSalesInvLine: Record "Sales Invoice Line";
        ltValueEntry: Record "Value Entry";
        ltItemLedger: Record "Item Ledger Entry";
        ItemchageSales: Record "Item Charge Assignment (Sales)";
    begin
        ltRecordRef.GetTable(pVariant);
        if ltRecordRef.FindFirst() then begin
            if ltRecordRef.Number = Database::"Purchase Header" then begin
                FromPosted := false;
                ltRecordRef.SetTable(SalesHeader);
                SalesHeader.Insert();
                ltSalesLine.reset();
                ltSalesLine.SetRange("Document Type", SalesHeader."Document Type");
                ltSalesLine.SetRange("Document No.", SalesHeader."No.");
                if ltSalesLine.FindSet() then
                    repeat
                        SalesLine.Init();
                        SalesLine.TransferFields(ltSalesLine);
                        SalesLine.Insert();
                        if SalesLine.Type = SalesLine.Type::"Charge (Item)" then begin
                            ItemchageSales.reset();
                            ItemchageSales.SetRange("Document Type", SalesHeader."Document Type");
                            ItemchageSales.SetRange("Document No.", SalesHeader."No.");
                            ItemchageSales.SetRange("Document Line No.", ltSalesLine."Line No.");
                            if ItemchageSales.FindSet() then
                                repeat
                                    ItemChargeAssignment.Init();
                                    ItemChargeAssignment.TransferFields(ItemchageSales);
                                    ItemChargeAssignment.Insert();
                                until ItemchageSales.Next() = 0;
                        end;
                    until ltSalesLine.Next() = 0;
            end;
            if ltRecordRef.Number = Database::"Purch. Inv. Header" then begin
                FromPosted := true;
                ltRecordRef.SetTable(SalesInvoice);
                SalesHeader.TransferFields(SalesInvoice, false);
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader."No." := SalesInvoice."No.";
                SalesHeader.Insert();
                ltSalesInvLine.reset();
                ltSalesInvLine.SetRange("Document No.", SalesHeader."No.");
                if ltSalesInvLine.FindSet() then
                    repeat
                        SalesLine.Init();
                        SalesLine.TransferFields(ltSalesInvLine, false);
                        SalesLine."Document Type" := SalesHeader."Document Type";
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := ltSalesInvLine."Line No.";
                        SalesLine.Insert();
                        if ltSalesInvLine.Type = ltSalesInvLine.Type::"Charge (Item)" then begin
                            ltValueEntry.reset();
                            ltValueEntry.SetRange("Document No.", ltSalesInvLine."Document No.");
                            ltValueEntry.SetRange("Document Line No.", ltSalesInvLine."Line No.");
                            ltValueEntry.SetFilter("Item Charge No.", '<>%1', '');
                            if ltValueEntry.FindSet() then
                                repeat
                                    if not ltItemLedger.GET(ltValueEntry."Item Ledger Entry No.") then
                                        ltItemLedger.Init();

                                    ItemChargeAssignment.Init();
                                    ItemChargeAssignment."Document Type" := SalesHeader."Document Type";
                                    ItemChargeAssignment."Document No." := SalesHeader."No.";
                                    ItemChargeAssignment."Document Line No." := ltValueEntry."Document Line No.";
                                    ItemChargeAssignment."Line No." := ltValueEntry."Entry No.";
                                    ItemChargeAssignment."Applies-to Doc. No." := ltItemLedger."Document No.";
                                    ItemChargeAssignment."Item No." := ltItemLedger."Item No.";
                                    ItemChargeAssignment.Description := ltItemLedger.Description;
                                    ItemChargeAssignment."Amount to Assign" := ltValueEntry."Sales Amount (Actual)";
                                    ItemChargeAssignment."Qty. to Assign" := ltValueEntry."Valued Quantity";
                                    ItemChargeAssignment.Insert();

                                until ltValueEntry.Next() = 0;
                        end;
                    until ltSalesInvLine.Next() = 0;
            end;
            SalesLine.Reset();
            "Sales Line".Copy(SalesLine, true);
            SalesItemCharge.Copy(SalesLine, true);
        end;
    end;

    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure "CheckLineData"()

    begin
        SalesLine.reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        HaveItemLine := SalesLine.Count <> 0;
        SalesLine.SetRange(Type, SalesLine.Type::"Charge (Item)");
        HaveItemCharge := SalesLine.Count <> 0;
    end;

    var
        SalesHeader: Record "Sales Header" temporary;
        SalesInvoice: Record "Sales Invoice Header" temporary;
        SalesLine: Record "Sales Line" temporary;
        FunctionCenter: Codeunit "NCT Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        CustText: array[10] Of Text[250];
        SplitDate: Array[3] of Text[20];
        vgUOMFromItemCharge: Code[10];
        vgCustNoItemCharge: Code[20];
        vgQtyonShipItemCharge: Decimal;
        AmtText: Text[1024];
        TempAmt: Decimal;
        HaveItemLine: Boolean;
        HaveItemCharge: Boolean;
        groupping: Boolean;
        AccountName: text[100];
        glAccount: Record "G/L Account";
        DimThaiCaption1, DimThaiCaption2, DimEngCaption1, DimEngCaption2 : text;
        FromPosted: Boolean;

}
