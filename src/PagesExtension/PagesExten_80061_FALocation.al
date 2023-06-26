/// <summary>
/// PageExtension NCT FALocation (ID 80061) extends Record FA Locations.
/// </summary>
pageextension 80061 "NCT FALocation" extends "FA Locations"
{
    layout
    {
        addlast(Control1)
        {
            field("Location Detail"; rec."NCT Location Detail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Detail field.';
            }

        }
    }
}