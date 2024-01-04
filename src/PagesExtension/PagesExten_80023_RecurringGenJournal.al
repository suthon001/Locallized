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