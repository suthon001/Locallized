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


                FunctionCenter.SetReportGLEntrySales(SalesHeader, GLEntry, TempAmt, groupping);
                companyInfor.get();
                companyInfor.CalcFields(Picture);
                if SalesHeader."Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, SalesHeader."VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, SalesHeader."VAT Bus. Posting Group", true);

                FunctionCenter."SalesInformation"(SalesHeader."Document Type", SalesHeader."No.", CustText, 1);
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

            dataitem(ItemChargeAssignment; "Item Charge Assignment (Sales)")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Document Line No.", "Line NO.");
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
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
    /// Description for SetGLEntry.
    /// </summary>
    /// <param name="SalesHrd">Parameter of type Record "Sales Header".</param>
    procedure "SetGLEntry"(SalesHrd: Record "Sales Header")
    begin
        SalesHeader.GET(SalesHrd."Document Type", SalesHrd."No.");
    end;

    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure "CheckLineData"()
    var
        SalesLine: Record "Sales Line";
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
        SalesHeader: Record "Sales Header";
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

}
