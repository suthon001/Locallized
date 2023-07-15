codeunit 80011 "NCT Table Depr. Calculation"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'There are no lines defined for %1 %2 = %3.';
        Text001: Label '%1 = %2 and %3 %4 = %5 must not be different.';
        Text002: Label 'must be an unbroken sequence';
        Text003: Label 'Period must be specified in %1.';
        Text004: Label 'The number of days in an accounting period must not be less than 5.';
        AccountingPeriod: Record 50;
        DeprBook: Record 5611;
        DeprTableHeader: Record 5642;
        DeprTableBufferTmp: Record 5646 temporary;
        DeprTableLine: Record 5643;
        DepreciationCalc: Codeunit "NCT Depreciation Calculation";
        DaysInFiscalYear: Integer;
        StartingLimit: Integer;
        EndingLimit: Integer;
        FirstPointer: Integer;
        LastPointer: Integer;
        NumberOfDays: Integer;
        Percentage: Decimal;
        Year365Days: Boolean;
        Year366Days: boolean;
        Text005: Label 'cannot be %1 when %2 is %3 in %4 %5';

    procedure "NCT GetTablePercent"(DeprBookCode: Code[10]; DeprTableCode: Code[10]; FirstUserDefinedDeprDate: Date; StartingDate: Date; EndingDate: Date): Decimal
    begin
        CLEARALL();
        IF (StartingDate = 0D) OR (EndingDate = 0D) THEN
            EXIT(0);
        IF (StartingDate > EndingDate) OR (FirstUserDefinedDeprDate > StartingDate) THEN
            EXIT(0);
        DeprBook.GET(DeprBookCode);
        DaysInFiscalYear := DeprBook."No. of Days in Fiscal Year";
        IF DaysInFiscalYear = 0 THEN
            DaysInFiscalYear := 360;
        DeprTableHeader.GET(DeprTableCode);
        Year365Days := DeprBook."Fiscal Year 365 Days";
        Year366Days := DeprBook."NCT Fiscal Year 366 Days";
        IF Year365Days THEN BEGIN
            IF (DeprTableHeader."Period Length" = DeprTableHeader."Period Length"::Month) OR
               (DeprTableHeader."Period Length" = DeprTableHeader."Period Length"::Quarter)
            THEN
                DeprTableHeader.FIELDERROR(
                  "Period Length",
                  STRSUBSTNO(
                    Text005,
                    DeprTableHeader."Period Length",
                    DeprBook.FIELDCAPTION("Fiscal Year 365 Days"),
                    DeprBook."Fiscal Year 365 Days",
                    DeprBook.TABLECAPTION, DeprBook.Code));
            DaysInFiscalYear := 365;
        END;
        StartingLimit := DepreciationCalc."NCT DeprDays"(FirstUserDefinedDeprDate, StartingDate, Year365Days, Year366Days);
        EndingLimit := DepreciationCalc."NCT DeprDays"(FirstUserDefinedDeprDate, EndingDate, Year365Days, Year366Days);
        IF NOT Year365Days THEN
            IF DATE2DMY(StartingDate, 2) = 2 THEN
                IF DATE2DMY(StartingDate + 1, 1) = 1 THEN
                    StartingLimit := StartingLimit - (30 - DATE2DMY(StartingDate, 1));

        "NCT CreateTableBuffer"(FirstUserDefinedDeprDate);
        EXIT("NCT CalculatePercent"());
    end;

    local procedure "NCT CalculatePercent"(): Decimal
    begin
        DeprTableBufferTmp.FIND('-');
        LastPointer := 0;
        Percentage := 0;

        REPEAT
            FirstPointer := LastPointer + 1;
            LastPointer := FirstPointer + DeprTableBufferTmp."No. of Days in Period" - 1;
            NumberOfDays := 0;
            IF NOT ((StartingLimit > LastPointer) OR (EndingLimit < FirstPointer)) THEN BEGIN
                IF (StartingLimit < FirstPointer) AND (EndingLimit <= LastPointer) THEN
                    NumberOfDays := EndingLimit - FirstPointer + 1;
                IF (StartingLimit < FirstPointer) AND (EndingLimit > LastPointer) THEN
                    NumberOfDays := DeprTableBufferTmp."No. of Days in Period";
                IF (StartingLimit >= FirstPointer) AND (EndingLimit <= LastPointer) THEN
                    NumberOfDays := EndingLimit - StartingLimit + 1;
                IF (StartingLimit >= FirstPointer) AND (EndingLimit > LastPointer) THEN
                    NumberOfDays := LastPointer - StartingLimit + 1;
                Percentage :=
                  Percentage + DeprTableBufferTmp."Period Depreciation %" * NumberOfDays /
                  DeprTableBufferTmp."No. of Days in Period";
            END;
        UNTIL DeprTableBufferTmp.NEXT() = 0;
        EXIT(Percentage / 100);
    end;

    local procedure "NCT CreateTableBuffer"(FirstUserDefinedDeprDate: Date)
    var
        FADeprBook: Record 5612;
        DepreciationCalc: Codeunit "NCT Depreciation Calculation";
        AccountingPeriodMgt: Codeunit 360;
        DaysInPeriod: Integer;
        TotalNoOfDays: Integer;
        PeriodNo: Integer;
    begin
        DeprTableLine.SETRANGE("Depreciation Table Code", DeprTableHeader.Code);
        IF NOT DeprTableLine.FIND('-') THEN
            ERROR(
              Text000,
              DeprTableHeader.TABLECAPTION, DeprTableHeader.FIELDCAPTION(Code), DeprTableHeader.Code);

        IF DeprTableHeader."Period Length" = DeprTableHeader."Period Length"::Period THEN
            IF AccountingPeriod.ISEMPTY THEN
                AccountingPeriodMgt.InitDefaultAccountingPeriod(AccountingPeriod, FirstUserDefinedDeprDate)
            ELSE BEGIN
                AccountingPeriod.SETFILTER("Starting Date", '>=%1', FirstUserDefinedDeprDate);
                IF AccountingPeriod.FIND('-') THEN;
                IF AccountingPeriod."Starting Date" <> FirstUserDefinedDeprDate THEN
                    ERROR(
                      Text001,
                      FADeprBook.FIELDCAPTION("First User-Defined Depr. Date"), FirstUserDefinedDeprDate,
                      AccountingPeriod.TABLECAPTION, AccountingPeriod.FIELDCAPTION("Starting Date"),
                      AccountingPeriod."Starting Date");
            END;
        CASE DeprTableHeader."Period Length" OF
            DeprTableHeader."Period Length"::Period:
                DaysInPeriod := 0;
            DeprTableHeader."Period Length"::Month:
                DaysInPeriod := 30;
            DeprTableHeader."Period Length"::Quarter:
                DaysInPeriod := 90;
            DeprTableHeader."Period Length"::Year:
                DaysInPeriod := DaysInFiscalYear;
        END;
        REPEAT
            PeriodNo := PeriodNo + 1;
            IF PeriodNo <> DeprTableLine."Period No." THEN
                DeprTableLine.FIELDERROR("Period No.", Text002);
            IF DeprTableHeader."Period Length" = DeprTableHeader."Period Length"::Period THEN BEGIN
                FirstUserDefinedDeprDate := AccountingPeriod."Starting Date";
                IF AccountingPeriod.NEXT() <> 0 THEN
                    DaysInPeriod :=
                      DepreciationCalc."NCT DeprDays"(
                        FirstUserDefinedDeprDate,
                        DepreciationCalc."NCT Yesterday"(AccountingPeriod."Starting Date", Year365Days, Year366Days),
                        Year365Days, Year366Days);
                IF DaysInPeriod = 0 THEN
                    ERROR(Text003, AccountingPeriod.TABLECAPTION);
                IF DaysInPeriod <= 5 THEN
                    ERROR(
                      Text004);
            END;
            "NCT InsertTableBuffer"(DeprTableLine, TotalNoOfDays, DaysInPeriod, PeriodNo);
        UNTIL (DeprTableLine.NEXT() = 0) OR (TotalNoOfDays > EndingLimit);

        WHILE TotalNoOfDays < EndingLimit DO BEGIN
            DeprTableBufferTmp."Entry No." := DeprTableBufferTmp."Entry No." + 1;
            DeprTableBufferTmp.INSERT();
            TotalNoOfDays := TotalNoOfDays + DaysInPeriod;
        END;
    end;

    local procedure "NCT InsertTableBuffer"(var DeprTableLine: Record "Depreciation Table Line"; var TotalNoOfDays: Integer; DaysInPeriod: Integer; PeriodNo: Integer)
    begin
        TotalNoOfDays := TotalNoOfDays + DaysInPeriod;
        DeprTableBufferTmp."Entry No." := PeriodNo;
        DeprTableBufferTmp."No. of Days in Period" := DaysInPeriod;
        IF DeprTableHeader."Total No. of Units" > 0 THEN
            DeprTableBufferTmp."Period Depreciation %" :=
              DeprTableLine."No. of Units in Period" * 100 / DeprTableHeader."Total No. of Units"
        ELSE
            DeprTableBufferTmp."Period Depreciation %" := DeprTableLine."Period Depreciation %";
        DeprTableBufferTmp.INSERT();
    end;
}


