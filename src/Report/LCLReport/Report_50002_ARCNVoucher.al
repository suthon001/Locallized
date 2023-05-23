report 50002 "AR CN Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'AR CN Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50002_ARCNVoucher.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.") where(Amount = filter(<> 0));
            UseTemporary = true;
            column(G_L_Account_No_; "G/L Account No.") { }
            column(G_L_Account_Name; "G/L Account Name") { }
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
            column(CreateDocBy; SalesHeader."Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(AmtText; AmtText) { }
            column(HaveItemLine; HaveItemLine) { }
            column(HaveItemCharge; HaveItemCharge) { }
            trigger OnPreDataItem()
            var
                NewDate: Date;
            begin

                companyInfor.get();
                companyInfor.CalcFields(Picture);
                FunctionCenter."CompanyinformationByVat"(ComText, SalesHeader."VAT Bus. Posting Group", false);
                FunctionCenter."SalesInformation"(SalesHeader."Document Type", SalesHeader."No.", CustText, 0);
                FunctionCenter."ConvExchRate"(SalesHeader."Currency Code", SalesHeader."Currency Factor", ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                NewDate := DT2Date(SalesHeader."Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                "CheckLineData"();
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
            column(ReturnRecriptNo; "Return Receipt No.") { }
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



    /// <summary> 
    /// Description for SetGLEntry.
    /// </summary>
    /// <param name="SalesHrd">Parameter of type Record "Sales Header".</param>
    procedure "SetGLEntry"(SalesHrd: Record "Sales Header")
    var
        GLTemp: Record "G/L Entry" temporary;
        PreviewPost: Codeunit EventFunction;
        EntryNo: Integer;
    begin
        TempAmt := 0;
        SalesHeader.GET(SalesHrd."Document Type", SalesHrd."No.");
        PreviewPost."SalesPreviewVourcher"(SalesHeader, GLTemp);

        if GLTemp.FindFirst() then begin
            repeat
                GLEntry.reset();
                GLEntry.SetRange("G/L Account No.", GLTemp."G/L Account No.");
                GLEntry.SetRange("Global Dimension 1 Code", GLTemp."Global Dimension 1 Code");
                GLEntry.SetRange("Global Dimension 2 Code", GLTemp."Global Dimension 2 Code");
                if not GLEntry.FindFirst() then begin
                    EntryNo += 1;
                    GLEntry.init();
                    GLEntry.TransferFields(GLTemp);
                    GLEntry."Entry No." := EntryNo;
                    GLEntry.Insert();
                    TempAmt += GLEntry."Debit Amount";
                end else begin
                    GLEntry.Amount += GLTemp.Amount;
                    if GLEntry.Amount > 0 then begin
                        GLEntry."Debit Amount" := GLEntry.Amount;
                        GLEntry."Credit Amount" := 0;
                    end else begin
                        GLEntry."Credit Amount" := ABS(GLEntry.Amount);
                        GLEntry."Debit Amount" := 0;
                    end;
                    TempAmt += GLEntry."Debit Amount";
                    GLEntry.Modify();
                end;
            until GLTemp.next() = 0;
            GLEntry.reset();
        end;
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
        FunctionCenter: Codeunit "Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[20];
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


}
