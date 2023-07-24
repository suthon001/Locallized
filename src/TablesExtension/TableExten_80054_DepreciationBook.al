/// <summary>
/// TableExtension NCT Depreciation Book (ID 80054) extends Record Depreciation Book.
/// </summary>
tableextension 80054 "NCT Depreciation Book" extends "Depreciation Book"
{
    fields
    {
        field(80000; "NCT Fiscal Year 366 Days"; Boolean)
        {
            Caption = 'Fiscal Year 366 Days';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                FADeprBook: Record "FA Depreciation Book";
            begin
                IF "Fiscal Year 365 Days" THEN BEGIN
                    TESTFIELD("Use Custom 1 Depreciation", FALSE);
                    TESTFIELD("Periodic Depr. Date Calc.", "Periodic Depr. Date Calc."::"Last Entry");
                END;
                FADeprBook.LOCKTABLE();
                MODIFY();
                FADeprBook.SETCURRENTKEY("Depreciation Book Code", "FA No.");
                FADeprBook.SETRANGE("Depreciation Book Code", Code);
                IF FADeprBook.FINDSET(TRUE) THEN
                    REPEAT
                        FADeprBook."NCT CalcDeprPeriod"();
                        FADeprBook.MODIFY();
                    UNTIL FADeprBook.NEXT() = 0;
            end;
        }
    }
}
