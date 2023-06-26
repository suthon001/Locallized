/// <summary>
/// TableExtension NCT ReturnReceiptHeader (ID 80051) extends Record Return Receipt Header.
/// </summary>
tableextension 80051 "NCT ReturnReceiptHeader" extends "Return Receipt Header"
{
    fields
    {
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