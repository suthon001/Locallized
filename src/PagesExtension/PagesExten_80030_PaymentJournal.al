/// <summary>
/// PageExtension NCT Payment Journal (ID 80030) extends Record Payment Journal.
/// </summary>
pageextension 80030 "NCT Payment Journal" extends "Payment Journal"
{
    PromotedActionCategories = 'New,Process,Print,Bank,Prepare,Approve,Page,Post/Print,Line,Account,Check';
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
        addafter(Description)
        {

            field("Pay Name"; Rec."NCT Pay Name")
            {
                ApplicationArea = all;
                Caption = 'Pay Name';
                ToolTip = 'Specifies the value of the Pay Name field.';
            }
            field("Journal Description"; Rec."NCT Journal Description")
            {
                ApplicationArea = all;
                Caption = 'Journal Description';
                ToolTip = 'Specifies the value of the Journal Description field.';
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
                PromotedCategory = Category8;
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
        addfirst("P&osting")
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
                    //rec.TestField("NCT Require Screen Detail", rec."NCT Require Screen Detail"::WHT);
                    InsertWHTCertificate();
                end;
            }
            action("Show Detail")
            {
                Caption = 'Show Detail Vat & Cheque';
                Image = LineDescription;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Show Detail Vat & Cheque action.';
                trigger OnAction()
                var
                    ShowDetailCheque: Page "NCT ShowDetail Cheque";
                    ShowDetailVAT: Page "NCT ShowDetail Vat";
                    GenLineDetail: Record "Gen. Journal Line";

                begin
                    Rec.TestField("NCT Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    if Rec."NCT Require Screen Detail" IN [Rec."NCT Require Screen Detail"::VAT, Rec."NCT Require Screen Detail"::CHEQUE] then begin
                        GenLineDetail.reset();
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        if Rec."NCT Require Screen Detail" = Rec."NCT Require Screen Detail"::CHEQUE then begin
                            ShowDetailCheque.SetTableView(GenLineDetail);
                            ShowDetailCheque.RunModal();
                            CLEAR(ShowDetailCheque);
                        end else begin
                            ShowDetailVAT.SetTableView(GenLineDetail);
                            ShowDetailVAT.RunModal();
                            CLEAR(ShowDetailVAT);
                        end;
                    end else
                        MESSAGE('Nothing to Show Detail');
                end;
            }
        }
        addlast(Reporting)
        {
            action("Payment Voucher")
            {
                Caption = 'Payment Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Payment Voucher action.';
                trigger OnAction()
                var
                    GenJournalLIne: Record "Gen. Journal Line";
                    PaymentVoucher: Report "NCT Payment Voucher";
                begin
                    CLEAR(PaymentVoucher);
                    GenJournalLIne.reset();
                    GenJournalLIne.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLIne.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLIne.SetRange("Document No.", rec."Document No.");
                    if GenJournalLIne.FindFirst() then
                        PaymentVoucher.SetDataTable(GenJournalLIne);
                    PaymentVoucher.RunModal();
                    CLEAR(PaymentVoucher);
                end;
            }
            action("Cheque")
            {
                Caption = 'Cheque';
                Image = PrintCheck;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cheque action.';
                trigger OnAction()
                var
                    GenLines: Record "Gen. Journal Line";
                begin
                    rec.TestField("NCT Require Screen Detail", rec."NCT Require Screen Detail"::CHEQUE);
                    GenLines.reset();
                    GenLines.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenLines.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenLines.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"NCT Payment Cheque", true, true, GenLines);
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
                Visible = false;
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
        modify(PrintCheck)
        {
            Visible = false;
        }
        modify("Void Check")
        {
            Visible = false;
        }
        modify("Void &All Checks")
        {
            Visible = false;
        }
        modify(PreCheck)
        {
            Visible = false;
        }

    }
    /// <summary> 
    /// Description for InsertWHTCertificate.
    /// </summary>
    procedure InsertWHTCertificate()
    var
        GeneralSetup: Record "General Ledger Setup";
        WHTHeader: Record "NCT WHT Header";
        NosMgt: Codeunit "No. Series";
        GenJnlLine: Record "Gen. Journal Line";
        GEnTemplate: Record "Gen. Journal Template";
        Vendor: Record Vendor;
        Customer: Record Customer;
        WHTDocNo: Code[30];
        PageWHTCer: Page "NCT WHT Certificate";
        whtBusPostingGroup: Record "NCT WHT Business Posting Group";
        GenJnlLine3: Record "Gen. Journal Line";
    begin
        if Rec."NCT WHT Document No." = '' then begin
            GenJnlLine3.Reset();
            GenJnlLine3.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", Rec."Document No.");
            GenJnlLine3.SetFilter("NCT WHT Document No.", '<>%1', '');
            if not GenJnlLine3.IsEmpty() then
                if not Confirm('This document already have wht certificate do you want to create more wht certificate ?') then
                    exit;
        end;
        GeneralSetup.GET();
        GeneralSetup.TESTFIELD("NCT WHT Document Nos.");
        IF Rec."NCT WHT Document No." = '' THEN BEGIN
            IF NOT CONFIRM('Do you want to create wht certificated') THEN
                EXIT;
            GEnTemplate.GET(rec."Journal Template Name");
            GenJnlLine.RESET();
            GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
            GenJnlLine.SETRANGE("Document No.", Rec."Document No.");
            if GEnTemplate.Type = GEnTemplate.Type::Payments then
                GenJnlLine.SETFILTER("Account Type", '%1|%2', GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::"G/L Account");
            if GEnTemplate.Type = GEnTemplate.Type::"Cash Receipts" then
                GenJnlLine.SETFILTER("Account Type", '%1|%2', GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::"G/L Account");
            if GEnTemplate.Type = GEnTemplate.Type::General then
                GenJnlLine.SETFILTER("Account Type", '%1|%2|%3', GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.SETFILTER("Account No.", '<>%1', '');
            OnSetFIlterWhtCetificate(GenJnlLine, rec);
            IF GenJnlLine.FindFirst() THEN BEGIN
                WHTHeader.INIT();
                WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."NCT WHT Document Nos.", Rec."Posting Date", TRUE);
                WHTDocNo := WHTHeader."WHT No.";
                WHTHeader."Gen. Journal Template Code" := Rec."Journal Template Name";
                WHTHeader."Gen. Journal Batch Code" := Rec."Journal Batch Name";
                WHTHeader."Gen. Journal Document No." := Rec."Document No.";
                WHTHeader."WHT Date" := Rec."Document Date";
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET(GenJnlLine."Account No.") THEN BEGIN
                        if NOT whtBusPostingGroup.GET(Vendor."NCT WHT Business Posting Group") then
                            whtBusPostingGroup.init();
                        WHTHeader."WHT Business Posting Group" := Vendor."NCT WHT Business Posting Group";
                        WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Vendor;
                        WHTHeader.validate("WHT Source No.", Vendor."No.");
                    END;
                END ELSE
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
                        IF Customer.GET(GenJnlLine."Account No.") THEN BEGIN
                            if NOT whtBusPostingGroup.GET(Customer."NCT WHT Business Posting Group") then
                                whtBusPostingGroup.init();
                            WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Customer;
                            WHTHeader."WHT Source No." := Customer."No.";
                            WHTHeader.validate("WHT Source No.", Customer."No.");
                        END;
            END;
            WHTHeader."WHT Option" := WHTHeader."WHT Option"::"(1) หักภาษี ณ ที่จ่าย";
            OnbeforInsertWhtHeader(WHTHeader, rec);
            WHTHeader.INSERT();
            Rec.Modify();
        END ELSE
            WHTDocNo := Rec."NCT WHT Document No.";
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
        PurchaseBilling: Record "NCT Billing Receipt Header";
        WHTEader: Record "NCT WHT Header";
    begin
        if rec."NCT Ref. Billing & Receipt No." <> '' then
            if PurchaseBilling.GET(PurchaseBilling."Document Type"::"Purchase Billing", rec."NCT Ref. Billing & Receipt No.") then begin
                PurchaseBilling."Status" := PurchaseBilling."Status"::Released;
                PurchaseBilling."Create to Journal" := false;
                PurchaseBilling.Modify();
            end;

        WHTEader.reset();
        WHTEader.SetRange("Gen. Journal Template Code", Rec."Journal Template Name");
        WHTEader.SetRange("Gen. Journal Batch Code", Rec."Journal Batch Name");
        WHTEader.SetRange("Gen. Journal Line No.", Rec."Line No.");
        WHTEader.SetRange(Posted, false);
        if WHTEader.FindFirst() then
            WHTEader.Delete(True);
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

    [IntegrationEvent(true, false)]
    local procedure OnbeforInsertWhtHeader(var WHTHeader: Record "NCT WHT Header"; GenLine: Record "Gen. Journal Line")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetFIlterWhtCetificate(var GenLineFilter: Record "Gen. Journal Line"; GenLine: Record "Gen. Journal Line")
    begin
    end;

    var
        gvDocument: Code[20];
}