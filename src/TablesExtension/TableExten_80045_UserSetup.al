/// <summary>
/// TableExtension NCT UserSetup (ID 80045) extends Record User Setup.
/// </summary>
tableextension 80045 "NCT UserSetup" extends "User Setup"
{
    fields
    {
        field(80000; "NCT Signature"; MediaSet)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
    }
}