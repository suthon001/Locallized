report 50004 "Payment Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'Payment Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50004_PaymentVoucher.rdl';
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
                column(G_L_Account_Name; "G/L Account Name") { }
                column(Debit_Amount; "Debit Amount") { }
                column(Credit_Amount; "Credit Amount") { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                column(External_Document_No_; "External Document No.") { }
                column(companyInfor_Picture; companyInfor.Picture) { }
                column(PostingDate; format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(DocumentDate; format(GenJournalLine."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(Journal_Description; "Journal Description") { }
                column(DocumentNo; GenJournalLine."DOcument No.") { }
                column(ExchangeRate; ExchangeRate) { }
                column(PostingDescription; PostingDescription) { }
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
                column(CreateDocBy; GenJournalLine."Create By") { }
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
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Require Screen Detail" = filter(VAT));

                column(BW_Tax_Invoice_Date; format("Tax Invoice Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(BW_Tax_Invoice_No_; "Tax Invoice No.") { }
                column(BW_Tax_Invoice_Name; "Tax Invoice Name") { }
                column(BW_Tax_Invoice_Amount; "Tax Invoice Amount") { }
                column(BW_Tax_Invoice_Base; "Tax Invoice Base") { }
                column(BranchCode; BranchCode) { }
                column(BW_Vat_Registration_No_; "VAT Registration No.") { }
                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;

                trigger OnAfterGetRecord()
                begin
                    if "Head Office" then
                        BranchCode := 'สำนักงานใหญ่'
                    else
                        BranchCode := "Branch Code";


                end;
            }
            dataitem(GenJournalLineWHT; "WHT Header")
            {

                DataItemTableView = sorting("WHT No.") where("posted" = const(FALSE));
                dataitem("WHT Lines"; "WHT Line")
                {
                    DataItemTableView = sorting("WHT No.", "WHT Line No.");
                    DataItemLink = "WHT No." = field("WHT No.");
                    column(BW_WHT_Document_No_; GenJournalLineWHT."WHT Certificate No.") { }
                    column(BW_WHT_Date; format("WHT Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(BW_WHT_Name; "WHT Name" + ' ' + "WHT Name 2") { }
                    column(BW_WHT__; "WHT %") { }
                    column(BW_WHT_Amount; "WHT Amount") { }
                    column(BW_WHT_Base; "WHT Base") { }
                    column(BW_WHT_Product_Posting_Group; "WHT Lines"."WHT Product Posting Group") { }
                    column(BW_WHT_Business_Posting_Group; GenJournalLineWHT."WHT Business Posting Group") { }
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
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Require Screen Detail" = filter(Cheque));

                column(BW_Pay_Name; "Pay Name") { }
                column(BW_CQ_Bank_Account_No_; "Bank Account No.") { }
                column(BW_CQ_Bank_Branch_No_; "Bank Branch No.") { }
                column(BW_CQ_Bank_Code; "Bank Code") { }
                column(BW_CQ_Bank_Name; "Bank Name") { }
                column(BW_CQ_Cheque_Date; format("Cheque Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(BW_CQ_Cheque_No_; "Cheque No.") { }
                column(BW_CQ_Name; '') { }
                column(BW_CQ_Customer_Vendor; "Customer/Vendor NO.") { }
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
                GetVendorExchange();
                FunctionCenter."VendInfo"(VendorCode, VendText);

                FunctionCenter."ConvExchRate"(CurrencyCode, CurrencyFactor, ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                NewDate := DT2Date(GenJournalLine."Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                CheckLineData();
                FindPostingDescription();

                ltGenjournalTemplate.Get(GenJournalLine."Journal Template Name");
                GenJournalBatchName.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");


                JournalDescriptionThai := ltGenjournalTemplate."Description Thai";
                JournalDescriptionEng := ltGenjournalTemplate."Description Eng";


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
                    Caption = 'Grouping';
                }
            }
        }
        trigger OnInit()
        begin
            groupping := true;
        end;
    }
    /// <summary> 
    /// Description for GetVendorExchange.
    /// </summary>
    procedure GetVendorExchange()
    var
        GenLine: Record "Gen. Journal Line";
    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetRange("Account Type", GenLine."Account Type"::Vendor);
        if GenLine.FindFirst() then
            VendorCode := GenLine."Account No.";
        GenLine.SetFilter("Currency Code", '<>%1', '');
        if GenLine.FindFirst() then begin
            CurrencyCode := GenLine."Currency Code";
            CurrencyFactor := GenLine."Currency Factor";
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
        GenLine.SetFilter("Journal Description", '<>%1', '');
        if GenLine.FindFirst() then
            PostingDescription := GenLine."Journal Description";
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
        GenLineCheck.SetRange("Require Screen Detail", GenLineCheck."Require Screen Detail"::VAT);
        HaveItemVAT := GenLineCheck.Count <> 0;
        GenLineCheck.SetRange("Require Screen Detail", GenLineCheck."Require Screen Detail"::WHT);
        HaveWHT := GenLineCheck.Count <> 0;
        GenLineCheck.SetRange("Require Screen Detail", GenLineCheck."Require Screen Detail"::CHEQUE);
        haveCheque := GenLineCheck.Count <> 0;
        GenLineCheck.reset();
        GenLineCheck.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLineCheck.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLineCheck.SetRange("Document No.", GenJournalLine."Document No.");
        GenLineCheck.SetRange("Account Type", GenLineCheck."Account Type"::"Bank Account");
        HaveBankAccount := GenLineCheck.Count <> 0;
    end;


    var
        FunctionCenter: Codeunit "Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        VendText: array[10] Of Text[250];
        BranchCode: Text[50];
        SplitDate: Array[3] of Text[20];
        AmtText: Text[1024];
        TempAmt: Decimal;
        VendorCode: Code[20];
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


}
