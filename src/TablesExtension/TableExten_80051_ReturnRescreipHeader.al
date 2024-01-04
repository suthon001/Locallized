/// <summary>
/// TableExtension NCT ReturnReceiptHeader (ID 80051) extends Record Return Receipt Header.
/// </summary>
tableextension 80051 "NCT ReturnReceiptHeader" extends "Return Receipt Header"
{
    fields
    {
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
        field(80006; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}