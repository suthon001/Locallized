/// <summary>
/// PageExtension Receipt Journal (ID 80031) extends Record Cash Receipt Journal.
/// </summary>
pageextension 80031 "NCT Receipt Journal" extends "Cash Receipt Journal"
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
            field("Require Screen Detail"; Rec."NCT Require Screen Detail")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
            }

        }
        addafter(Description)
        {
            field("Journal Description"; Rec."NCT Journal Description")
            {
                ApplicationArea = all;
                Caption = 'Journal Description';
                ToolTip = 'Specifies the value of the Journal Description field.';
            }

            field("Pay Name"; Rec."NCT Pay Name")
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
        modify("Document Date")
        {
            Visible = true;
        }
        moveafter("Posting Date"; "Document Date")
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
                PromotedCategory = Category6;
                Promoted = true;
                PromotedIsBig = true;
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
                    ReceiveVoucher: Report "NCT Receive Voucher";
                begin
                    CLEAR(ReceiveVoucher);
                    GenJournalLIne.reset();
                    GenJournalLIne.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLIne.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLIne.SetRange("Document No.", rec."Document No.");
                    if GenJournalLIne.FindFirst() then
                        ReceiveVoucher.SetDataTable(GenJournalLIne);
                    ReceiveVoucher.RunModal();
                    CLEAR(ReceiveVoucher);
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
                    REPORT.RUN(REPORT::"NCT Receipt Tax Invoice", TRUE, TRUE, RecCustLedgEntry);
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
                    ShowDetailCheque: Page "NCT ShowDetail Cheque";
                    ShowDetailVAT: Page "NCT ShowDetail Vat";
                    GenLineDetail: Record "Gen. Journal Line";
                    GenLine2: Record "Gen. Journal Line";
                    ShowDetailWHT: Page "NCT ShowDetailWHT";
                    Cust: Record Customer;
                begin
                    Rec.TestField("NCT Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    if Rec."NCT Require Screen Detail" IN [Rec."NCT Require Screen Detail"::VAT, Rec."NCT Require Screen Detail"::CHEQUE, Rec."NCT Require Screen Detail"::WHT] then begin
                        GenLineDetail.reset();
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        case rec."NCT Require Screen Detail" OF
                            rec."NCT Require Screen Detail"::CHEQUE:
                                begin
                                    ShowDetailCheque.SetTableView(GenLineDetail);
                                    ShowDetailCheque.RunModal();
                                    CLEAR(ShowDetailCheque);
                                end;

                            rec."NCT Require Screen Detail"::VAT:
                                begin
                                    ShowDetailVAT.SetTableView(GenLineDetail);
                                    ShowDetailVAT.RunModal();
                                    CLEAR(ShowDetailVAT);
                                end;
                            rec."NCT Require Screen Detail"::WHT:
                                begin
                                    if Rec."NCT WHT Cust/Vend No." = '' then begin
                                        GenLine2.reset();
                                        GenLine2.SetRange("Journal Template Name", Rec."Journal Template Name");
                                        GenLine2.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                                        GenLine2.SetRange("Document No.", Rec."Document No.");
                                        GenLine2.SetRange("Account Type", GenLine2."Account Type"::Customer);
                                        if GenLine2.FindFirst() then
                                            if Cust.get(GenLine2."Account No.") then begin
                                                if rec."NCT Ref. Billing & Receipt No." <> '' then begin
                                                    rec."NCT WHT Document No." := rec."NCT Ref. Receipt WHT No.";
                                                    rec."NCT WHT Date" := rec."NCT Ref. Receipt WHT Date";
                                                    rec."NCT WHT Amount" := abs(rec.Amount);
                                                end;
                                                Rec."NCT WHT Cust/Vend No." := Cust."No.";
                                                Rec."NCT WHT Name" := Cust.Name;
                                                Rec."NCT WHT Name 2" := Cust."Name 2";
                                                Rec."NCT WHT Address" := Cust.Address;
                                                Rec."NCT WHT Address 2" := Cust."Address 2";
                                                Rec."NCT WHT Registration No." := Cust."VAT Registration No.";
                                                Rec."NCT WHT Post Code" := Cust."Post Code";
                                                Rec."NCT WHT City" := Cust.City;
                                                Rec."NCT WHT County" := Cust.County;
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
    trigger OnDeleteRecord(): Boolean
    var
        PurchaseBilling: Record "NCT Billing Receipt Header";
    begin
        if rec."NCT Ref. Billing & Receipt No." <> '' then
            if PurchaseBilling.GET(PurchaseBilling."Document Type"::"Sales Receipt", rec."NCT Ref. Billing & Receipt No.") then begin
                PurchaseBilling."Status" := PurchaseBilling."Status"::Released;
                PurchaseBilling."Create to Journal" := false;
                PurchaseBilling.Modify();
            end;
    end;

    trigger OnOpenPage()
    begin
        if gvDocument <> '' then
            rec.SetRange("Document No.", gvDocument);
    end;

    /// <summary>
    /// SetDocumnet.
    /// </summary>
    /// <param name="pDocument">code[20].</param>
    procedure SetDocumnet(pDocument: code[20])
    begin
        gvDocument := pDocument;
    end;

    var
        gvDocument: Code[20];
}