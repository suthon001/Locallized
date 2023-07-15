tableextension 80053 "NCT FA Depreciation Book" extends "FA Depreciation Book"
{
    fields
    {
        field(80000; "NCT No. of Years"; Decimal)
        {
            Caption = 'No. of Years';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if ("NCT No. of Years" <> xRec."NCT No. of Years") and ("NCT No. of Years" = 0) then
                    Validate("Depreciation Ending Date", 0D)
                else
                    Validate("Depreciation Ending Date", "NCT CalcEndingDate2"());
            end;
        }

        modify("Depreciation Starting Date")
        {
            trigger OnAfterValidate()

            begin
                "NCT CalcDeprPeriod"();
                IF "Depreciation Starting Date" <> xRec."Depreciation Starting Date" THEN
                    IF "NCT No. of Years" <> 0 THEN
                        VALIDATE("Depreciation Ending Date", "NCT CalcEndingDate2"());

            end;
        }
        modify("No. of Depreciation Years")
        {
            trigger OnAfterValidate()
            begin
                rec.Validate("NCT No. of Years", rec."No. of Depreciation Years");
            end;
        }
    }
    procedure "NCT CalcDeprPeriod"()
    var
        DeprBook2: Record "Depreciation Book";
        DepreciationCalc: Codeunit "NCT Depreciation Calculation";
        Text002: Label '%1 is later than %2.';
    begin
        IF "Depreciation Starting Date" = 0D THEN BEGIN
            "Depreciation Ending Date" := 0D;
            "No. of Depreciation Years" := 0;
            "No. of Depreciation Months" := 0;
        END;
        IF ("Depreciation Starting Date" = 0D) OR ("Depreciation Ending Date" = 0D) THEN BEGIN
            "No. of Depreciation Years" := 0;
            "No. of Depreciation Months" := 0;
        END ELSE BEGIN
            IF "Depreciation Starting Date" > "Depreciation Ending Date" THEN
                ERROR(
                  Text002,
                  FIELDCAPTION("Depreciation Starting Date"), FIELDCAPTION("Depreciation Ending Date"));
            DeprBook2.GET("Depreciation Book Code");
            IF DeprBook2."Fiscal Year 365 Days" THEN BEGIN
                "No. of Depreciation Months" := 0;
                "No. of Depreciation Years" := 0;
            END;
            IF (NOT DeprBook2."Fiscal Year 365 Days") OR (NOT DeprBook2."NCT Fiscal Year 366 Days") THEN BEGIN//TPP.LCL
                "No. of Depreciation Months" :=
                  DepreciationCalc."NCT DeprDays"("Depreciation Starting Date", "Depreciation Ending Date", FALSE, FALSE) / 30;//TPP.LCL
                "No. of Depreciation Months" := ROUND("No. of Depreciation Months", 0.00000001);
                "No. of Depreciation Years" := ROUND("No. of Depreciation Months" / 12, 0.00000001);
            END;
            "Straight-Line %" := 0;
            "Fixed Depr. Amount" := 0;
        END;

    end;

    local procedure "NCT CalcEndingDate2"(): Date
    var
        EndingDate: Date;
        FaDateCalc: Codeunit "NCT FA Date Calculation";
        DepreciationCalc: Codeunit "NCT Depreciation Calculation";
    begin
        IF "NCT No. of Years" = 0 THEN
            EXIT(0D);
        EndingDate := FADateCalc."NCT CalculateDate"(
            "Depreciation Starting Date", ROUND("NCT No. of Years" * 360, 1), FALSE, FALSE);
        EndingDate := DepreciationCalc."NCT Yesterday"(EndingDate, FALSE, FALSE);
        IF EndingDate < "Depreciation Starting Date" THEN
            EndingDate := "Depreciation Starting Date";
        EXIT(EndingDate);
    end;
}
