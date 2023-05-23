pageextension 80048 "Requisition Name" extends "Req. Wksh. Names"
{
    layout
    {
        addafter(Description)
        {
            field("Document No. Series"; Rec."Document No. Series")
            {
                ApplicationArea = all;
                Caption = 'Document No. Series';
                ToolTip = 'Specifies the value of the Document No. Series field.';
            }
        }
    }
}