/// <summary>
/// PageExtension Item Reclass. Journal (ID 80010) extends Record Item Reclass. Journal.
/// </summary>
pageextension 80010 "Item Reclass. Journal" extends "Item Reclass. Journal"
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
    actions
    {
        addlast(Reporting)
        {
            action("Item Reclass")
            {
                Caption = 'Item Reclass';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Item Reclass action.';
                trigger OnAction()
                var

                    ItemJournalLine: Record "Item Journal Line";
                begin
                    ItemJournalLine.reset();
                    ItemJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    ItemJournalLine.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"NCT ItemReclass", true, true, ItemJournalLine);
                end;
            }
        }
    }
}