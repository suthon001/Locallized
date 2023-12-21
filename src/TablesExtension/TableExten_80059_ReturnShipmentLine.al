/// <summary>
/// TableExtension NCT Return Shipment Line (ID 80059) extends Record Return Shipment Line.
/// </summary>
tableextension 80059 "NCT Return Shipment Line" extends "Return Shipment Line"
{
    fields
    {

        field(95000; "NCT Get to CN"; Boolean)
        {
            Caption = 'Get to CN';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
