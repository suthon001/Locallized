tableextension 80048 "Requisition Name" extends "Requisition Wksh. Name"
{
    fields
    {
        field(80000; "Document No. Series"; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }

    }
}