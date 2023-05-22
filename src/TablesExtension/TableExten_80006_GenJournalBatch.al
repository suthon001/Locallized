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
        field(80001; "Description TH Voucher"; Text[100])
        {
            Caption = 'Description TH Voucher';
            DataClassification = CustomerContent;


        }
        field(80002; "Description EN Voucher"; Text[100])
        {
            Caption = 'Description EN Voucher';
            DataClassification = CustomerContent;
        }
    }
}