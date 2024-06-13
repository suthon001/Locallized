/// <summary>
/// Report NCT Receive Voucher (ID 80005).
/// </summary>
report 80005 "NCT Receive Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'Receive Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80005_ReceiveVoucher.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {
            UseTemporary = true;
            MaxIteration = 1;
            dataitem(GLEntry; "G/L Entry")
            {
                DataItemTableView = sorting("Entry No.") where(Amount = filter(<> 0));
                UseTemporary = true;
                CalcFields = "G/L Account Name";
                column(DimThaiCaption1; DimThaiCaption1) { }
                column(DimThaiCaption2; DimThaiCaption2) { }
                column(DimEngCaption1; DimEngCaption1) { }
                column(DimEngCaption2; DimEngCaption2) { }
                column(JournalDescriptionEng; JournalDescriptionEng) { }
                column(Journal_Batch_Name; "Journal Batch Name") { }
                column(JournalDescriptionThai; JournalDescriptionThai) { }
                column(G_L_Account_No_; "G/L Account No.") { }
                column(G_L_Account_Name; AccountName) { }
                column(Debit_Amount; "Debit Amount") { }
                column(Credit_Amount; "Credit Amount") { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                column(External_Document_No_; "External Document No.") { }
                column(companyInfor_Picture; companyInfor.Picture) { }
                column(PostingDate; format(GenJournalLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(DocumentDate; format(GenJournalLine."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(DocumentNo; GenJournalLine."DOcument No.") { }
                column(ExchangeRate; ExchangeRate) { }
                column(PostingDescription; PostingDescription) { }
                column(Journal_Description; "NCT Journal Description") { }
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
                column(CreateDocBy; UserName) { }
                column(SplitDate_1; SplitDate[1]) { }
                column(SplitDate_2; SplitDate[2]) { }
                column(SplitDate_3; SplitDate[3]) { }
                column(AmtText; AmtText) { }
                column(haveCheque; haveCheque) { }
                column(HaveApply; HaveApply) { }
                column(HaveWHT; HaveWHT) { }
                column(HaveItemVAT; HaveItemVAT) { }
                column(HaveBankAccount; HaveBankAccount) { }
                column(GenjournalTemplate_DescThai; GenJournalBatchName.Description) { }
                trigger OnAfterGetRecord()

                begin
                    if not glAccount.GET("G/L Account No.") then
                        glAccount.Init();
                    AccountName := glAccount.Name;
                end;

            }
            dataitem(ApplyEntry; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                column(CVBufferEntry_DocumentNO; CVBufferEntry."Document No.") { }
                column(CVBufferEntry_ApplyAmount; CVBufferEntry."Amount to Apply") { }
                column(CVBufferEntry_RemainingAmt; CVBufferEntry."Remaining Amount") { }
                column(CVBufferEntry_DueDate; format(CVBufferEntry."Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(CVBufferEntry_DocumnentDate; format(CVBufferEntry."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(CVBufferEntry_ExternalDoc; CVBufferEntry."External Document No.") { }
                column(CV_RemimAmt; CVBufferEntry."Remaining Amount" - CVBufferEntry."Amount to Apply") { }
                column(CVBufferEntry_Golbal_Dimension_1_Code; CVBufferEntry."Global Dimension 1 Code") { }
                column(CVBufferEntry_Currency_Code; CVBufferEntry."Currency Code") { }



                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN
                        OK := CVBufferEntry.FindFirst()
                    ELSE
                        OK := CVBufferEntry.NEXT() <> 0;
                    IF NOT OK THEN
                        CurrReport.BREAK();
                end;
            }
            dataitem(GenJournalLineVAT; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("NCT Require Screen Detail" = filter(VAT));
                UseTemporary = true;
                column(Tax_Invoice_Date; format("NCT Tax Invoice Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(Tax_Invoice_No_; "NCT Tax Invoice No.") { }
                column(Tax_Invoice_Name; "NCT Tax Invoice Name") { }
                column(Tax_Invoice_Amount; ABS("NCT Tax Invoice Amount")) { }
                column(Tax_Invoice_Base; ABS("NCT Tax Invoice Base")) { }
                column(BranchCode; BranchCode) { }
                column(Vat_Registration_No_; "VAT Registration No.") { }
                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;

                trigger OnAfterGetRecord()
                begin
                    if "NCT Head Office" then
                        BranchCode := 'สำนักงานใหญ่'
                    else
                        BranchCode := "NCT VAT Branch Code";


                end;
            }
            dataitem(GenJournalLineWHT; "NCT WHT Header")
            {

                DataItemTableView = sorting("WHT No.");
                dataitem("WHT Lines"; "NCT WHT Line")
                {
                    DataItemTableView = sorting("WHT No.", "WHT Line No.");
                    DataItemLink = "WHT No." = field("WHT No.");

                    column(WHT_Document_No_; GenJournalLineWHT."WHT Certificate No.") { }
                    column(WHT_Date; format("WHT Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(WHT_Name; "WHT Name" + ' ' + "WHT Name 2") { }
                    column(WHT__; "WHT %") { }
                    column(WHT_Amount; "WHT Amount") { }
                    column(WHT_Base; "WHT Base") { }
                    column(WHT_Product_Posting_Group; "WHT Lines"."WHT Product Posting Group") { }
                    column(WHT_Business_Posting_Group; GenJournalLineWHT."WHT Business Posting Group") { }

                }
                trigger OnPreDataItem()
                begin
                    SetRange("Gen. Journal Template Code", GenJournalLine."Journal Template Name");
                    SetRange("Gen. Journal Batch Code", GenJournalLine."Journal Batch Name");
                    SetRange("Gen. Journal Document No.", GenJournalLine."Document No.");
                end;
            }
            dataitem(GenJournalLineBankAccount; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Account Type" = filter("Bank Account"));
                UseTemporary = true;
                column(BankBranchNo; BankBranchNo) { }
                column(BankName; BankName) { }
                column(VendorBankAccountName; VendorBankAccountName) { }
                column(Bank_Amount__LCY_; ABS("Amount (LCY)")) { }
                column(Bank_Account_No_; "Account No.") { }

                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;

                trigger OnAfterGetRecord()
                var
                    BankAccount: Record "Bank Account";
                    VendorBankAccount: Record "Vendor Bank Account";
                begin
                    VendorBankAccountName := '';
                    if not BankAccount.get("Account No.") then
                        BankAccount.init();

                    BankName := BankAccount.Name + ' ' + BankAccount."Name 2";
                    BankBranchNo := BankAccount."Bank Branch No.";

                    GenLine.RESET();
                    GenLine.SetRange("Journal Template Name", "Journal Template Name");
                    GenLine.SetRange("Journal Batch Name", "Journal Batch Name");
                    GenLine.SETFILTER("Document No.", '%1', "Document No.");
                    GenLine.SETFILTER("Account Type", '%1', GenLine."Account Type"::Vendor);
                    GenLine.SETFILTER("Recipient Bank Account", '<>%1', '');
                    IF GenLine.FindFirst() THEN BEGIN
                        IF NOT VendorBankAccount.GET(GenLine."Account No.", GenLine."Recipient Bank Account") THEN
                            VendorBankAccount.init();
                        VendorBankAccountName := VendorBankAccount.Name;

                    END;
                end;
            }
            dataitem(GenJournalLineCheque; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("NCT Require Screen Detail" = filter(Cheque));
                UseTemporary = true;
                column(Pay_Name; "NCT Pay Name") { }
                column(CQ_Bank_Account_No_; "NCT Bank Account No.") { }
                column(CQ_Bank_Branch_No_; "NCT Bank Branch No.") { }
                column(CQ_Bank_Code; "NCT Bank Code") { }
                column(CQ_Bank_Name; "NCT Bank Name") { }
                column(CQ_Cheque_Date; format("NCT Cheque Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(CQ_Cheque_No_; "NCT Cheque No.") { }
                column(CQ_Name; '') { }
                column(CQ_Customer_Vendor; "NCT Customer/Vendor No.") { }
                column(Cheque_Amount__LCY_; ABS("Amount (LCY)")) { }

                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;

            }
            trigger OnPreDataItem()
            begin
                companyInfor.get();
                companyInfor.CalcFields(Picture);
                FunctionCenter.CompanyInformation(ComText, false);
            end;

            trigger OnAfterGetRecord()
            var
                ltGenjournalTemplate: Record "Gen. Journal Template";
                PostedJournalBatch: Record "Posted Gen. Journal Batch";
            begin
                FunctionCenter.SetReportGLEntry(GenJournalLine, GLEntry, VatEntryTemporary, TempAmt, groupping, FromPosted);
                GetCustExchange();
                FunctionCenter.CusInfo(CustCode, CustText);

                FunctionCenter."ConvExchRate"(CurrencyCode, CurrencyFactor, ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                CheckLineData();
                FindPostingDescription();
                ltGenjournalTemplate.Get(GenJournalLine."Journal Template Name");
                if not FromPosted then begin
                    GenJournalBatchName.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
                    JournalDescriptionThai := ltGenjournalTemplate."NCT Description Thai";
                    JournalDescriptionEng := ltGenjournalTemplate."NCT Description Eng";
                end else begin
                    PostedJournalBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
                    JournalDescriptionThai := ltGenjournalTemplate."NCT Description Thai";
                    JournalDescriptionEng := ltGenjournalTemplate."NCT Description Eng";
                end;

                if ShowCustLdgr then begin
                    CVBufferEntry.Reset();
                    CVBufferEntry.DeleteAll();
                    if not FromPosted then
                        FunctionCenter.JnlFindApplyEntries(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Posting Date",
                        GenJournalLine."Document No.", CVBufferEntry)
                    else
                        FunctionCenter.PostedJnlFindApplyEntries(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Posting Date",
                        GenJournalLine."Document No.", CVBufferEntry);
                end;
                HaveApply := CVBufferEntry.Count <> 0;

                FunctionCenter.GetGlobalDimCaption(DimThaiCaption1, DimEngCaption1, DimThaiCaption2, DimEngCaption2);
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
                field(gvShowCustLdgr; ShowCustLdgr)
                {
                    Caption = 'Show Customer Apply';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show Customer Apply field.';
                }
            }
        }
        trigger OnInit()
        begin
            groupping := true;
            ShowCustLdgr := true;
        end;
    }
    /// <summary> 
    /// Description for GetCustExchange.
    /// </summary>
    procedure "GetCustExchange"()
    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetRange("Account Type", GenLine."Account Type"::Customer);
        if GenLine.FindFirst() then
            CustCode := GenLine."Account No.";
        GenLine.SetFilter("Currency Code", '<>%1', '');
        if GenLine.FindFirst() then begin
            CurrencyCode := GenLine."Currency Code";
            CurrencyFactor := GenLine."Currency Factor";
        end;
        if CustCode = '' then begin
            GenLine.reset();
            GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            GenLine.SetRange("Document No.", GenJournalLine."Document No.");
            GenLine.Setfilter("NCT Tax Vendor No.", '<>%1', '');
            if GenLine.FindFirst() then
                CustCode := GenLine."NCT Tax Vendor No.";
        end;
    end;

    /// <summary> 
    /// Description for FindPostingDescription.
    /// </summary>
    procedure FindPostingDescription()

    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("NCT Journal Description", '<>%1', '');
        if GenLine.FindFirst() then
            PostingDescription := GenLine."NCT Journal Description";
    end;




    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure CheckLineData()
    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetRange("NCT Require Screen Detail", GenLine."NCT Require Screen Detail"::VAT);
        HaveItemVAT := GenLine.Count <> 0;
        GenLine.SetRange("NCT Require Screen Detail", GenLine."NCT Require Screen Detail"::WHT);
        HaveWHT := GenLine.Count <> 0;
        GenLine.SetRange("NCT Require Screen Detail", GenLine."NCT Require Screen Detail"::CHEQUE);
        haveCheque := GenLine.Count <> 0;
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetRange("Account Type", GenLine."Account Type"::"Bank Account");
        HaveBankAccount := GenLine.Count <> 0;


    end;

    /// <summary>
    /// SetDataTable.
    /// </summary>
    /// <param name="pVariant">Variant.</param>
    procedure SetDataTable(pVariant: Variant)
    var
        ltGenLine, ltGenLine2 : Record "Gen. Journal Line";
        ltGenLineTemp: Record "Gen. Journal Line" temporary;
        ltPostedGenLine, ltPostedGenLine2 : Record "Posted Gen. Journal Line";
        ltRecordRef: RecordRef;
        NewDate: Date;
    begin
        ltRecordRef.GetTable(pVariant);
        if ltRecordRef.FindFirst() then begin
            if ltRecordRef.Number = Database::"Gen. Journal Line" then begin
                FromPosted := false;
                ltRecordRef.SetTable(ltGenLine2);
                ltGenLine.reset();
                ltGenLine.SetRange("Journal Template Name", ltGenLine2."Journal Template Name");
                ltGenLine.SetRange("Journal Batch Name", ltGenLine2."Journal Batch Name");
                ltGenLine.SetRange("Document No.", ltGenLine2."Document No.");
                if ltGenLine.FindSet() then
                    repeat
                        ltGenLineTemp.Init();
                        ltGenLineTemp.TransferFields(ltGenLine);
                        ltGenLineTemp.Insert();
                    until ltGenLine.Next() = 0;

                UserName := FunctionCenter.GetUserNameFormSystemGUID(ltGenLine2.SystemCreatedBy);
                NewDate := DT2Date(ltGenLine2.SystemCreatedAt);
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
            end else begin
                FromPosted := true;
                ltRecordRef.SetTable(ltPostedGenLine2);
                ltPostedGenLine.reset();
                ltPostedGenLine.SetRange("Journal Template Name", ltPostedGenLine2."Journal Template Name");
                ltPostedGenLine.SetRange("Journal Batch Name", ltPostedGenLine2."Journal Batch Name");
                ltPostedGenLine.SetRange("Document No.", ltPostedGenLine2."Document No.");
                if ltPostedGenLine.FindSet() then
                    repeat
                        ltGenLineTemp.Init();
                        ltGenLineTemp.TransferFields(ltPostedGenLine, false);
                        ltGenLineTemp."Journal Template Name" := ltPostedGenLine."Journal Template Name";
                        ltGenLineTemp."Journal Batch Name" := ltPostedGenLine."Journal Batch Name";
                        ltGenLineTemp."Line No." := ltPostedGenLine."Line No.";
                        ltGenLineTemp.Insert();
                    until ltPostedGenLine.Next() = 0;

                UserName := FunctionCenter.GetUserNameFormSystemGUID(ltPostedGenLine2.SystemCreatedBy);
                NewDate := DT2Date(ltPostedGenLine2.SystemCreatedAt);
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
            end;

            ltGenLineTemp.reset();
            GenJournalLine.copy(ltGenLineTemp, true);
            GenJournalLineVAT.copy(ltGenLineTemp, true);
            GenJournalLineCheque.copy(ltGenLineTemp, true);
            GenJournalLineBankAccount.copy(ltGenLineTemp, true);
            GenLine.copy(ltGenLineTemp, true);
        end;
    end;

    var
        GenLine: Record "Gen. Journal Line" temporary;

        VatEntryTemporary: Record "Vat Entry" temporary;
        FunctionCenter: Codeunit "NCT Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        CustText: array[10] Of Text[250];
        BranchCode: Text[50];
        SplitDate: Array[3] of Text[20];
        AmtText: Text[1024];
        TempAmt: Decimal;
        CustCode: Code[20];
        CurrencyCode: Code[10];
        CurrencyFactor: Decimal;
        PostingDescription: Text[250];
        CVBufferEntry: Record "CV Ledger Entry Buffer";
        OK: Boolean;
        BankName: Text[250];
        BankBranchNo: Code[30];
        VendorBankAccountName: Text[250];
        JournalDescriptionThai: Text[250];
        JournalDescriptionEng: Text[250];
        GenJournalBatchName: Record "Gen. Journal Batch";
        HaveWHT: Boolean;
        HaveItemVAT: Boolean;
        HaveBankAccount: Boolean;
        HaveApply: Boolean;
        haveCheque: Boolean;

        groupping, ShowCustLdgr, FromPosted : Boolean;
        AccountName: text[100];
        glAccount: Record "G/L Account";
        UserName: Code[50];
        DimThaiCaption1, DimThaiCaption2, DimEngCaption1, DimEngCaption2 : text;

}
