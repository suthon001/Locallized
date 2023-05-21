report 50000 "AP CN Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'AP CN Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50000_APCNVoucher.rdl';
    PreviewMode = PrintLayout;
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
            column(External_Document_No_; "External Document No.") { }
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(PostingDate; format(PurHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentDate; format(PurHeader."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; PurHeader."No.") { }
            column(ExchangeRate; ExchangeRate) { }
            column(PostingDescription; PurHeader."Posting Description") { }
            Column(DueDate; PurHeader."Due Date") { }
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
            column(CreateDocBy; PurHeader."Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(AmtText; AmtText) { }
            column(HaveItemLine; HaveItemLine) { }
            column(HaveItemCharge; HaveItemCharge) { }
            column(HaveItemVAT; HaveItemVAT) { }
            trigger OnPreDataItem()
            var
                NewDate: Date;
            begin

                companyInfor.get;
                companyInfor.CalcFields(Picture);
                FunctionCenter."CompanyinformationByVat"(ComText, PurHeader."VAT Bus. Posting Group", false);
                FunctionCenter."PurchaseInformation"(PurHeader."Document Type", PurHeader."No.", VendText, 0);
                FunctionCenter."ConvExchRate"(PurHeader."Currency Code", PurHeader."Currency Factor", ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                NewDate := DT2Date(PurHeader."Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                "CheckLineData"();
            end;
        }
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.") where(Type = const(Item));


            column(No_; "No.") { }
            column(Description; Description + ' ' + "Description 2") { }
            column(Location_Code; "Location Code") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Quantity; Quantity) { }
            column(Direct_Unit_Cost; "Direct Unit Cost") { }
            column(Amount; Amount) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Line_Amount; "Line Amount") { }
            column(Return_Shipment_No_; "Return Shipment No.") { }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", PurHeader."Document Type");
                SetRange("Document No.", PurHeader."No.");
            end;
        }
        dataitem("PurchaseLineTaxInvoice"; "Purchase Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.")
            where("Tax Invoice No." = filter(<> ''));


            column(BW_Tax_Invoice_No_; "Tax Invoice No.") { }
            column(BW_Tax_Invoice_Date; format("Tax Invoice Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(BW_Tax_Invoice_Name; "Tax Invoice Name") { }
            column(BW_Tax_Invoice_Amount; "Tax Invoice Amount") { }
            column(BW_Tax_Invoice_Base; "Tax Invoice Base") { }
            column(BW_Vat_Registration_No_; "Vat Registration No.") { }
            column(BranchCode; BranchCode) { }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", PurHeader."Document Type");
                SetRange("Document No.", PurHeader."No.");
            end;

            trigger OnAfterGetRecord()
            begin
                if "Head Office" then
                    BranchCode := 'สำนักงานใหญ่'
                else
                    BranchCode := "Branch Code";

            end;
        }
        dataitem(PurchaseItemCharge; "Purchase Line")
        {
            DataItemTableView = sorting("DOcument Type", "Document No.", "Line No.")
            where(Type = const("Charge (Item)"));

            dataitem(ItemChargeAssignment; "Item Charge Assignment (Purch)")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Document Line No.", "Line NO.");
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
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
                        Item.init;
                    vgUOMFromItemCharge := Item."Base Unit of Measure";


                    IF NOT PurchRcptHeader.GET("Applies-to Doc. No.") then
                        PurchRcptHeader.init;
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
    }



    /// <summary> 
    /// Description for SetGLEntry.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    procedure "SetGLEntry"(PurchaseHeader: Record "Purchase Header")
    var
        GLTemp: Record "G/L Entry" temporary;
        PreviewPost: Codeunit EventFunction;
        EntryNo: Integer;
    begin
        TempAmt := 0;
        PurHeader.GET(PurchaseHeader."Document Type", PurchaseHeader."No.");
        PreviewPost."PurchasePreviewVourcher"(PurHeader, GLTemp);

        if GLTemp.FindFirst() then begin
            repeat
                GLEntry.reset;
                GLEntry.SetRange("G/L Account No.", GLTemp."G/L Account No.");
                GLEntry.SetRange("Global Dimension 1 Code", GLTemp."Global Dimension 1 Code");
                GLEntry.SetRange("Global Dimension 2 Code", GLTemp."Global Dimension 2 Code");
                if not GLEntry.FindFirst() then begin
                    EntryNo += 1;
                    GLEntry.init;
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
            until GLTemp.next = 0;
            GLEntry.reset;
        end;
    end;

    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure "CheckLineData"()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.reset;
        PurchaseLine.SetRange("Document Type", PurHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        HaveItemLine := PurchaseLine.Count <> 0;
        PurchaseLine.SetRange(Type);
        PurchaseLine.SetFilter("Tax Invoice No.", '<>%1', '');
        HaveItemVAT := PurchaseLine.Count <> 0;

        PurchaseLine.reset;
        PurchaseLine.SetRange("Document Type", PurHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"Charge (Item)");
        HaveItemCharge := PurchaseLine.Count <> 0;

    end;

    var
        PurHeader: Record "Purchase Header";
        FunctionCenter: Codeunit "Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[20];
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
        HaveItemVAT: Boolean;



}
