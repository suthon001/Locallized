pageextension 80025 "PurchaseJournal" extends "Purchase Journal"
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