/// <summary>
/// TableExtension NCT FAJournalBatch (ID 80042) extends Record FA Journal Batch.
/// </summary>
tableextension 80042 "NCT FAJournalBatch" extends "FA Journal Batch"
{
    fields
    {
        field(80000; "NCT Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}