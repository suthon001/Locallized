/// <summary>
/// PageExtension GenjournalBatch (ID 80085) extends Record General Journal Batches.
/// </summary>
pageextension 80085 GenjournalBatch extends "General Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; rec."Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. Series field.';
            }
        }
        modify("No. Series")
        {
            Visible = false;
        }
    }
}