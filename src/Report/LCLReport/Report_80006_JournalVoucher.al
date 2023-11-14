/// <summary>
/// Report NCT Journal Voucher (ID 80006).
/// </summary>
report 80006 "NCT Journal Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'Journal Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80006_JournalVoucher.rdl';
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
                column(CreateDocBy; UserName) { }
                column(SplitDate_1; SplitDate[1]) { }
                column(SplitDate_2; SplitDate[2]) { }
                column(SplitDate_3; SplitDate[3]) { }
                column(AmtText; AmtText) { }
                column(HaveItemVAT; HaveItemVAT) { }
                column(GenjournalTemplate_DescThai; JournalDescriptionThai) { }
                column(GenJournalBatchName_Desc; GenJournalBatchName.Description) { }
                trigger OnAfterGetRecord()

                begin
                    if not glAccount.GET("G/L Account No.") then
                        glAccount.Init();
                    AccountName := glAccount.Name;
                end;


            }

            dataitem(GenJournalLineVAT; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("NCT Require Screen Detail" = filter(VAT));

                column(Tax_Invoice_Date; format("NCT Tax Invoice Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(Tax_Invoice_No_; "NCT Tax Invoice No.") { }
                column(Tax_Invoice_Name; "NCT Tax Invoice Name") { }
                column(Tax_Invoice_Amount; "NCT Tax Invoice Amount") { }
                column(Tax_Invoice_Base; "NCT Tax Invoice Base") { }
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
                FunctionCenter.SetReportGLEntry(GenJournalLine, GLEntry, VatEntryTemporary, TempAmt, groupping);
                "GetExchange"();
                FunctionCenter."ConvExchRate"(CurrencyCode, CurrencyFactor, ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';

                gvGenLine.reset();
                gvGenLine.SetRange("Journal Template Name", "Journal Template Name");
                gvGenLine.SetRange("Journal Batch Name", "Journal Batch Name");
                gvGenLine.SetRange("Document No.", "Document No.");
                gvGenLine.SetFilter("NCT Create By", '<>%1', '');
                if gvGenLine.FindFirst() then begin
                    UserName := gvGenLine."NCT Create By";
                    NewDate := DT2Date(gvGenLine."NCT Create DateTime");
                    SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                    SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                    SplitDate[3] := Format(NewDate, 0, '<Year4>');
                end;

                "FindPostingDescription"();
                "CheckLineData"();
                ltGenjournalTemplate.Get(GenJournalLine."Journal Template Name");
                GenJournalBatchName.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");


                JournalDescriptionThai := ltGenjournalTemplate."NCT Description Thai";
                JournalDescriptionEng := ltGenjournalTemplate."NCT Description Eng";

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
        GenLineCheck.SetRange("NCT Require Screen Detail", GenLineCheck."NCT Require Screen Detail"::VAT);
        HaveItemVAT := GenLineCheck.Count <> 0;

    end;

    var
        VatEntryTemporary: Record "Vat Entry" temporary;
        FunctionCenter: Codeunit "NCT Function Center";
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
        AccountName: text[100];
        glAccount: Record "G/L Account";
        UserName: Code[50];
        gvGenLine: Record "Gen. Journal Line";

}
