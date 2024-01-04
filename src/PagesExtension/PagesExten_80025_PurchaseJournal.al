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
    actions
    {
        addafter(Preview)
        {
            action(YVSPreview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                ShortCutKey = 'Ctrl+Alt+F9';
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';
                trigger OnAction()
                var
                    GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    ltGenLine: Record "Gen. Journal Line";
                begin
                    ltGenLine.reset();
                    ltGenLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ltGenLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    ltGenLine.SetRange("Document No.", rec."Document No.");
                    if ltGenLine.FindFirst() then
                        GenJnlPost.Preview(ltGenLine);
                end;
            }
        }
        modify(Preview)
        {
            Visible = false;
        }
        addafter(Preview_Promoted)
        {
            actionref(NCTPreview_Promoted; YVSPreview) { }
        }
    }
}