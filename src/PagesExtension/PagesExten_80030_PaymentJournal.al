pageextension 80030 "Payment Journal" extends "Payment Journal"
{
    PromotedActionCategories = 'New,Process,Print,Bank,Prepare,Approve,Page,Post/Print,Line,Account,Check';
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
        addafter(Description)
        {

            field("Pay Name"; Rec."Pay Name")
            {
                ApplicationArea = all;
                Caption = 'Pay Name';
            }
            field("Journal Description"; Rec."Journal Description")
            {
                ApplicationArea = all;
                Caption = 'Journal Description';
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
    }


    actions
    {
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
                trigger OnAction()
                begin
                    // TestField("Require Screen Detail", "Require Screen Detail"::WHT);
                    "InsertWHTCertificate"();
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
                trigger OnAction()
                var
                    ShowDetailCheque: Page "ShowDetail Cheque";
                    ShowDetailVAT: Page "ShowDetail Vat";
                    GenLineDetail: Record "Gen. Journal Line";

                begin
                    Rec.TestField("Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    if Rec."Require Screen Detail" IN [Rec."Require Screen Detail"::VAT, Rec."Require Screen Detail"::CHEQUE] then begin
                        GenLineDetail.reset;
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        if Rec."Require Screen Detail" = Rec."Require Screen Detail"::CHEQUE then begin
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
                trigger OnAction()
                var
                    PaymentVourcher: Report "Payment Voucher";
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset;
                    GenJournalLIne.Copy(Rec);
                    PaymentVourcher."SetGLEntry"(GenJournalLIne);
                    PaymentVourcher.RunModal();
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
                trigger OnAction()
                var
                    GenLines: Record "Gen. Journal Line";
                begin
                    rec.TestField("Require Screen Detail", rec."Require Screen Detail"::CHEQUE);
                    GenLines.reset;
                    GenLines.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenLines.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenLines.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"Payment Cheque", true, true, GenLines);
                end;
            }
        }
        //ct >>>
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

            action("Get WHT Invoice")
            {
                ApplicationArea = All;
                Caption = 'Get WHT Invoice';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Add;
                Visible = false;
                trigger OnAction()
                var
                    vlVendorLedgerEntryRec: Record "Vendor Ledger Entry";
                    vlPurchInvLineRec: Record "Purch. Inv. Line";
                    vlGenJnLineRec: Record "Gen. Journal Line";
                    CodeUnitFunction: Codeunit "Function Center";
                    vlLineNo: Integer;
                    vlVendorRec: Record Vendor;
                    vlWHTBusinessRec: Record "WHT Business Posting Group";
                    GeneralSetup: Record "General Ledger Setup";
                    WHTHeader: Record "WHT Header";
                    NosMgt: Codeunit NoSeriesManagement;
                    WHTDocNo: Code[20];
                    GenJnlLine: Record "Gen. Journal Line";
                    Vendor: Record Vendor;
                    Customer: Record Customer;
                    whtBusPostingGroup: Record "WHT Business Posting Group";
                begin
                    GeneralSetup.GET;
                    GeneralSetup.TESTFIELD("WHT Document Nos.");

                    vlVendorLedgerEntryRec.RESET;
                    vlVendorLedgerEntryRec.SETFILTER("Applies-to ID", '%1', Rec."Document No.");
                    IF vlVendorLedgerEntryRec.FIND('-') THEN BEGIN
                        vlLineNo := CodeUnitFunction."GetLastLineNoFromGenJnlLine"(Rec."Journal Template Name", Rec."Journal Batch Name");
                        REPEAT
                            vlPurchInvLineRec.RESET;
                            vlPurchInvLineRec.SETFILTER("Document No.", '%1', vlVendorLedgerEntryRec."Document No.");
                            vlPurchInvLineRec.SETFILTER("WHT Product Posting Group", '<>%1', '');
                            IF vlPurchInvLineRec.FIND('-') THEN BEGIN
                                REPEAT
                                    vlLineNo += 10000;
                                    vlGenJnLineRec.INIT;
                                    vlGenJnLineRec."Journal Template Name" := Rec."Journal Template Name";
                                    vlGenJnLineRec."Journal Batch Name" := Rec."Journal Batch Name";
                                    vlGenJnLineRec."Posting Date" := Rec."Posting Date";
                                    vlGenJnLineRec."Line No." := vlLineNo;
                                    vlGenJnLineRec."Document No." := Rec."Document No.";
                                    vlGenJnLineRec."Account Type" := vlGenJnLineRec."Account Type"::"G/L Account";

                                    IF vlVendorRec.GET(Rec."Account No.") THEN
                                        IF vlWHTBusinessRec.GET(vlVendorRec."WHT Business Posting Group") THEN
                                            vlWHTBusinessRec.TESTFIELD("G/L Account No.");

                                    vlGenJnLineRec.VALIDATE("Account No.", vlWHTBusinessRec."G/L Account No.");
                                    vlGenJnLineRec.INSERT;
                                    vlGenJnLineRec."WHT Date" := Rec."Posting Date";
                                    vlGenJnLineRec.VALIDATE("WHT Vendor No.", Rec."Account No.");
                                    vlGenJnLineRec.Validate("WHT Business Posting Group", vlPurchInvLineRec."WHT Business Posting Group");
                                    vlGenJnLineRec.VALIDATE("WHT Base", vlPurchInvLineRec."Line Amount");
                                    vlGenJnLineRec."WHT Option" := vlGenJnLineRec."WHT Option"::"(1) หักภาษี ณ ที่จ่าย";
                                    vlGenJnLineRec."Require Screen Detail" := vlGenJnLineRec."Require Screen Detail"::WHT;

                                    WHTHeader.INIT;
                                    WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."WHT Document Nos.", Rec."Posting Date", TRUE);
                                    WHTDocNo := WHTHeader."WHT No.";
                                    GenJnlLine.RESET;
                                    GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                                    GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                                    GenJnlLine.SETFILTER("Document No.", '%1', Rec."Document No.");
                                    GenJnlLine.SETFILTER("Account Type", '%1|%2', GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Customer);
                                    GenJnlLine.SETFILTER("Account No.", '<>%1', '');
                                    IF GenJnlLine.FindFirst() THEN BEGIN
                                        WHTHeader."Gen. Journal Template Code" := Rec."Journal Template Name";
                                        WHTHeader."Gen. Journal Batch Code" := Rec."Journal Batch Name";
                                        WHTHeader."Gen. Journal Document No." := Rec."Document No.";
                                        WHTHeader."WHT Date" := Rec."Document Date";
                                        //     WHTHeader."Gen. Journal Line No." := "Line No.";
                                        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                                            IF Vendor.GET(GenJnlLine."Account No.") THEN BEGIN
                                                if NOT whtBusPostingGroup.GET(Vendor."WHT Business Posting Group") then
                                                    whtBusPostingGroup.init;
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
                                    WHTHeader.Insert();
                                    vlGenJnLineRec."WHT Document No." := WHTHeader."WHT No.";
                                    vlGenJnLineRec.Modify();
                                UNTIL vlPurchInvLineRec.NEXT = 0;
                            END;
                        UNTIL vlVendorLedgerEntryRec.NEXT = 0;
                    END;
                END;
            }

        }
         //ct <<<

    }
    /// <summary> 
    /// Description for InsertWHTCertificate.
    /// </summary>
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
        if Rec."WHT Document No." = '' then begin
            GenJnlLine3.Reset();
            GenJnlLine3.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", Rec."Document No.");
            GenJnlLine3.SetFilter("WHT Document No.", '<>%1', '');
            if GenJnlLine3.FindFirst() then begin
                if not Confirm('This document already have wht certificate do you want to create more wht certificate ?') then
                    exit;
            end;
        end;
        GeneralSetup.GET;
        GeneralSetup.TESTFIELD("WHT Document Nos.");
        IF Rec."WHT Document No." = '' THEN BEGIN
            IF NOT CONFIRM('Do you want to create wht certificated') THEN
                EXIT;
            WHTHeader.INIT;
            WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."WHT Document Nos.", Rec."Posting Date", TRUE);
            WHTDocNo := WHTHeader."WHT No.";
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
            GenJnlLine.SETFILTER("Document No.", '%1', Rec."Document No.");
            GenJnlLine.SetRange("Require Screen Detail", GenJnlLine."Require Screen Detail"::WHT);
            GenJnlLine.SETFILTER("Account Type", '%1|%2|%3', GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.SETFILTER("Account No.", '<>%1', '');
            IF GenJnlLine.FindFirst() THEN BEGIN
                WHTHeader."Gen. Journal Template Code" := Rec."Journal Template Name";
                WHTHeader."Gen. Journal Batch Code" := Rec."Journal Batch Name";
                WHTHeader."Gen. Journal Document No." := Rec."Document No.";
                WHTHeader."WHT Date" := Rec."Document Date";
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
            Rec.Modify();
        END ELSE begin
            WHTDocNo := Rec."WHT Document No.";
        end;

        commit;
        CLEAR(PageWHTCer);
        WHTHeader.reset;
        WHTHeader.SetFilter("WHT No.", '%1', WHTDocNo);
        PageWHTCer.SetTableView(WHTHeader);
        PageWHTCer."SetGenJnlLine"(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Document No.", rec."Line No.");
        if PageWHTCer.RunModal() IN [Action::OK] then
            CurrPage.Update();
        CLEAR(PageWHTCer);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        WHTEader: Record "WHT Header";
    begin
        WHTEader.reset;
        WHTEader.SetRange("Gen. Journal Template Code", Rec."Journal Template Name");
        WHTEader.SetRange("Gen. Journal Batch Code", Rec."Journal Batch Name");
        WHTEader.SetRange("Gen. Journal Line No.", Rec."Line No.");
        if WHTEader.Find() then
            WHTEader.Delete(True);
    end;

}