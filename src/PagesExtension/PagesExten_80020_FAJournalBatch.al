pageextension 80020 "JounralBatch" extends "FA Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; Rec."Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. Series field.';
            }
        }

    }
}