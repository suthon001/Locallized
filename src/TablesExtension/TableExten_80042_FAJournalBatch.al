tableextension 80042 "FAJournalBatch" extends "FA Journal Batch"
{
    fields
    {
        field(80000; "Document No. Series"; code[10])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}