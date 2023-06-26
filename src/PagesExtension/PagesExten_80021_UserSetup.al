/// <summary>
/// PageExtension UserSetup (ID 80021) extends Record User Setup.
/// </summary>
pageextension 80021 "NCT UserSetup" extends "User Setup"
{
    layout
    {
        addfirst(factboxes)
        {
            part(Signature; "NCT Signature")
            {
                ApplicationArea = all;
                SubPageLink = "User ID" = field("User ID");
                Caption = 'Signature';
            }
        }
    }
}