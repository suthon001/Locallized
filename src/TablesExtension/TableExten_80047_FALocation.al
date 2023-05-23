/// <summary>
/// TableExtension FALocation (ID 80047) extends Record FA Location.
/// </summary>
tableextension 80047 "FALocation" extends "FA Location"
{
    fields
    {
        field(80000; "Location Detail"; Text[2047])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Detail';
        }
    }
}