/// <summary>
/// TableExtension NCT Payment Method (ID 80062) extends Record Payment Method.
/// </summary>
tableextension 80062 "NCT Payment Method" extends "Payment Method"
{
    fields
    {
        field(80000; "NCT Payment Method"; Enum "NCT Payment Method Type")
        {
            Caption = 'NCT Payment Method';
            DataClassification = ToBeClassified;
        }
    }
}
