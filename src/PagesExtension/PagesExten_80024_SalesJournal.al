/// <summary>
/// PageExtension NCT SalesJournal (ID 80024) extends Record Sales Journal.
/// </summary>
pageextension 80024 "NCT SalesJournal" extends "Sales Journal"
{
    layout
    {
        modify("Document No.")
        {
            trigger OnAssistEdit()
            begin
                if Rec."AssistEdit"(xRec) then
                    CurrPage.Update();
            end;
        }
        addafter(Description)
        {
            field("Journal Description"; Rec."NCT Journal Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Journal Description field.';
            }
        }
    }
}