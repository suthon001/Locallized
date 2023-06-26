/// <summary>
/// PageExtension NCT Requisition Name (ID 80048) extends Record Req. Wksh. Names.
/// </summary>
pageextension 80048 "NCT Requisition Name" extends "Req. Wksh. Names"
{
    layout
    {
        addafter(Description)
        {
            field("Document No. Series"; Rec."NCT Document No. Series")
            {
                ApplicationArea = all;
                Caption = 'Document No. Series';
                ToolTip = 'Specifies the value of the Document No. Series field.';
            }
        }
    }
}