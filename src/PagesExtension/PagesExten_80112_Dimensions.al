/// <summary>
/// PageExtension NCT Dimensions (ID 80112) extends Record Dimensions.
/// </summary>
pageextension 80112 "NCT Dimensions" extends Dimensions
{
    layout
    {
        addafter(Description)
        {
            field("Thai Description"; rec."Thai Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Thai Description field.';
            }
        }
    }
}
