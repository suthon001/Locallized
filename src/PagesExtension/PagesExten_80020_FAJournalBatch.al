/// <summary>
/// PageExtension NCT JounralBatch (ID 80020) extends Record FA Journal Batches.
/// </summary>
pageextension 80020 "NCT JounralBatch" extends "FA Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; Rec."NCT Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. Series field.';
            }
        }

    }
}