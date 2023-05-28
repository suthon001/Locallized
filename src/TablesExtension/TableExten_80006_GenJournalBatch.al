/// <summary>
/// TableExtension ExtenGen.Journal Batch (ID 80006) extends Record Gen. Journal Batch.
/// </summary>
tableextension 80006 "ExtenGen.Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        field(80000; "Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;

        }
    }
}