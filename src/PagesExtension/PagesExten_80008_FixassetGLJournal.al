/// <summary>
/// PageExtension Asset G/L Journal (ID 80008) extends Record Fixed Asset G/L Journal.
/// </summary>
pageextension 80008 "NCT Asset G/L Journal" extends "Fixed Asset G/L Journal"
{
    PromotedActionCategories = 'New,Process,Print,Page';
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
        addlast("F&unctions")
        {
            action("SetNetBalance")
            {
                ApplicationArea = All;
                Caption = 'Set Net Balance';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = NewSum;
                ToolTip = 'Executes the Set Net Balance action.';
                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    SummaryAmount: Decimal;
                begin
                    GenJnlLine.reset();
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    GenJnlLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
                    if GenJnlLine.findset() then begin
                        GenJnlLine.CalcSums("Amount (LCY)");
                        SummaryAmount := GenJnlLine."Amount (LCY)";
                    end;
                    if SummaryAmount <> 0 then
                        Rec.Validate("Amount (LCY)", SummaryAmount * -1)
                    else
                        Rec.Validate("Amount (LCY)", 0);
                end;
            }
        }
        addlast(Reporting)
        {
            action("FA G/L Voucher")
            {
                Caption = 'FA G/L Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the FA G/L Voucher action.';
                trigger OnAction()
                var
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset();
                    GenJournalLIne.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLIne.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLIne.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"NCT FA G/L Journal Voucher", true, false, GenJournalLIne);
                end;
            }
        }
    }
}