/// <summary>
/// Codeunit NCT FA Date Calculation (ID 80007).
/// </summary>
codeunit 80007 "NCT FA Date Calculation"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'is later than %1';
        Text001: Label 'It was not possible to find a %1 in %2.';
        DeprBook: Record 5611;

    /// <summary>
    /// NCT GetFiscalYear.
    /// </summary>
    /// <param name="DeprBookCode">Code[10].</param>
    /// <param name="EndingDate">Date.</param>
    /// <returns>Return value of type Date.</returns>
    procedure "NCT GetFiscalYear"(DeprBookCode: Code[10]; EndingDate: Date): Date
    var
        AccountingPeriod: Record 50;
        FAJnlLine: Record 5621;
    begin

        DeprBook.GET(DeprBookCode);
        IF DeprBook."New Fiscal Year Starting Date" > 0D THEN BEGIN
            IF DeprBook."New Fiscal Year Starting Date" > EndingDate THEN
                DeprBook.FIELDERROR(
                 "New Fiscal Year Starting Date",
                 STRSUBSTNO(Text000, FAJnlLine.FIELDCAPTION("FA Posting Date")));
            EXIT(DeprBook."New Fiscal Year Starting Date");
        END;


        IF AccountingPeriod.ISEMPTY THEN
            EXIT(CALCDATE('<-CY>', EndingDate));
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETRANGE("Starting Date", 0D, EndingDate);
        IF AccountingPeriod.FINDLAST() THEN
            EXIT(AccountingPeriod."Starting Date");

        ERROR(Text001, AccountingPeriod.FIELDCAPTION("Starting Date"), AccountingPeriod.TABLECAPTION);

    end;

    /// <summary>
    /// NCT CalculateDate.
    /// </summary>
    /// <param name="StartingDate">Date.</param>
    /// <param name="NumberOfDays">Integer.</param>
    /// <param name="Year365Days">Boolean.</param>
    /// <param name="Year366Days">Boolean.</param>
    /// <returns>Return value of type Date.</returns>
    procedure "NCT CalculateDate"(StartingDate: Date; NumberOfDays: Integer; Year365Days: Boolean; Year366Days: Boolean): Date
    var
        Years: Integer;
        Days: Integer;
        Months: Integer;
        LocalDate: Date;
    begin
        IF NumberOfDays <= 0 THEN
            EXIT(StartingDate);
        IF Year365Days OR Year366Days THEN
            EXIT("NCT CalculateDate365"(StartingDate, NumberOfDays, Year366Days));

        Years := DATE2DMY(StartingDate, 3);
        Months := DATE2DMY(StartingDate, 2);
        Days := DATE2DMY(StartingDate, 1);
        IF DATE2DMY(StartingDate + 1, 1) = 1 THEN
            Days := 30;
        Days := Days + NumberOfDays;
        Months := Months + (Days DIV 30);
        Days := Days MOD 30;
        IF Days = 0 THEN BEGIN
            Days := 30;
            Months := Months - 1;
        END;
        Years := Years + (Months DIV 12);
        Months := Months MOD 12;
        IF Months = 0 THEN BEGIN
            Months := 12;
            Years := Years - 1;
        END;
        IF (Months = 2) AND (Days > 28) THEN BEGIN
            Days := 28;
            LocalDate := DMY2DATE(28, 2, Years) + 1;
            IF DATE2DMY(LocalDate, 1) = 29 THEN
                Days := 29;
        END;
        CASE Months OF
            1, 3, 5, 7, 8, 10, 12:
                IF Days = 30 THEN
                    Days := 31;
        END;
        EXIT(DMY2DATE(Days, Months, Years));
    end;

    local procedure "NCT CalculateDate365"(StartingDate: Date; NumberOfDays: Integer; Year366Days: Boolean): Date
    var
        Calendar: Record 2000000007;
        NoOfDays: Integer;
        EndingDate: Date;
        FirstDate: Boolean;
    begin

        Calendar.SETRANGE("Period Type", Calendar."Period Type"::Date);
        Calendar.SETRANGE("Period Start", StartingDate, DMY2DATE(31, 12, 9999));
        NoOfDays := 1;
        FirstDate := TRUE;
        IF Calendar.FindSet() THEN
            REPEAT
                IF (NOT ((DATE2DMY(Calendar."Period Start", 1) = 29) AND (DATE2DMY(Calendar."Period Start", 2) = 2))) OR
                   FirstDate
                THEN
                    NoOfDays := NoOfDays + 1;
                FirstDate := FALSE;
            UNTIL (Calendar.NEXT() = 0) OR (NumberOfDays < NoOfDays);
        EndingDate := Calendar."Period Start";
        IF NOT Year366Days THEN
            IF (DATE2DMY(EndingDate, 1) = 29) AND (DATE2DMY(EndingDate, 2) = 2) THEN
                EndingDate := EndingDate + 1;

        EXIT(EndingDate);

    end;
}


