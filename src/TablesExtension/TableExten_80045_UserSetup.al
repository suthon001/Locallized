/// <summary>
/// TableExtension UserSetup (ID 80045) extends Record User Setup.
/// </summary>
tableextension 80045 "UserSetup" extends "User Setup"
{
    fields
    {
        field(80000; "Signature"; MediaSet)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
    }
}