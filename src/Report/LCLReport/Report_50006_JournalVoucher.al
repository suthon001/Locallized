report 50006 "Journal Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'Journal Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50006_JournalVoucher.rdl';
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
                column(PostingDate; format(GenJournalLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(DocumentDate; format(GenJournalLine."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(DocumentNo; GenJournalLine."DOcument No.") { }
                column(ExchangeRate; ExchangeRate) { }
                column(PostingDescription; PostingDescription) { }
                column(Journal_Description; "Journal Description") { }
                column(ComText_1; ComText[1]) { }
                column(ComText_2; ComText[2]) { }
                column(ComText_3; ComText[3]) { }
                column(ComText_4; ComText[4]) { }
                column(ComText_5; ComText[5]) { }
                column(ComText_6; ComText[6]) { }
                column(CreateDocBy; GenJournalLine."Create By") { }
                column(SplitDate_1; SplitDate[1]) { }
                column(SplitDate_2; SplitDate[2]) { }
                column(SplitDate_3; SplitDate[3]) { }
                column(AmtText; AmtText) { }
                column(HaveItemVAT; HaveItemVAT) { }
                column(GenjournalTemplate_DescThai; JournalDescriptionThai) { }
                column(GenJournalBatchName_Desc; GenJournalBatchName.Description) { }



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
            trigger OnPreDataItem()

            begin

                companyInfor.get();
                companyInfor.CalcFields(Picture);
                FunctionCenter."CompanyInformation"(ComText, false);

            end;

            trigger OnAfterGetRecord()
            var
                ltGenjournalTemplate: Record "Gen. Journal Template";
                NewDate: Date;

            begin
                FunctionCenter.SetReportGLEntry(GenJournalLine, GLEntry, TempAmt, groupping);
                "GetExchange"();
                FunctionCenter."ConvExchRate"(CurrencyCode, CurrencyFactor, ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                NewDate := DT2Date(GenJournalLine."Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                "FindPostingDescription"();
                "CheckLineData"();
                ltGenjournalTemplate.Get(GenJournalLine."Journal Template Name");
                GenJournalBatchName.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");


                JournalDescriptionThai := ltGenjournalTemplate."Description Thai";
                JournalDescriptionEng := ltGenjournalTemplate."Description Eng";

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
    /// Description for GetExchange.
    /// </summary>
    procedure "GetExchange"()
    var
        GenLine: Record "Gen. Journal Line";
    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("Currency Code", '<>%1', '');
        if GenLine.FindFirst() then begin
            CurrencyCode := GenLine."Currency Code";
            CurrencyFactor := GenLine."Currency Factor";
        end;
    end;

    /// <summary> 
    /// Description for FindPostingDescription.
    /// </summary>
    procedure "FindPostingDescription"()
    var
        GenLine: Record "Gen. Journal Line";
    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        if GenLine.FindFirst() then
            PostingDescription := GenLine.Description;
    end;



    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure "CheckLineData"()
    var
        GenLineCheck: Record "Gen. Journal Line";
    begin
        GenLineCheck.reset();
        GenLineCheck.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLineCheck.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLineCheck.SetRange("Document No.", GenJournalLine."Document No.");
        GenLineCheck.SetRange("Require Screen Detail", GenLineCheck."Require Screen Detail"::VAT);
        HaveItemVAT := GenLineCheck.Count <> 0;

    end;

    var

        FunctionCenter: Codeunit "Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        BranchCode: Text[50];
        SplitDate: Array[3] of Text[20];
        AmtText: Text[1024];
        TempAmt: Decimal;
        CurrencyCode: Code[10];
        CurrencyFactor: Decimal;
        PostingDescription: Text[250];
        JournalDescriptionThai: Text[250];
        JournalDescriptionEng: Text[250];
        GenJournalBatchName: Record "Gen. Journal Batch";
        HaveItemVAT, groupping : Boolean;

}
