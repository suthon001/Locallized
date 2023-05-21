pageextension 80029 "General Journal" extends "General Journal"
{
    PromotedActionCategories = 'New,Process,Print,Bank,Application,Payroll,Approve,Page,Post/Print,Line,Account';
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
        addafter("VAT Amount")
        {
            field("Require Screen Detail"; Rec."Require Screen Detail")
            {
                ApplicationArea = all;
                Caption = 'Require Screen Detail';
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
            field("Journal Description"; Rec."Journal Description")
            {
                ApplicationArea = All;
                Caption = 'Journal Description';
            }
        }
    }
    actions
    {
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
                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    SummaryAmount: Decimal;
                begin
                    GenJnlLine.reset;
                    GenJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", rec."Document No.");
                    GenJnlLine.SetFilter("Line No.", '<>%1', rec."Line No.");
                    if GenJnlLine.findset then begin
                        GenJnlLine.CalcSums("Amount (LCY)");
                        SummaryAmount := GenJnlLine."Amount (LCY)";
                    end;
                    if SummaryAmount <> 0 then begin
                        rec.Validate("Amount (LCY)", SummaryAmount * -1);
                    end else
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
                    if Rec."Require Screen Detail" IN [Rec."Require Screen Detail"::VAT, Rec."Require Screen Detail"::WHT] then begin
                        GenLineDetail.reset;
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        if Rec."Require Screen Detail" = Rec."Require Screen Detail"::CHEQUE then begin
                            ShowDetailCheque.SetTableView(GenLineDetail);
                            ShowDetailCheque.RunModal();
                            CLEAR(ShowDetailCheque);
                        end else
                            if Rec."Require Screen Detail" = Rec."Require Screen Detail"::VAT then begin
                                ShowDetailVAT.SetTableView(GenLineDetail);
                                ShowDetailVAT.RunModal();
                                CLEAR(ShowDetailVAT);
                            end else
                                if Rec."Require Screen Detail" = Rec."Require Screen Detail"::WHT then begin
                                    if Rec."WHT Cust/Vend No." = '' then begin
                                        GenLine2.reset;
                                        GenLine2.SetRange("Journal Template Name", Rec."Journal Template Name");
                                        GenLine2.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                                        GenLine2.SetRange("Document No.", Rec."Document No.");
                                        GenLine2.SetRange("Account Type", GenLine2."Account Type"::Customer);
                                        if GenLine2.FindFirst() then begin
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
                                    end;
                                    ShowDetailWHT.SetTableView(GenLineDetail);
                                    ShowDetailWHT.RunModal();
                                    Clear(ShowDetailWHT);
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
                trigger OnAction()
                var
                    JournalVourcher: Report "Journal Voucher";
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset;
                    GenJournalLIne.Copy(Rec);
                    JournalVourcher."SetGLEntry"(GenJournalLIne);
                    JournalVourcher.RunModal();
                end;
            }
        }

    }
    procedure "InsertWHTCertificate"()
    var
        GeneralSetup: Record "General Ledger Setup";
        WHTHeader: Record "WHT Header";
        NosMgt: Codeunit NoSeriesManagement;
        GenJnlLine: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        Customer: Record Customer;
        WHTDocNo: Code[20];
        CurrLine: Integer;
        LastLine: Integer;
        GenJnlLine2: Record "Gen. Journal Line";
        WHTBusiness: Record "Dimension Value";
        PageWHTCer: Page "WHT Certificate";
        whtBusPostingGroup: Record "WHT Business Posting Group";
        GenJnlLine3: Record "Gen. Journal Line";
    begin
        if rec."WHT Document No." = '' then begin
            GenJnlLine3.Reset();
            GenJnlLine3.SetRange("Journal Template Name", rec."Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", rec."Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", rec."Document No.");
            GenJnlLine3.SetFilter("WHT Document No.", '<>%1', '');
            if GenJnlLine3.FindFirst() then begin
                if not Confirm('This document already have wht certificate do you want to create more wht certificate ?') then
                    exit;
            end;
        end;
        GeneralSetup.GET;
        GeneralSetup.TESTFIELD("WHT Document Nos.");
        IF rec."WHT Document No." = '' THEN BEGIN
            IF NOT CONFIRM('Do you want to create wht certificated') THEN
                EXIT;
            WHTHeader.INIT;
            WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."WHT Document Nos.", rec."Posting Date", TRUE);
            WHTDocNo := WHTHeader."WHT No.";
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", rec."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", rec."Journal Batch Name");
            GenJnlLine.SETFILTER("Document No.", '%1', rec."Document No.");
            GenJnlLine.SETFILTER("Account Type", '%1|%2', GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Customer);
            GenJnlLine.SETFILTER("Account No.", '<>%1', '');
            IF GenJnlLine.FindFirst() THEN BEGIN
                WHTHeader."Gen. Journal Template Code" := rec."Journal Template Name";
                WHTHeader."Gen. Journal Batch Code" := rec."Journal Batch Name";
                WHTHeader."Gen. Journal Document No." := rec."Document No.";
                WHTHeader."WHT Date" := rec."Document Date";
                //     WHTHeader."Gen. Journal Line No." := "Line No.";
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET(GenJnlLine."Account No.") THEN BEGIN
                        if NOT whtBusPostingGroup.GET(Vendor."WHT Business Posting Group") then
                            whtBusPostingGroup.init;
                        WHTHeader."WHT Business Posting Group" := Vendor."WHT Business Posting Group";
                        WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Vendor;
                        WHTHeader."WHT Source No." := Vendor."No.";
                        WHTHeader."WHT Name" := Vendor.Name;
                        WHTHeader."WHT Name 2" := Vendor."Name 2";
                        WHTHeader."WHT Address" := Vendor.Address;
                        WHTHeader."WHT Address 2" := Vendor."Address 2";
                        WHTHeader."VAT Registration No." := Vendor."VAT Registration No.";
                        WHTHeader."Head Office" := Vendor."Head Office";
                        WHTHeader."VAT Branch Code" := Vendor."Branch Code";
                        WHTHeader."WHT Business Posting Group" := Vendor."WHT Business Posting Group";
                        WHTHeader."WHT Type" := whtBusPostingGroup."WHT Type";
                        WHTHeader."WHT City" := Vendor.City;
                        WHTHeader."WHT Post Code" := Vendor."Post Code";
                    END;
                END ELSE
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
                        IF Customer.GET(GenJnlLine."Account No.") THEN BEGIN
                            if NOT whtBusPostingGroup.GET(Customer."WHT Business Posting Group") then
                                whtBusPostingGroup.init;
                            WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Customer;
                            WHTHeader."WHT Source No." := Customer."No.";
                            WHTHeader."WHT Name" := Customer.Name;
                            WHTHeader."WHT Name 2" := Customer."Name 2";
                            WHTHeader."WHT Address" := Customer.Address;
                            WHTHeader."WHT Address 2" := Customer."Address 2";
                            WHTHeader."VAT Registration No." := Customer."VAT Registration No.";
                            WHTHeader."Head Office" := Customer."Head Office";
                            WHTHeader."VAT Branch Code" := Customer."Branch Code";
                            WHTHeader."WHT Business Posting Group" := Customer."WHT Business Posting Group";
                            WHTHeader."WHT Type" := whtBusPostingGroup."WHT Type";
                            WHTHeader."WHT City" := Customer.City;
                            WHTHeader."WHT Post Code" := Customer."Post Code";
                        END;
                    END;
            END;
            WHTHeader.INSERT;
            rec.Modify();
        END ELSE begin
            WHTDocNo := rec."WHT Document No.";
        end;

        commit;
        CLEAR(PageWHTCer);
        WHTHeader.reset;
        WHTHeader.SetFilter("WHT No.", '%1', WHTDocNo);
        PageWHTCer.SetTableView(WHTHeader);
        PageWHTCer."SetGenJnlLine"(rec."Journal Template Name", rec."Journal Batch Name", rec."Document No.", rec."Line No.");
        if PageWHTCer.RunModal() IN [Action::OK] then
            CurrPage.Update();
        CLEAR(PageWHTCer);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        WHTEader: Record "WHT Header";
    begin
        WHTEader.reset;
        WHTEader.SetRange("Gen. Journal Template Code", rec."Journal Template Name");
        WHTEader.SetRange("Gen. Journal Batch Code", rec."Journal Batch Name");
        WHTEader.SetRange("Gen. Journal Line No.", rec."Line No.");
        if WHTEader.Find() then
            WHTEader.Delete(True);
    end;

}