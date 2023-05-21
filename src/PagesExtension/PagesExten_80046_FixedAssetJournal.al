pageextension 80046 "FixedJournalLIne" extends "Fixed Asset Journal"
{
    layout
    {
        modify("Document No.")
        {
            trigger OnAssistEdit()
            begin

                if Rec."AssistEdit"(xRec) then begin
                    CurrPage.Update();
                end;

            end;
        }
    }
}