/// <summary>
/// Report FA G/L Journal Voucher (ID 80037).
/// </summary>
report 80037 "NCT FA G/L Journal Voucher"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'FA G/L Journal Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80037_FAGlJournalReport.rdl';
    UsageCategory = None;
    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {
            MaxIteration = 1;
            UseTemporary = true;
            dataitem(GLEntry; "G/L Entry")
            {
                DataItemTableView = sorting("Entry No.") where(Amount = filter(<> 0));
                UseTemporary = true;
                column(JournalDescriptionEng; JournalDescriptionEng) { }
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
                trigger OnAfterGetRecord()
                var
                    glAccount: Record "G/L Account";
                begin
                    if not glAccount.GET("G/L Account No.") then
                        glAccount.Init();
                    glName := glAccount.Name;
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
                PostedJournalBatch: Record "Posted Gen. Journal Batch";

            begin
                FunctionCenter.SetReportGLEntry(GenJournalLine, GLEntry, VatEntryTemporary, TempAmt, groupping, FromPosted);
                GetExchange();
                FunctionCenter."ConvExchRate"(CurrencyCode, CurrencyFactor, ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                FindPostingDescription();
                if not FromPosted then begin
                    GenJournalBatchName.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
                    JournalDescriptionThai := ltGenjournalTemplate."NCT Description Thai";
                    JournalDescriptionEng := ltGenjournalTemplate."NCT Description Eng";
                end else begin
                    PostedJournalBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
                    JournalDescriptionThai := ltGenjournalTemplate."NCT Description Thai";
                    JournalDescriptionEng := ltGenjournalTemplate."NCT Description Eng";
                end;
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
    procedure GetExchange()
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
        SplitDate: Array[3] of Text[20];
        AmtText: Text[1024];
        TempAmt: Decimal;
        CurrencyCode: Code[10];
        CurrencyFactor: Decimal;
        PostingDescription: Text[250];
        JournalDescriptionThai: Text[250];
        JournalDescriptionEng: Text[250];
        GenJournalBatchName: Record "Gen. Journal Batch";
        HaveItemVAT, groupping, FromPosted : Boolean;
        glName: Text;
        UserName: Code[50];


}
