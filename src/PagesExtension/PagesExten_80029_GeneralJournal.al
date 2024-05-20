/// <summary>
/// PageExtension General Journal (ID 80029) extends Record General Journal.
/// </summary>
pageextension 80029 "NCT General Journal" extends "General Journal"
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
        addafter("VAT Amount")
        {
            field("Require Screen Detail"; Rec."NCT Require Screen Detail")
            {
                ApplicationArea = all;
                Caption = 'Require Screen Detail';
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
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
        addafter(Description)
        {
            field("Journal Description"; Rec."NCT Journal Description")
            {
                ApplicationArea = All;
                Caption = 'Journal Description';
                ToolTip = 'Specifies the value of the Journal Description field.';
            }
        }
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
                PromotedCategory = Category9;
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
        addfirst(processing)
        {
            action("WHT Certificate")
            {
                ApplicationArea = all;
                Image = InsertFromCheckJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'WHT Certificate';
                ToolTip = 'Executes the WHT Certificate action.';
                trigger OnAction()
                begin
                    // TestField("Require Screen Detail", "Require Screen Detail"::WHT);
                    "InsertWHTCertificate"();
                end;
            }
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
                    if Rec."NCT Require Screen Detail" IN [Rec."NCT Require Screen Detail"::VAT, Rec."NCT Require Screen Detail"::WHT] then begin
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
        addlast(Reporting)
        {
            action("Journal Voucher")
            {
                Caption = 'Journal Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Journal Voucher action.';
                trigger OnAction()
                var
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset();
                    GenJournalLIne.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLIne.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLIne.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"NCT Journal Voucher", true, false, GenJournalLIne);
                end;
            }
        }

    }
    /// <summary>
    /// InsertWHTCertificate.
    /// </summary>
    procedure "InsertWHTCertificate"()
    var
        GeneralSetup: Record "General Ledger Setup";
        WHTHeader: Record "NCT WHT Header";
        NosMgt: Codeunit "No. Series";
        GenJnlLine: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        Customer: Record Customer;
        WHTDocNo: Code[30];
        PageWHTCer: Page "NCT WHT Certificate";
        GenJnlLine3: Record "Gen. Journal Line";
    begin
        if rec."NCT WHT Document No." = '' then begin
            GenJnlLine3.Reset();
            GenJnlLine3.SetRange("Journal Template Name", rec."Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", rec."Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", rec."Document No.");
            GenJnlLine3.SetFilter("NCT WHT Document No.", '<>%1', '');
            if not GenJnlLine3.IsEmpty then
                if not Confirm('This document already have wht certificate do you want to create more wht certificate ?') then
                    exit;
        end;
        GeneralSetup.GET();
        GeneralSetup.TESTFIELD("NCT WHT Document Nos.");
        IF rec."NCT WHT Document No." = '' THEN BEGIN
            IF NOT CONFIRM('Do you want to create wht certificated') THEN
                EXIT;

            GenJnlLine.RESET();
            GenJnlLine.SETRANGE("Journal Template Name", rec."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", rec."Journal Batch Name");
            GenJnlLine.SETFILTER("Document No.", '%1', rec."Document No.");
            GenJnlLine.SETFILTER("Account Type", '%1|%2|%3', GenJnlLine."Account Type"::"G/L Account", GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Customer);
            OnSetFIlterWhtCetificate(GenJnlLine, rec);
            IF GenJnlLine.FindFirst() THEN BEGIN
                WHTHeader.INIT();
                WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."NCT WHT Document Nos.", rec."Posting Date", TRUE);
                WHTDocNo := WHTHeader."WHT No.";
                WHTHeader."Gen. Journal Template Code" := rec."Journal Template Name";
                WHTHeader."Gen. Journal Batch Code" := rec."Journal Batch Name";
                WHTHeader."Gen. Journal Document No." := rec."Document No.";
                WHTHeader."WHT Date" := rec."Document Date";
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET(GenJnlLine."Account No.") THEN BEGIN

                        WHTHeader."WHT Business Posting Group" := Vendor."NCT WHT Business Posting Group";
                        WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Vendor;
                        WHTHeader.validate("WHT Source No.", Vendor."No.");
                    END;
                END ELSE
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
                        IF Customer.GET(GenJnlLine."Account No.") THEN BEGIN
                            WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Customer;
                            WHTHeader.validate("WHT Source No.", Customer."No.");
                        END;
            END;
            OnbeforInsertWhtHeader(WHTHeader, rec);
            WHTHeader.INSERT();
            rec.Modify();
        END ELSE
            WHTDocNo := rec."NCT WHT Document No.";

        commit();
        CLEAR(PageWHTCer);
        WHTHeader.reset();
        WHTHeader.SetRange("WHT No.", WHTDocNo);
        PageWHTCer.SetTableView(WHTHeader);
        if PageWHTCer.RunModal() IN [Action::OK] then
            CurrPage.Update();
        CLEAR(PageWHTCer);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        WHTEader: Record "NCT WHT Header";
    begin
        WHTEader.reset();
        WHTEader.SetRange("Gen. Journal Template Code", rec."Journal Template Name");
        WHTEader.SetRange("Gen. Journal Batch Code", rec."Journal Batch Name");
        WHTEader.SetRange("Gen. Journal Line No.", rec."Line No.");
        if WHTEader.FindFirst() then
            WHTEader.Delete(True);
    end;


    [IntegrationEvent(true, false)]
    local procedure OnBeforInsertWhtHeader(var WHTHeader: Record "NCT WHT Header"; GenLine: Record "Gen. Journal Line")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetFIlterWhtCetificate(var GenLineFilter: Record "Gen. Journal Line"; GenLine: Record "Gen. Journal Line")
    begin
    end;


}