/// <summary>
/// PageExtension ReCurringGenJournal (ID 80023) extends Record Recurring General Journal.
/// </summary>
pageextension 80023 "ReCurringGenJournal" extends "Recurring General Journal"
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
    }
}