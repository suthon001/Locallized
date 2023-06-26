/// <summary>
/// PageExtension PurchaseJournal (ID 80025) extends Record Purchase Journal.
/// </summary>
pageextension 80025 "NCT PurchaseJournal" extends "Purchase Journal"
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