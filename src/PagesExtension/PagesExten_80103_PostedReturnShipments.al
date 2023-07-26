/// <summary>
/// PageExtension NCT Posted Return Shipments (ID 80103) extends Record Posted Return Shipments.
/// </summary>
pageextension 80103 "NCT Posted Return Shipments" extends "Posted Return Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Return Order No."; rec."Return Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number of the return order that will post a return shipment.';
            }
        }
    }
}
