/// <summary>
/// TableExtension NCT GLEntry (ID 80027) extends Record G/L Entry.
/// </summary>
tableextension 80027 "NCT GLEntry" extends "G/L Entry"
{
    fields
    {
        field(80000; "NCT Journal Description"; text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Description';
        }
        field(80001; "NCT Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
    }
}