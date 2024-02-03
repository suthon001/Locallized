/// <summary>
/// PageExtension NCT Req. Worksheet (ID 80111) extends Record Req. Worksheet.
/// </summary>
pageextension 80111 "NCT Req. Worksheet" extends "Req. Worksheet"
{
    layout
    {
        addfirst(Control1)
        {
            field("NCT Document Date"; Rec."NCT Document Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document Date field.';
            }
            field("NCT Document No."; Rec."NCT Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. field.';
                trigger OnAssistEdit()
                begin
                    if rec.AssistEdit(Xrec) then
                        CurrPage.Update();
                end;
            }
        }
    }
}
