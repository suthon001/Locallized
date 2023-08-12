/// <summary>
/// PageExtension ReCurringGenJournal (ID 80023) extends Record Recurring General Journal.
/// </summary>
pageextension 80023 "NCT ReCurringGenJournal" extends "Recurring General Journal"
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
        addafter("Recurring Method")
        {
            field(Correction; rec.Correction)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.';
            }
        }
    }
}