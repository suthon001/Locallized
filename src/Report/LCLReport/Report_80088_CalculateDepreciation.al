report 80088 "NCT Calculate Depreciation"
{
    ApplicationArea = all;
    Caption = 'Calculate Depreciation';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {

        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Budgeted Asset";


            trigger OnAfterGetRecord()
            begin
                IF Inactive OR Blocked THEN
                    CurrReport.SKIP();

                CalculateDepr."NCT Calculate"(
                  DeprAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
                  "No.", DeprBookCode, DeprUntilDate, EntryAmounts, 0D, DaysInPeriod);
                IF (DeprAmount <> 0) OR (Custom1Amount <> 0) THEN
                    Window.UPDATE(1, "No.")
                ELSE
                    Window.UPDATE(2, "No.");

                OnAfterCalculateDepreciation(
                  "No.", TempGenJnlLine, TempFAJnlLine, DeprAmount, NumberOfDays, DeprBookCode, DeprUntilDate, EntryAmounts, DaysInPeriod);

                IF Custom1Amount <> 0 THEN
                    IF NOT DeprBook."G/L Integration - Custom 1" OR "Budgeted Asset" THEN BEGIN
                        TempFAJnlLine."FA No." := "No.";
                        TempFAJnlLine."FA Posting Type" := TempFAJnlLine."FA Posting Type"::"Custom 1";
                        TempFAJnlLine.Amount := Custom1Amount;
                        TempFAJnlLine."No. of Depreciation Days" := Custom1NumberOfDays;
                        TempFAJnlLine."FA Error Entry No." := Custom1ErrorNo;
                        TempFAJnlLine."Line No." := TempFAJnlLine."Line No." + 1;
                        TempFAJnlLine.INSERT();
                    END ELSE BEGIN
                        TempGenJnlLine."Account No." := "No.";
                        TempGenJnlLine."FA Posting Type" := TempGenJnlLine."FA Posting Type"::"Custom 1";
                        TempGenJnlLine.Amount := Custom1Amount;
                        TempGenJnlLine."No. of Depreciation Days" := Custom1NumberOfDays;
                        TempGenJnlLine."FA Error Entry No." := Custom1ErrorNo;
                        TempGenJnlLine."Line No." := TempGenJnlLine."Line No." + 1;
                        TempGenJnlLine.INSERT();
                    END;

                IF DeprAmount <> 0 THEN
                    IF NOT DeprBook."G/L Integration - Depreciation" OR "Budgeted Asset" THEN BEGIN
                        TempFAJnlLine."FA No." := "No.";
                        TempFAJnlLine."FA Posting Type" := TempFAJnlLine."FA Posting Type"::Depreciation;
                        TempFAJnlLine.Amount := DeprAmount;
                        TempFAJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempFAJnlLine."FA Error Entry No." := ErrorNo;
                        TempFAJnlLine."Line No." := TempFAJnlLine."Line No." + 1;
                        TempFAJnlLine.INSERT();
                    END ELSE BEGIN
                        TempGenJnlLine."Account No." := "No.";
                        TempGenJnlLine."FA Posting Type" := TempGenJnlLine."FA Posting Type"::Depreciation;
                        TempGenJnlLine.Amount := DeprAmount;
                        TempGenJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempGenJnlLine."FA Error Entry No." := ErrorNo;
                        TempGenJnlLine."Line No." := TempGenJnlLine."Line No." + 1;
                        TempGenJnlLine.INSERT();
                    END;
            end;


            trigger OnPostDataItem()
            begin
                IF TempFAJnlLine.FIND('-') THEN BEGIN
                    FAJnlLine.LOCKTABLE();
                    FAJnlSetup.FAJnlName(DeprBook, FAJnlLine, FAJnlNextLineNo);
                    NoSeries := FAJnlSetup.GetFANoSeries(FAJnlLine);
                    IF DocumentNo = '' THEN
                        DocumentNo2 := FAJnlSetup.GetFAJnlDocumentNo(FAJnlLine, DeprUntilDate, TRUE)
                    ELSE
                        DocumentNo2 := DocumentNo;
                END;

                IF TempFAJnlLine.FIND('-') THEN
                    REPEAT
                        FAJnlLine.INIT();
                        FAJnlLine."Line No." := 0;
                        FAJnlSetup.SetFAJnlTrailCodes(FAJnlLine);
                        LineNo := LineNo + 1;
                        Window.UPDATE(3, LineNo);
                        FAJnlLine."Posting Date" := PostingDate;
                        FAJnlLine."FA Posting Date" := DeprUntilDate;
                        IF FAJnlLine."Posting Date" = FAJnlLine."FA Posting Date" THEN
                            FAJnlLine."Posting Date" := 0D;
                        FAJnlLine."FA Posting Type" := TempFAJnlLine."FA Posting Type";
                        FAJnlLine.VALIDATE("FA No.", TempFAJnlLine."FA No.");
                        FAJnlLine."Document No." := DocumentNo2;
                        FAJnlLine."Posting No. Series" := NoSeries;
                        FAJnlLine.Description := PostingDescription;
                        FAJnlLine.VALIDATE("Depreciation Book Code", DeprBookCode);
                        FAJnlLine.VALIDATE(Amount, TempFAJnlLine.Amount);
                        FAJnlLine."No. of Depreciation Days" := TempFAJnlLine."No. of Depreciation Days";
                        FAJnlLine."FA Error Entry No." := TempFAJnlLine."FA Error Entry No.";
                        FAJnlNextLineNo := FAJnlNextLineNo + 10000;
                        FAJnlLine."Line No." := FAJnlNextLineNo;
                        OnBeforeFAJnlLineInsert(TempFAJnlLine, FAJnlLine);
                        FAJnlLine.INSERT(TRUE);
                        FAJnlLineCreatedCount += 1;
                    UNTIL TempFAJnlLine.NEXT() = 0;

                IF TempGenJnlLine.FIND('-') THEN BEGIN
                    GenJnlLine.LOCKTABLE();
                    FAJnlSetup.GenJnlName(DeprBook, GenJnlLine, GenJnlNextLineNo);
                    NoSeries := FAJnlSetup.GetGenNoSeries(GenJnlLine);
                    IF DocumentNo = '' THEN
                        DocumentNo2 := FAJnlSetup.GetGenJnlDocumentNo(GenJnlLine, DeprUntilDate, TRUE)
                    ELSE
                        DocumentNo2 := DocumentNo;
                END;
                IF TempGenJnlLine.FIND('-') THEN
                    REPEAT
                        GenJnlLine.INIT();
                        GenJnlLine."Line No." := 0;
                        FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
                        LineNo := LineNo + 1;
                        Window.UPDATE(3, LineNo);
                        GenJnlLine."Posting Date" := PostingDate;
                        GenJnlLine."FA Posting Date" := DeprUntilDate;
                        IF GenJnlLine."Posting Date" = GenJnlLine."FA Posting Date" THEN
                            GenJnlLine."FA Posting Date" := 0D;
                        GenJnlLine."FA Posting Type" := TempGenJnlLine."FA Posting Type";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
                        GenJnlLine.VALIDATE("Account No.", TempGenJnlLine."Account No.");
                        GenJnlLine.Description := PostingDescription;
                        GenJnlLine."Document No." := DocumentNo2;
                        GenJnlLine."Posting No. Series" := NoSeries;
                        GenJnlLine.VALIDATE("Depreciation Book Code", DeprBookCode);
                        GenJnlLine.VALIDATE(Amount, TempGenJnlLine.Amount);
                        GenJnlLine."No. of Depreciation Days" := TempGenJnlLine."No. of Depreciation Days";
                        GenJnlLine."FA Error Entry No." := TempGenJnlLine."FA Error Entry No.";
                        GenJnlNextLineNo := GenJnlNextLineNo + 1000;
                        GenJnlLine."Line No." := GenJnlNextLineNo;
                        GenJnlLine.INSERT(TRUE);
                        GenJnlLineCreatedCount += 1;
                        IF BalAccount THEN
                            FAInsertGLAcc.GetBalAcc(GenJnlLine, GenJnlNextLineNo);
                    UNTIL TempGenJnlLine.NEXT() = 0;
            end;
        }

    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DepreciationBook; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies the code for the depreciation book to be included in the report or batch job.';
                    }
                    field(FAPostingDate; DeprUntilDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Posting Date';
                        Importance = Additional;
                        ToolTip = 'Specifies the fixed asset posting date to be used by the batch job. The batch job includes ledger entries up to this date. This date appears in the FA Posting Date field in the resulting journal lines. If the Use Same FA+G/L Posting Dates field has been activated in the depreciation book that is used in the batch job, then this date must be the same as the posting date entered in the Posting Date field.';

                        trigger OnValidate()
                        begin
                            DeprUntilDateModified := TRUE;
                        end;
                    }
                    field(UseForceNoOfDays; UseForceNoOfDays)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use Force No. of Days';
                        Importance = Additional;
                        ToolTip = 'Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.';

                        trigger OnValidate()
                        begin
                            IF NOT UseForceNoOfDays THEN
                                DaysInPeriod := 0;
                        end;
                    }
                    field(ForceNoOfDays; DaysInPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'Force No. of Days';
                        Importance = Additional;
                        MinValue = 0;
                        ToolTip = 'Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.';

                        trigger OnValidate()
                        begin
                            IF NOT UseForceNoOfDays AND (DaysInPeriod <> 0) THEN
                                ERROR(Text006);
                        end;
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date to be used by the batch job.';

                        trigger OnValidate()
                        begin
                            IF NOT DeprUntilDateModified THEN
                                DeprUntilDate := PostingDate;
                        end;
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies, if you leave the field empty, the next available number on the resulting journal line. If a number series is not set up, enter the document number that you want assigned to the resulting journal line.';
                    }
                    field(PostingDescription; PostingDescription)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Posting Description';
                        ToolTip = 'Specifies the posting date to be used by the batch job as a filter.';
                    }
                    field(InsertBalAccount; BalAccount)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insert Bal. Account';
                        Importance = Additional;
                        ToolTip = 'Specifies if you want the batch job to automatically insert fixed asset entries with balancing accounts.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            BalAccount := TRUE;
            PostingDate := WORKDATE();
            DeprUntilDate := WORKDATE();
            IF DeprBookCode = '' THEN BEGIN
                FASetup.GET();
                DeprBookCode := FASetup."Default Depr. Book";

            END;

        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        PageGenJnlLine: Record 81;
        PageFAJnlLine: Record 5621;
    begin
        Window.CLOSE();
        IF (FAJnlLineCreatedCount = 0) AND (GenJnlLineCreatedCount = 0) THEN BEGIN
            MESSAGE(CompletionStatsMsg);
            EXIT;
        END;

        IF FAJnlLineCreatedCount > 0 THEN
            IF CONFIRM(CompletionStatsFAJnlQst, TRUE, FAJnlLineCreatedCount)
            THEN BEGIN
                PageFAJnlLine.SETRANGE("Journal Template Name", FAJnlLine."Journal Template Name");
                PageFAJnlLine.SETRANGE("Journal Batch Name", FAJnlLine."Journal Batch Name");
                PageFAJnlLine.FINDFIRST();
                PAGE.RUN(PAGE::"Fixed Asset Journal", PageFAJnlLine);
            END;

        IF GenJnlLineCreatedCount > 0 THEN
            IF CONFIRM(CompletionStatsGenJnlQst, TRUE, GenJnlLineCreatedCount)
            THEN BEGIN
                PageGenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                PageGenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                PageGenJnlLine.FINDFIRST();
                PAGE.RUN(PAGE::"Fixed Asset G/L Journal", PageGenJnlLine);
            END;
    end;

    trigger OnPreReport()
    begin
        DeprBook.GET(DeprBookCode);
        IF DeprUntilDate = 0D THEN
            ERROR(Text000, FAJnlLine.FIELDCAPTION("FA Posting Date"));
        IF PostingDate = 0D THEN
            PostingDate := DeprUntilDate;
        IF UseForceNoOfDays AND (DaysInPeriod = 0) THEN
            ERROR(Text001);

        IF DeprBook."Use Same FA+G/L Posting Dates" AND (DeprUntilDate <> PostingDate) THEN
            ERROR(
              Text002,
              FAJnlLine.FIELDCAPTION("FA Posting Date"),
              FAJnlLine.FIELDCAPTION("Posting Date"),
              DeprBook.FIELDCAPTION("Use Same FA+G/L Posting Dates"),
              FALSE,
              DeprBook.TABLECAPTION,
              DeprBook.FIELDCAPTION(Code),
              DeprBook.Code);

        Window.OPEN(
     Text003 +
       Text004 +
       Text005);
    end;

    var
        Text000: Label 'You must specify %1.';
        Text001: Label 'Force No. of Days must be activated.';
        Text002: Label '%1 and %2 must be identical. %3 must be %4 in %5 %6 = %7.';
        Text003: Label 'Depreciating fixed asset      #1##########\';
        Text004: Label 'Not depreciating fixed asset  #2##########\';
        Text005: Label 'Inserting journal lines       #3##########';
        Text006: Label 'Use Force No. of Days must be activated.';
        GenJnlLine: Record 81;
        TempGenJnlLine: Record 81 temporary;
        FASetup: Record 5603;
        FAJnlLine: Record 5621;
        TempFAJnlLine: Record 5621 temporary;
        DeprBook: Record 5611;
        FAJnlSetup: Record 5605;
        CalculateDepr: Codeunit "NCT Calculate Depreciation";
        FAInsertGLAcc: Codeunit 5601;
        Window: Dialog;
        DeprAmount: Decimal;
        Custom1Amount: Decimal;
        NumberOfDays: Integer;
        Custom1NumberOfDays: Integer;
        DeprUntilDate: Date;
        UseForceNoOfDays: Boolean;
        DaysInPeriod: Integer;
        PostingDate: Date;
        DocumentNo: Code[20];
        DocumentNo2: Code[20];
        NoSeries: Code[20];
        PostingDescription: Text[100];
        DeprBookCode: Code[10];
        BalAccount: Boolean;
        ErrorNo: Integer;
        Custom1ErrorNo: Integer;
        FAJnlNextLineNo: Integer;
        GenJnlNextLineNo: Integer;
        EntryAmounts: array[4] of Decimal;
        LineNo: Integer;
        CompletionStatsMsg: Label 'The depreciation has been calculated.\\No journal lines were created.';
        FAJnlLineCreatedCount: Integer;
        GenJnlLineCreatedCount: Integer;
        CompletionStatsFAJnlQst: Label 'The depreciation has been calculated.\\%1 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?', Comment = 'The depreciation has been calculated.\\5 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?';
        CompletionStatsGenJnlQst: Label 'The depreciation has been calculated.\\%1 fixed asset G/L journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?', Comment = 'The depreciation has been calculated.\\2 fixed asset G/L  journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?';
        DeprUntilDateModified: Boolean;

    procedure InitializeRequest(DeprBookCodeFrom: Code[10]; DeprUntilDateFrom: Date; UseForceNoOfDaysFrom: Boolean; DaysInPeriodFrom: Integer; PostingDateFrom: Date; DocumentNoFrom: Code[20]; PostingDescriptionFrom: Text[100]; BalAccountFrom: Boolean)
    begin
        DeprBookCode := DeprBookCodeFrom;
        DeprUntilDate := DeprUntilDateFrom;
        UseForceNoOfDays := UseForceNoOfDaysFrom;
        DaysInPeriod := DaysInPeriodFrom;
        PostingDate := PostingDateFrom;
        DocumentNo := DocumentNoFrom;
        PostingDescription := PostingDescriptionFrom;
        BalAccount := BalAccountFrom;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateDepreciation(FANo: Code[20]; var TempGenJournalLine: Record 81 temporary; var TempFAJournalLine: Record 5621 temporary; var DeprAmount: Decimal; var NumberOfDays: Integer; DeprBookCode: Code[10]; DeprUntilDate: Date; EntryAmounts: array[4] of Decimal; DaysInPeriod: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFAJnlLineInsert(var TempFAJournalLine: Record 5621 temporary; FAJournalLine: Record 5621)
    begin
    end;
}

