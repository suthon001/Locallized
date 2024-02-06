/// <summary>
/// Codeunit NCT Calculate Normal Dep (ID 80012).
/// </summary>
codeunit 80012 "NCT Calculate Normal Dep"
{
    Permissions = TableData "FA Ledger Entry" = r,
                  TableData "FA Posting Type Setup" = r;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Force No. of Days must only be specified if %1 %2 = %3.';
        Text001: Label '%2 must not be 100 for %1.';
        Text002: Label '%2 must be %3 if %4 %5 = %6 for %1.';
        Text003: Label '%2 must not be later than %3 for %1.';
        Text004: Label '%1 %2 must not be used together with the Half-Year Convention for %3.';
        FA: Record "Fixed Asset";
        FALedgEntry: Record "FA Ledger Entry";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        DepreciationCalc: Codeunit "NCT Depreciation Calculation";
        DeprBookCode: Code[10];
        DaysInFiscalYear: Integer;
        EntryAmounts: array[4] of Decimal;
        MinusBookValue: Decimal;
        DateFromProjection: Date;
        SkipOnZero: Boolean;
        UntilDate: Date;
        Sign: Integer;
        FirstDeprDate: Date;
        NumberOfDays: Integer;
        NumberOfDays2: Integer;
        DaysInPeriod: Integer;
        "NCT UseDeprStartingDate": Boolean;
        BookValue: Decimal;
        BookValue2: Decimal;
        DeprBasis: Decimal;
        SalvageValue: Decimal;
        SalvageValue2: Decimal;
        AcquisitionDate: Date;
        DisposalDate: Date;
        DeprMethod: Option StraightLine,DB1,DB2,DB1SL,DB2SL,"User-Defined",Manual,BelowZero;
        DeprStartingDate: Date;
        FirstUserDefinedDeprDate: Date;
        SLPercent: Decimal;
        DBPercent: Decimal;
        FixedAmount: Decimal;
        DeprYears: Decimal;
        DeprTableCode: Code[10];
        FinalRoundingAmount: Decimal;
        EndingBookValue: Decimal;
        AmountBelowZero: Decimal;
        PercentBelowZero: Decimal;
        StartingDate: Date;
        EndingDate: Date;
        Factor: Decimal;
        UseHalfYearConvention: Boolean;
        NewYearDate: Date;
        DeprInTwoFiscalYears: Boolean;
        TempDeprAmount: Decimal;
        Text005: Label '%1 must not be used together with the Half-Year Convention for %2.';
        Text006: Label '%1 must be %2 or later for %3.';
        Text007: Label '%1 must not be used together with %2 for %3.';
        Text008: Label '%1 must not be used together with %2 = %3 for %4.';
        Year365Days: Boolean;
        Year366Days: Boolean;

    /// <summary>
    /// NCT Calculate.
    /// </summary>
    /// <param name="DeprAmount">VAR Decimal.</param>
    /// <param name="NumberOfDays4">VAR Integer.</param>
    /// <param name="FANo">Code[20].</param>
    /// <param name="DeprBookCode2">Code[10].</param>
    /// <param name="UntilDate2">Date.</param>
    /// <param name="EntryAmounts2">array[4] of Decimal.</param>
    /// <param name="DateFromProjection2">Date.</param>
    /// <param name="DaysInPeriod2">Integer.</param>
    procedure "NCT Calculate"(var DeprAmount: Decimal; var NumberOfDays4: Integer; FANo: Code[20]; DeprBookCode2: Code[10]; UntilDate2: Date; EntryAmounts2: array[4] of Decimal; DateFromProjection2: Date; DaysInPeriod2: Integer)
    var
        i: Integer;
    begin

        CLEARALL();
        DeprAmount := 0;
        NumberOfDays4 := 0;
        DeprBookCode := DeprBookCode2;
        FA.GET(FANo);
        DeprBook.GET(DeprBookCode);
        IF NOT FADeprBook.GET(FANo, DeprBookCode) THEN
            EXIT;
        UntilDate := UntilDate2;
        FOR i := 1 TO 4 DO
            EntryAmounts[i] := EntryAmounts2[i];
        DateFromProjection := DateFromProjection2;
        DaysInPeriod := DaysInPeriod2;

        FALedgEntry.LOCKTABLE();
        IF DaysInPeriod > 0 THEN
            IF DeprBook."Periodic Depr. Date Calc." <> DeprBook."Periodic Depr. Date Calc."::"Last Entry" THEN BEGIN
                DeprBook."Periodic Depr. Date Calc." := DeprBook."Periodic Depr. Date Calc."::"Last Entry";
                ERROR(
                  Text000,
                  DeprBook.TABLECAPTION, DeprBook.FIELDCAPTION("Periodic Depr. Date Calc."), DeprBook."Periodic Depr. Date Calc.");
            END;
        "NCT TransferValues"();
        IF NOT SkipRecord() THEN BEGIN
            Sign := 1;
            IF NOT FADeprBook."Use FA Ledger Check" THEN BEGIN
                IF DeprBook."Use FA Ledger Check" THEN
                    FADeprBook.TESTFIELD("Use FA Ledger Check", TRUE);
                FADeprBook.TESTFIELD("Fixed Depr. Amount below Zero", 0);
                FADeprBook.TESTFIELD("Depr. below Zero %", 0);
                Sign := DepreciationCalc."NCT GetSign"(BookValue, DeprBasis, SalvageValue, MinusBookValue);
                IF Sign = 0 THEN
                    EXIT;
                IF Sign = -1 THEN
                    DepreciationCalc."NCT GetNewSigns"(BookValue, DeprBasis, SalvageValue, MinusBookValue);
            END;
            IF (FADeprBook."Fixed Depr. Amount below Zero" > 0) OR
               (FADeprBook."Depr. below Zero %" > 0)
            THEN
                FADeprBook.TESTFIELD("Use FA Ledger Check", TRUE);

            IF BookValue + SalvageValue <= 0 THEN
                SkipOnZero := TRUE;
            IF (SalvageValue >= 0) AND (BookValue <= EndingBookValue) THEN
                SkipOnZero := TRUE;

            IF NOT
               (SkipOnZero AND
                NOT DeprBook."Allow Depr. below Zero" AND
                NOT DeprBook."Use FA Ledger Check")
            THEN BEGIN
                IF SkipOnZero THEN
                    DeprMethod := DeprMethod::BelowZero;
                DeprAmount := Sign * "NCT CalculateDeprAmount"();
                IF Sign * DeprAmount > 0 THEN
                    DeprAmount := 0;
                NumberOfDays4 := NumberOfDays2;
            END;
        END;

    end;

    local procedure SkipRecord(): Boolean
    begin
        EXIT(
          (DisposalDate > 0D) OR
          (AcquisitionDate = 0D) OR
          (DeprMethod = DeprMethod::Manual) OR
          (AcquisitionDate > UntilDate) OR
          FA.Inactive OR
          FA.Blocked);
    end;

    local procedure "NCT CalculateDeprAmount"(): Decimal
    var
        Amount: Decimal;
        DPBook: Record "Depreciation Book";
    begin
        Year366Days := FALSE;
        IF DPBook.GET(DeprBookCode) THEN
            Year366Days := DPBook."NCT Fiscal Year 366 Days";
        IF DateFromProjection > 0D THEN
            FirstDeprDate := DateFromProjection
        ELSE BEGIN
            FirstDeprDate := DepreciationCalc."NCT GetFirstDeprDate"(FA."No.", DeprBookCode, Year365Days);
            IF FirstDeprDate > UntilDate THEN
                EXIT(0);
            "NCT UseDeprStartingDate" := DepreciationCalc."NCT UseDeprStartingDate"(FA."No.", DeprBookCode);
            IF "NCT UseDeprStartingDate" THEN
                FirstDeprDate := DeprStartingDate;
        END;
        IF FirstDeprDate < DeprStartingDate THEN
            FirstDeprDate := DeprStartingDate;

        NumberOfDays := DepreciationCalc."NCT DeprDays"(FirstDeprDate, UntilDate, Year365Days, Year366Days);
        Factor := 1;
        IF NumberOfDays <= 0 THEN
            EXIT(0);
        IF DaysInPeriod > 0 THEN BEGIN
            Factor := DaysInPeriod / NumberOfDays;
            NumberOfDays := DaysInPeriod;
        END;
        UseHalfYearConvention := "NCT SetHalfYearConventionMethod"();
        // Method Last Entry
        IF "NCT UseDeprStartingDate" OR
           (DateFromProjection > 0D) OR
           (DeprMethod = DeprMethod::BelowZero) OR
           (DeprBook."Periodic Depr. Date Calc." = DeprBook."Periodic Depr. Date Calc."::"Last Entry")
        THEN BEGIN
            NumberOfDays2 := NumberOfDays;
            IF UseHalfYearConvention THEN
                Amount := "NCT CalcHalfYearConventionDepr"()
            ELSE
                CASE DeprMethod OF
                    DeprMethod::StraightLine:
                        Amount := "NCT CalcSLAmount"();
                    DeprMethod::DB1:
                        Amount := "NCT CalcDB1Amount"();
                    DeprMethod::DB2:
                        Amount := "NCT CalcDB2Amount"();
                    DeprMethod::DB1SL,
                  DeprMethod::DB2SL:
                        Amount := "NCT CalcDBSLAmount"();
                    DeprMethod::Manual:
                        Amount := 0;
                    DeprMethod::"User-Defined":
                        Amount := "NCT CalcUserDefinedAmount"(UntilDate);
                    DeprMethod::BelowZero:
                        Amount := DepreciationCalc."NCT CalcRounding"(DeprBookCode, "NCT CalcBelowZeroAmount"());
                END;
        END
        // Method Last Depreciation Entry
        ELSE BEGIN
            IF UseHalfYearConvention THEN
                DeprBook.TESTFIELD(
                  "Periodic Depr. Date Calc.", DeprBook."Periodic Depr. Date Calc."::"Last Entry");
            Amount := 0;
            StartingDate := 0D;
            EndingDate := 0D;
            DepreciationCalc."NCT GetDeprPeriod"(
              FA."No.", DeprBookCode, UntilDate, StartingDate, EndingDate, NumberOfDays, Year365Days);
            FirstDeprDate := StartingDate;
            NumberOfDays2 := DepreciationCalc."NCT DeprDays"(FirstDeprDate, UntilDate, Year365Days, Year366Days);
            WHILE NumberOfDays > 0 DO BEGIN
                DepreciationCalc."NCT CalculateDeprInPeriod"(
                  FA."No.", DeprBookCode, EndingDate, Amount, Sign,
                  BookValue, DeprBasis, SalvageValue, MinusBookValue);
                IF DepreciationCalc."NCT GetSign"(
                     BookValue, DeprBasis, SalvageValue, MinusBookValue) <> 1
                THEN
                    EXIT(0);
                CASE DeprMethod OF
                    DeprMethod::StraightLine:
                        Amount := Amount + "NCT CalcSLAmount"();
                    DeprMethod::DB1:
                        Amount := Amount + "NCT CalcDB1Amount"();
                    DeprMethod::DB2:
                        Amount := Amount + "NCT CalcDB2Amount"();
                    DeprMethod::Manual:
                        Amount := 0;
                    DeprMethod::"User-Defined":
                        Amount := Amount + "NCT CalcUserDefinedAmount"(EndingDate);
                END;
                DepreciationCalc."NCT GetDeprPeriod"(
                  FA."No.", DeprBookCode, UntilDate, StartingDate, EndingDate, NumberOfDays, Year365Days);
                FirstDeprDate := StartingDate;
            END;
        END;
        IF Amount >= 0 THEN
            EXIT(0);
        IF NOT SkipOnZero THEN
            DepreciationCalc."NCT AdjustDepr"(
              DeprBookCode, Amount, ABS(BookValue2), -ABS(SalvageValue2),
              EndingBookValue, FinalRoundingAmount);
        EXIT(ROUND(Amount));
    end;

    local procedure "NCT CalcTempDeprAmount"(var DeprAmount: Decimal): Boolean
    begin
        DeprAmount := 0;
        IF FADeprBook."Temp. Ending Date" = 0D THEN
            EXIT(FALSE);
        IF (FirstDeprDate <= FADeprBook."Temp. Ending Date") AND (UntilDate > FADeprBook."Temp. Ending Date") THEN
            ERROR(
              Text006,
              FADeprBook.FIELDCAPTION("Temp. Ending Date"),
              UntilDate,
              "NCT FAName"());
        IF FADeprBook."Temp. Ending Date" >= UntilDate THEN BEGIN
            IF FADeprBook."Use Half-Year Convention" THEN
                ERROR(
                  Text005,
                  FADeprBook.FIELDCAPTION("Temp. Ending Date"),
                  "NCT FAName"());
            IF FADeprBook."Use DB% First Fiscal Year" THEN
                ERROR(
                  Text007,
                  FADeprBook.FIELDCAPTION("Temp. Ending Date"),
                  FADeprBook.FIELDCAPTION("Use DB% First Fiscal Year"),
                  "NCT FAName"());
            IF FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::"User-Defined" THEN
                ERROR(
                  Text008,
                  FADeprBook.FIELDCAPTION("Temp. Ending Date"),
                  FADeprBook.FIELDCAPTION("Depreciation Method"),
                  FADeprBook."Depreciation Method",
                  "NCT FAName"());
            IF DeprMethod = DeprMethod::BelowZero THEN
                ERROR(
                  Text007,
                  FADeprBook.FIELDCAPTION("Temp. Ending Date"),
                  DeprBook.FIELDCAPTION("Allow Depr. below Zero"),
                  "NCT FAName"());
            DeprBook.TESTFIELD(
              "Periodic Depr. Date Calc.", DeprBook."Periodic Depr. Date Calc."::"Last Entry");
            DeprAmount := -(NumberOfDays / DaysInFiscalYear) * FADeprBook."Temp. Fixed Depr. Amount";
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;

    local procedure "NCT CalcSLAmount"(): Decimal
    var
        RemainingLife: Decimal;
    begin
        IF "NCT CalcTempDeprAmount"(TempDeprAmount) THEN
            EXIT(TempDeprAmount);

        IF SLPercent > 0 THEN
            EXIT((-SLPercent / 100) * (NumberOfDays / DaysInFiscalYear) * DeprBasis);

        IF FixedAmount > 0 THEN
            EXIT(-FixedAmount * NumberOfDays / DaysInFiscalYear);

        IF DeprYears > 0 THEN BEGIN
            RemainingLife :=
              (DeprYears * DaysInFiscalYear) -
              DepreciationCalc."NCT DeprDays"(
                DeprStartingDate, DepreciationCalc."NCT Yesterday"(FirstDeprDate, Year365Days, Year366Days), Year365Days, Year366Days);
            IF RemainingLife < 1 THEN
                EXIT(-BookValue);

            EXIT(-(BookValue + SalvageValue - MinusBookValue) * NumberOfDays / RemainingLife);
        END;
        EXIT(0);
    end;

    local procedure "NCT CalcDB1Amount"(): Decimal
    var
        DeprInFiscalYear: Decimal;
    begin
        IF "NCT CalcTempDeprAmount"(TempDeprAmount) THEN
            EXIT(TempDeprAmount);

        IF DateFromProjection = 0D THEN
            DeprInFiscalYear := DepreciationCalc."NCT DeprInFiscalYear"(FA."No.", DeprBookCode, UntilDate)
        ELSE
            DeprInFiscalYear := EntryAmounts[3];
        IF DeprInTwoFiscalYears THEN
            DeprInFiscalYear := 0;
        EXIT(
          -(DBPercent / 100) * (NumberOfDays / DaysInFiscalYear) *
          (BookValue + SalvageValue - MinusBookValue - Sign * DeprInFiscalYear));
    end;

    local procedure "NCT CalcDB2Amount"(): Decimal
    begin
        IF "NCT CalcTempDeprAmount"(TempDeprAmount) THEN
            EXIT(TempDeprAmount);

        EXIT(
          -(1 - POWER(1 - DBPercent / 100, NumberOfDays / DaysInFiscalYear)) *
          (BookValue - MinusBookValue));
    end;

    local procedure "NCT CalcDBSLAmount"(): Decimal
    var
        FADateCalc: Codeunit "NCT FA Date Calculation";
        SLAmount: Decimal;
        DBAmount: Decimal;
    begin
        IF DeprMethod = DeprMethod::DB1SL THEN
            DBAmount := "NCT CalcDB1Amount"()
        ELSE
            DBAmount := "NCT CalcDB2Amount"();
        IF FADeprBook."Use DB% First Fiscal Year" THEN
            IF FADateCalc."NCT GetFiscalYear"(DeprBookCode, UntilDate) =
               FADateCalc."NCT GetFiscalYear"(DeprBookCode, DeprStartingDate)
            THEN
                EXIT(DBAmount);
        SLAmount := "NCT CalcSLAmount"();
        IF SLAmount < DBAmount THEN
            EXIT(SLAmount);

        EXIT(DBAmount)
    end;

    local procedure "NCT CalcUserDefinedAmount"(pEndingDate: Date): Decimal
    var
        TableDeprCalc: Codeunit "NCT Table Depr. Calculation";
    begin
        IF "NCT CalcTempDeprAmount"(TempDeprAmount) THEN
            ERROR('');

        EXIT(
          -TableDeprCalc."NCT GetTablePercent"(DeprBook.Code, DeprTableCode,
            FirstUserDefinedDeprDate, FirstDeprDate, pEndingDate) *
          DeprBasis * Factor);
    end;

    local procedure "NCT CalcBelowZeroAmount"(): Decimal
    begin
        IF "NCT CalcTempDeprAmount"(TempDeprAmount) THEN
            ERROR('');

        IF PercentBelowZero > 0 THEN
            EXIT((-PercentBelowZero / 100) * (NumberOfDays / DaysInFiscalYear) * DeprBasis);
        IF AmountBelowZero > 0 THEN
            EXIT(-AmountBelowZero * NumberOfDays / DaysInFiscalYear);
        EXIT(0);
    end;

    local procedure "NCT TransferValues"()
    begin
        FADeprBook.TESTFIELD("Depreciation Starting Date");
        IF FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::"User-Defined" THEN BEGIN
            FADeprBook.TESTFIELD("Depreciation Table Code");
            FADeprBook.TESTFIELD("First User-Defined Depr. Date");
        END;
        CASE FADeprBook."Depreciation Method" OF
            FADeprBook."Depreciation Method"::"Declining-Balance 1",
          FADeprBook."Depreciation Method"::"Declining-Balance 2",
          FADeprBook."Depreciation Method"::"DB1/SL",
          FADeprBook."Depreciation Method"::"DB2/SL":
                IF FADeprBook."Declining-Balance %" >= 100 THEN
                    ERROR(Text001, "NCT FAName"(), FADeprBook.FIELDCAPTION("Declining-Balance %"));
        END;
        IF (DeprBook."Periodic Depr. Date Calc." = DeprBook."Periodic Depr. Date Calc."::"Last Depr. Entry") AND
           (FADeprBook."Depreciation Method" <> FADeprBook."Depreciation Method"::"Straight-Line")
        THEN BEGIN
            FADeprBook."Depreciation Method" := FADeprBook."Depreciation Method"::"Straight-Line";
            ERROR(
              Text002,
              "NCT FAName"(),
              FADeprBook.FIELDCAPTION("Depreciation Method"),
              FADeprBook."Depreciation Method",
              DeprBook.TABLECAPTION,
              DeprBook.FIELDCAPTION("Periodic Depr. Date Calc."),
              DeprBook."Periodic Depr. Date Calc.");
        END;

        IF DateFromProjection = 0D THEN BEGIN
            FADeprBook.CALCFIELDS("Book Value");
            BookValue := FADeprBook."Book Value";
        END ELSE
            BookValue := EntryAmounts[1];
        MinusBookValue := DepreciationCalc."NCT GetMinusBookValue"(FA."No.", DeprBookCode, 0D, 0D);
        FADeprBook.CALCFIELDS("Depreciable Basis", "Salvage Value");
        DeprBasis := FADeprBook."Depreciable Basis";
        SalvageValue := FADeprBook."Salvage Value";
        BookValue2 := BookValue;
        SalvageValue2 := SalvageValue;
        DeprMethod := FADeprBook."Depreciation Method".AsInteger();
        DeprStartingDate := FADeprBook."Depreciation Starting Date";
        DeprTableCode := FADeprBook."Depreciation Table Code";
        FirstUserDefinedDeprDate := FADeprBook."First User-Defined Depr. Date";
        IF (FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::"User-Defined") AND
           (FirstUserDefinedDeprDate > DeprStartingDate)
        THEN
            ERROR(
              Text003,
              "NCT FAName"(), FADeprBook.FIELDCAPTION("First User-Defined Depr. Date"), FADeprBook.FIELDCAPTION("Depreciation Starting Date"));
        SLPercent := FADeprBook."Straight-Line %";
        DBPercent := FADeprBook."Declining-Balance %";
        DeprYears := FADeprBook."No. of Depreciation Years";
        IF FADeprBook."Depreciation Ending Date" > 0D THEN BEGIN
            IF FADeprBook."Depreciation Starting Date" > FADeprBook."Depreciation Ending Date" THEN
                ERROR(
                  Text003,
                  "NCT FAName"(), FADeprBook.FIELDCAPTION("Depreciation Starting Date"), FADeprBook.FIELDCAPTION("Depreciation Ending Date"));
            DeprYears :=
              DepreciationCalc."NCT DeprDays"(
                FADeprBook."Depreciation Starting Date", FADeprBook."Depreciation Ending Date", FALSE, Year366Days) / 360;//TPP.LCL
        END;
        FixedAmount := FADeprBook."Fixed Depr. Amount";
        FinalRoundingAmount := FADeprBook."Final Rounding Amount";
        IF FinalRoundingAmount = 0 THEN
            FinalRoundingAmount := DeprBook."Default Final Rounding Amount";
        EndingBookValue := FADeprBook."Ending Book Value";
        IF NOT FADeprBook."Ignore Def. Ending Book Value" AND (EndingBookValue = 0) THEN
            EndingBookValue := DeprBook."Default Ending Book Value";
        AcquisitionDate := FADeprBook."Acquisition Date";
        DisposalDate := FADeprBook."Disposal Date";
        PercentBelowZero := FADeprBook."Depr. below Zero %";
        AmountBelowZero := FADeprBook."Fixed Depr. Amount below Zero";
        DaysInFiscalYear := DeprBook."No. of Days in Fiscal Year";
        IF DaysInFiscalYear = 0 THEN
            DaysInFiscalYear := 360;
        Year365Days := DeprBook."Fiscal Year 365 Days";
        //TPP.LCL
        Year366Days := DeprBook."NCT Fiscal Year 366 Days";
        IF Year365Days OR Year366Days THEN BEGIN
            IF Year366Days THEN
                DaysInFiscalYear := 366
            ELSE
                DaysInFiscalYear := 365;
            //TPP.LCL
            DeprYears :=
              DepreciationCalc."NCT DeprDays"(
                FADeprBook."Depreciation Starting Date", FADeprBook."Depreciation Ending Date", TRUE, Year366Days) / DaysInFiscalYear;//TPP.LCL
        END;

    end;

    local procedure "NCT FAName"(): Text
    var
        ltDepreciationCalc: Codeunit "NCT Depreciation Calculation";
    begin
        EXIT(ltDepreciationCalc."NCT FAName"(FA, DeprBookCode));
    end;

    local procedure "NCT SetHalfYearConventionMethod"(): Boolean
    var
        AccountingPeriod: Record 50;
    begin
        IF NOT FADeprBook."Use Half-Year Convention" THEN
            EXIT(FALSE);
        IF FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::Manual THEN
            EXIT(FALSE);
        IF DeprMethod = DeprMethod::BelowZero THEN
            EXIT(FALSE);
        IF AccountingPeriod.ISEMPTY THEN
            EXIT(FALSE);

        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETFILTER(
          "Starting Date", '>=%1',
          DepreciationCalc."NCT ToMorrow"(FADeprBook."Depreciation Starting Date", Year365Days, Year366Days));
        AccountingPeriod.FINDFIRST();
        NewYearDate := AccountingPeriod."Starting Date";
        IF FirstDeprDate >= NewYearDate THEN
            EXIT(FALSE);

        IF DeprBook."No. of Days in Fiscal Year" <> 0 THEN
            DeprBook.TESTFIELD("No. of Days in Fiscal Year", 360);
        IF DeprMethod IN
           [DeprMethod::DB2,
            DeprMethod::DB2SL,
            DeprMethod::"User-Defined"]
        THEN
            ERROR(
              Text004,
              FADeprBook.FIELDCAPTION("Depreciation Method"),
              FADeprBook."Depreciation Method",
              "NCT FAName"());
        EXIT(TRUE);
    end;

    local procedure "NCT CalcHalfYearConventionDepr"(): Decimal
    var
        DeprAmount: Decimal;
        HalfYearPercent: Decimal;
        HalfYearFactor: Decimal;
        OriginalNumberOfDays: Integer;
        OriginalBookValue: Decimal;
        OriginalFirstDeprDate: Date;
    begin
        IF "NCT CalcTempDeprAmount"(TempDeprAmount) THEN
            ERROR('');

        IF (DeprMethod = DeprMethod::DB1) OR (DeprMethod = DeprMethod::DB1SL) THEN
            HalfYearPercent := DBPercent
        ELSE
            IF SLPercent > 0 THEN
                HalfYearPercent := SLPercent
            ELSE
                IF DeprYears > 0 THEN
                    HalfYearPercent :=
                      100 /
                      (DepreciationCalc."NCT DeprDays"(NewYearDate, FADeprBook."Depreciation Ending Date", Year365Days, Year366Days) +
                       DaysInFiscalYear / 2) * DaysInFiscalYear
                ELSE
                    HalfYearPercent := 0;

        HalfYearFactor :=
          DaysInFiscalYear / 2 /
          DepreciationCalc."NCT DeprDays"(
            FADeprBook."Depreciation Starting Date",
            DepreciationCalc."NCT Yesterday"(NewYearDate, Year365Days, Year366Days),
            Year365Days, Year366Days);
        DeprInTwoFiscalYears := UntilDate >= NewYearDate;

        OriginalNumberOfDays := NumberOfDays;
        OriginalBookValue := BookValue;
        OriginalFirstDeprDate := FirstDeprDate;

        IF DeprInTwoFiscalYears THEN
            NumberOfDays :=
              DepreciationCalc."NCT DeprDays"(
                FirstDeprDate, DepreciationCalc."NCT Yesterday"(NewYearDate, Year365Days, Year366Days), Year365Days, Year366Days);
        IF FixedAmount > 0 THEN
            DeprAmount := -FixedAmount * NumberOfDays / DaysInFiscalYear * HalfYearFactor
        ELSE
            DeprAmount :=
              (-HalfYearPercent / 100) * (NumberOfDays / DaysInFiscalYear) * DeprBasis * HalfYearFactor;
        IF DeprInTwoFiscalYears THEN BEGIN
            NumberOfDays := DepreciationCalc."NCT DeprDays"(NewYearDate, UntilDate, Year365Days, Year366Days);
            FirstDeprDate := NewYearDate;
            BookValue := BookValue + DeprAmount;
            CASE DeprMethod OF
                DeprMethod::StraightLine:
                    DeprAmount := DeprAmount + "NCT CalcSLAmount"();
                DeprMethod::DB1:
                    DeprAmount := DeprAmount + "NCT CalcDB1Amount"();
                DeprMethod::DB1SL:
                    DeprAmount := DeprAmount + "NCT CalcDBSLAmount"();
            END;
        END;
        NumberOfDays := OriginalNumberOfDays;
        BookValue := OriginalBookValue;
        FirstDeprDate := OriginalFirstDeprDate;
        DeprInTwoFiscalYears := FALSE;
        EXIT(DeprAmount);
    end;
}


