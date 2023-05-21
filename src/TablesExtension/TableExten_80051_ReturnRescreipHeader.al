tableextension 80051 ReturnReceiptHeader extends "Return Receipt Header"
{
    fields
    {
        field(80000; "Create By"; Code[30])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80001; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}