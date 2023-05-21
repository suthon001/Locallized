pageextension 80008 "Asset G/L Journal" extends "Fixed Asset G/L Journal"
{
    PromotedActionCategories = 'New,Process,Print,Page';
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
                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    SummaryAmount: Decimal;
                begin
                    GenJnlLine.reset;
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    GenJnlLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
                    if GenJnlLine.findset then begin
                        GenJnlLine.CalcSums("Amount (LCY)");
                        SummaryAmount := GenJnlLine."Amount (LCY)";
                    end;
                    if SummaryAmount <> 0 then begin
                        Rec.Validate("Amount (LCY)", SummaryAmount * -1);
                    end else
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
                trigger OnAction()
                var
                    FAGLVoucher: Report "FA G/L Journal Voucher";
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset;
                    GenJournalLIne.copy(rec);
                    FAGLVoucher."SetGLEntry"(GenJournalLIne);
                    FAGLVoucher.RunModal();
                end;
            }
        }
    }
}