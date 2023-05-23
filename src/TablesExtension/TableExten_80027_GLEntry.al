/// <summary>
/// TableExtension GLEntry (ID 80027) extends Record G/L Entry.
/// </summary>
tableextension 80027 GLEntry extends "G/L Entry"
{
    fields
    {
        field(80000; "Journal Description"; text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Description';
        }
        field(80001; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
        field(80002; "Template Name"; Text[10])
        {
            Caption = 'Template Name';
            DataClassification = SystemMetadata;
        }
        field(80003; "Batch Name"; Text[10])
        {
            Caption = 'Batch Name';
            DataClassification = SystemMetadata;
        }
    }
}