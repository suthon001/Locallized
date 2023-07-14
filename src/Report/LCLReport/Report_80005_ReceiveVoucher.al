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
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Document No.";
            MaxIteration = 1;
            dataitem(GLEntry; "G/L Entry")
            {
                DataItemTableView = sorting("Entry No.") where(Amount = filter(<> 0));
                UseTemporary = true;
                CalcFields = "G/L Account Name";
                column(JournalDescriptionEng; JournalDescriptionEng) { }
                column(Journal_Batch_Name; "Journal Batch Name") { }
                column(JournalDescriptionThai; JournalDescriptionThai) { }
                column(G_L_Account_No_; "G/L Account No.") { }
                column(G_L_Account_Name; glName) { }
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
                column(CreateDocBy; GenJournalLine."NCT Create By") { }
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
                var
                    glAccount: Record "G/L Account";
                begin
                    glAccount.GET("G/L Account No.");
                    glName := glAccount.Name;
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
                        BranchCode := "NCT Branch Code";


                end;
            }
            dataitem(GenJournalLineWHT; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("NCT Require Screen Detail" = filter(WHT));

                column(WHT_Document_No_; "NCT WHT Document No.") { }
                column(WHT_Date; format("NCT WHT Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(WHT_Name; "NCT WHT Name" + ' ' + "NCT WHT Name 2") { }
                column(WHT__; "NCT WHT %") { }
                column(WHT_Amount; "NCT WHT Amount") { }
                column(WHT_Base; "NCT WHT Base") { }
                column(WHT_Product_Posting_Group; "NCT WHT Product Posting Group") { }
                column(WHT_Business_Posting_Group; "NCT WHT Business Posting Group") { }
                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;
            }
            dataitem(GenJournalLineBankAccount; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Account Type" = filter("Bank Account"));

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
                    GenJournalLineBank: Record "Gen. Journal Line";
                    VendorBankAccount: Record "Vendor Bank Account";
                begin
                    VendorBankAccountName := '';
                    if not BankAccount.get("Account No.") then
                        BankAccount.init();

                    BankName := BankAccount.Name + ' ' + BankAccount."Name 2";
                    BankBranchNo := BankAccount."Bank Branch No.";

                    GenJournalLineBank.RESET();
                    GenJournalLineBank.SETFILTER("Document No.", '%1', "Document No.");
                    GenJournalLineBank.SETFILTER("Account Type", '%1', GenJournalLineBank."Account Type"::Vendor);
                    GenJournalLineBank.SETFILTER("Recipient Bank Account", '<>%1', '');
                    IF GenJournalLineBank.FindFirst() THEN BEGIN
                        IF NOT VendorBankAccount.GET(GenJournalLineBank."Account No.", GenJournalLineBank."Recipient Bank Account") THEN
                            VendorBankAccount.init();
                        VendorBankAccountName := VendorBankAccount.Name;

                    END;
                end;
            }
            dataitem(GenJournalLineCheque; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("NCT Require Screen Detail" = filter(Cheque));

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
                NewDate: Date;
            begin
                FunctionCenter.SetReportGLEntry(GenJournalLine, GLEntry, TempAmt, groupping);
                GetCustExchange();
                FunctionCenter.CusInfo(CustCode, CustText);

                FunctionCenter."ConvExchRate"(CurrencyCode, CurrencyFactor, ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                NewDate := DT2Date(GenJournalLine."NCT Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                CheckLineData();
                FindPostingDescription();
                ltGenjournalTemplate.Get(GenJournalLine."Journal Template Name");
                GenJournalBatchName.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");


                JournalDescriptionThai := ltGenjournalTemplate."NCT Description Thai";
                JournalDescriptionEng := ltGenjournalTemplate."NCT Description Eng";


                CVBufferEntry.Reset();
                CVBufferEntry.DeleteAll();
                FunctionCenter.JnlFindApplyEntries(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Posting Date",
                GenJournalLine."Document No.", CVBufferEntry);
                HaveApply := CVBufferEntry.Count <> 0;
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
    /// Description for GetCustExchange.
    /// </summary>
    procedure "GetCustExchange"()
    var
        GenLine: Record "Gen. Journal Line";
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
    var
        GenLine: Record "Gen. Journal Line";
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
    var
        GenLineCheck: Record "Gen. Journal Line";
    begin
        GenLineCheck.reset();
        GenLineCheck.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLineCheck.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLineCheck.SetRange("Document No.", GenJournalLine."Document No.");
        GenLineCheck.SetRange("NCT Require Screen Detail", GenLineCheck."NCT Require Screen Detail"::VAT);
        HaveItemVAT := GenLineCheck.Count <> 0;
        GenLineCheck.SetRange("NCT Require Screen Detail", GenLineCheck."NCT Require Screen Detail"::WHT);
        HaveWHT := GenLineCheck.Count <> 0;
        GenLineCheck.SetRange("NCT Require Screen Detail", GenLineCheck."NCT Require Screen Detail"::CHEQUE);
        haveCheque := GenLineCheck.Count <> 0;
        GenLineCheck.reset();
        GenLineCheck.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLineCheck.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLineCheck.SetRange("Document No.", GenJournalLine."Document No.");
        GenLineCheck.SetRange("Account Type", GenLineCheck."Account Type"::"Bank Account");
        HaveBankAccount := GenLineCheck.Count <> 0;


    end;

    var

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

        groupping: Boolean;
        glName: text;

}
