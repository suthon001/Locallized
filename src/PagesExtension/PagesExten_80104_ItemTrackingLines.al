/// 
/// <summary>
/// PageExtension NCT Item Tracking Summary (ID 80104) extends Record Item Tracking Summary.
/// </summary>
pageextension 80104 "NCT Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        modify("Expiration Date")
        {
            Visible = true;
            Editable = true;
        }
    }
}
