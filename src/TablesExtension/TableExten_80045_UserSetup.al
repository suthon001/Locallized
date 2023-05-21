tableextension 80045 "UserSetup" extends "User Setup"
{
    fields
    {
        field(80000; "Signature"; Blob)
        {
            Subtype = Bitmap;
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
    }
}