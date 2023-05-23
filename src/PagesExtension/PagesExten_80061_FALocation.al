pageextension 80061 "FALocation" extends "FA Locations"
{
    layout
    {
        addlast(Control1)
        {
            field("Location Detail"; rec."Location Detail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Detail field.';
            }

        }
    }
}