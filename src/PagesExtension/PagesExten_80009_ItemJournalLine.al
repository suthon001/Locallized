/// <summary>
/// PageExtension Item Journal Line (ID 80009) extends Record Item Journal.
/// </summary>
pageextension 80009 "Item Journal Line" extends "Item Journal"
{
    PromotedActionCategories = 'New,Process,Print,Page,Post/Print,Line,Item,Request to Approval,Approval';
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
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description 2 field.';
            }
        }
        addbefore("Document No.")
        {
            field("Status"; Rec."Status")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Bin Code")
        {
            Visible = true;
        }
        moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "Bin Code")

    }
    actions
    {
        addlast(Reporting)
        {
            action("Item Journal")
            {
                Caption = 'Item Journal';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Item Journal action.';
                trigger OnAction()
                var

                    ItemJournalLine: Record "Item Journal Line";
                begin
                    ItemJournalLine.reset();
                    ItemJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    ItemJournalLine.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"ItemJournal", true, true, ItemJournalLine);
                end;
            }
        }


    }
}