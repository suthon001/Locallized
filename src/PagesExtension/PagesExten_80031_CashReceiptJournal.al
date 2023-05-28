/// <summary>
/// PageExtension Receipt Journal (ID 80031) extends Record Cash Receipt Journal.
/// </summary>
pageextension 80031 "Receipt Journal" extends "Cash Receipt Journal"
{
    PromotedActionCategories = 'New,Process,Print,Approve,Page,Post/Print,Line,Account';
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
        addafter("VAT Amount")
        {
            field("Require Screen Detail"; Rec."Require Screen Detail")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
            }

        }
        addafter(Description)
        {
            field("Journal Description"; Rec."Journal Description")
            {
                ApplicationArea = all;
                Caption = 'Journal Description';
                ToolTip = 'Specifies the value of the Journal Description field.';
            }

            field("Pay Name"; Rec."Pay Name")
            {
                ApplicationArea = all;
                Caption = 'Pay Name';
                ToolTip = 'Specifies the value of the Pay Name field.';
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
        modify("Gen. Posting Type")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        movebefore(Amount; "Currency Code")
        moveafter(Description; Amount)
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
                ShortcutKey = 'Shift+Ctrl+S';
                ToolTip = 'Executes the Set Net Balance action.';
                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    SummaryAmount: Decimal;
                begin
                    GenJnlLine.reset();
                    GenJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", rec."Document No.");
                    GenJnlLine.SetFilter("Line No.", '<>%1', rec."Line No.");
                    if GenJnlLine.findset() then begin
                        GenJnlLine.CalcSums("Amount (LCY)");
                        SummaryAmount := GenJnlLine."Amount (LCY)";
                    end;
                    if SummaryAmount <> 0 then
                        rec.Validate("Amount (LCY)", SummaryAmount * -1)
                    else
                        rec.Validate("Amount (LCY)", 0);
                    rec.Modify();
                end;
            }
        }
        addlast(Reporting)
        {
            action("Receipt Voucher")
            {
                Caption = 'Receipt Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Receipt Voucher action.';
                trigger OnAction()
                var
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset();
                    GenJournalLIne.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLIne.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLIne.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"Receive Voucher", true, false, GenJournalLIne);
                end;
            }
            action("Print_Receipt_Tax")
            {
                ApplicationArea = All;
                Caption = 'Receipt Invoice (Apply)';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Receipt Invoice (Apply) action.';
                trigger OnAction()
                var
                    RecCustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    RecCustLedgEntry.RESET();
                    RecCustLedgEntry.SETFILTER("Applies-to ID", rec."Document No.");
                    REPORT.RUN(REPORT::"Receipt Tax Invoice", TRUE, TRUE, RecCustLedgEntry);
                end;
            }
            action("Print_Receipt")
            {
                ApplicationArea = All;
                Caption = 'Receipt Invoice';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Receipt Invoice action.';
                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                begin
                    GenJournalLine.RESET();
                    GenJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLine.SetRange("Document No.", rec."Document No.");
                    REPORT.RUN(REPORT::"Receipt Ducument", TRUE, TRUE, GenJournalLine);
                end;
            }
        }


        addbefore(Reconcile)
        {
            action("Show Detail")
            {
                Caption = 'Show Detail Vat & Cheque & WHT';
                Image = LineDescription;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Show Detail Vat & Cheque & WHT action.';
                trigger OnAction()
                var
                    ShowDetailCheque: Page "ShowDetail Cheque";
                    ShowDetailVAT: Page "ShowDetail Vat";
                    GenLineDetail: Record "Gen. Journal Line";
                    GenLine2: Record "Gen. Journal Line";
                    ShowDetailWHT: Page "ShowDetailWHT";
                    Cust: Record Customer;
                begin
                    Rec.TestField("Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    if Rec."Require Screen Detail" IN [Rec."Require Screen Detail"::VAT, Rec."Require Screen Detail"::CHEQUE, Rec."Require Screen Detail"::WHT] then begin
                        GenLineDetail.reset();
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        case rec."Require Screen Detail" OF
                            rec."Require Screen Detail"::CHEQUE:
                                begin
                                    ShowDetailCheque.SetTableView(GenLineDetail);
                                    ShowDetailCheque.RunModal();
                                    CLEAR(ShowDetailCheque);
                                end;

                            rec."Require Screen Detail"::VAT:
                                begin
                                    ShowDetailVAT.SetTableView(GenLineDetail);
                                    ShowDetailVAT.RunModal();
                                    CLEAR(ShowDetailVAT);
                                end;
                            rec."Require Screen Detail"::WHT:
                                begin
                                    if Rec."WHT Cust/Vend No." = '' then begin
                                        GenLine2.reset();
                                        GenLine2.SetRange("Journal Template Name", Rec."Journal Template Name");
                                        GenLine2.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                                        GenLine2.SetRange("Document No.", Rec."Document No.");
                                        GenLine2.SetRange("Account Type", GenLine2."Account Type"::Customer);
                                        if GenLine2.FindFirst() then
                                            if Cust.get(GenLine2."Account No.") then begin
                                                Rec."WHT Cust/Vend No." := Cust."No.";
                                                Rec."WHT Name" := Cust.Name;
                                                Rec."WHT Name 2" := Cust."Name 2";
                                                Rec."WHT Address" := Cust.Address;
                                                Rec."WHT Address 2" := Cust."Address 2";
                                                Rec."WHT Registration No." := Cust."VAT Registration No.";
                                                Rec."WHT Post Code" := Cust."Post Code";
                                                Rec."WHT City" := Cust.City;
                                                Rec."WHT County" := Cust.County;
                                                Rec.Modify();
                                                Commit();
                                            end;
                                    end;
                                    ShowDetailWHT.SetTableView(GenLineDetail);
                                    ShowDetailWHT.RunModal();
                                    Clear(ShowDetailWHT);
                                end;

                        end;
                    end else
                        MESSAGE('Nothing to Show Detail');
                end;
            }
        }
    }
}