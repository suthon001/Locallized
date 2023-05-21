pageextension 80024 "SalesJournal" extends "Sales Journal"
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
        addafter(Description)
        {
            field("Journal Description"; Rec."Journal Description")
            {
                ApplicationArea = All;
            }
        }
    }
}