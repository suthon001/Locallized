/// <summary>
/// TableExtension NCT Return Shipment Header (ID 80058) extends Record Return Shipment Header.
/// </summary>
tableextension 80058 "NCT Return Shipment Header" extends "Return Shipment Header"
{
    fields
    {
        field(80000; "NCT Vendor Cr. Memo No."; Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80002; "NCT VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;

        }
    }
}
