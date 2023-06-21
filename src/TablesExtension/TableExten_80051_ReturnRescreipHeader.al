/// <summary>
/// TableExtension ReturnReceiptHeader (ID 80051) extends Record Return Receipt Header.
/// </summary>
tableextension 80051 ReturnReceiptHeader extends "Return Receipt Header"
{
    fields
    {
        field(80006; "Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}