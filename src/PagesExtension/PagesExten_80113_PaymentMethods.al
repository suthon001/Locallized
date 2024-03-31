/// <summary>
/// PageExtension NCT Payment Methods (ID 80113) extends Record Payment Methods.
/// </summary>
pageextension 80113 "NCT Payment Methods" extends "Payment Methods"
{
    layout
    {
        addlast(Control1)
        {
            field("NCT Payment Method"; rec."NCT Payment Method")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the NCT Payment Method field.';
            }
        }
    }
}
