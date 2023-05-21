page 50008 "WHT Certificate"
{
    PageType = Document;
    SourceTable = "WHT Header";
    RefreshOnActivate = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Certificate Card';
    layout
    {

        area(Content)
        {
            group("General")
            {
                Caption = 'General';
                field("WHT No."; Rec."WHT No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = all;
                }
                field("WHT Certificate No."; Rec."WHT Certificate No.")
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        Rec."AssistEditCertificate"();
                    end;
                }
                field("WHT Date"; Rec."WHT Date")
                {
                    ApplicationArea = all;
                }
                field("WHT Source Type"; Rec."WHT Source Type")
                {
                    ApplicationArea = all;
                }
                field("WHT Source No."; Rec."WHT Source No.")
                {
                    ApplicationArea = all;
                }

                field("WHT Name"; Rec."WHT Name")
                {
                    ApplicationArea = all;
                }
                field("WHT Name 2"; Rec."WHT Name 2")
                {
                    ApplicationArea = all;
                }
                field("WHT Address"; Rec."WHT Address")
                {
                    ApplicationArea = all;
                }
                field("WHT Address 2"; Rec."WHT Address 2")
                {
                    ApplicationArea = all;
                }
                field("WHT Address 3"; Rec."WHT Address 3")
                {
                    ApplicationArea = all;
                }
                field("WHT City"; Rec."WHT City")
                {
                    ApplicationArea = all;
                }
                field("Wht Post Code"; Rec."Wht Post Code")
                {
                    ApplicationArea = all;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = all;
                }
                field("WHT Type"; Rec."WHT Type")
                {
                    ApplicationArea = all;
                }
                field("WHT Option"; Rec."WHT Option")
                {
                    ApplicationArea = all;
                }
                field("WHT Base"; Rec."WHT Base")
                {
                    ApplicationArea = all;
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = all;
                }
                field("Gen. Journal Template Code"; Rec."Gen. Journal Template Code")
                {
                    ApplicationArea = all;
                }
                field("Gen. Journal Batch Code"; Rec."Gen. Journal Batch Code")
                {
                    ApplicationArea = all;
                }
                field("Gen. Journal Document No."; Rec."Gen. Journal Document No.")
                {
                    ApplicationArea = all;
                }
                field("Gen. Journal Line No."; Rec."Gen. Journal Line No.")
                {
                    ApplicationArea = all;
                }
                field("Posted"; Rec."Posted")
                {
                    ApplicationArea = all;
                }


            }
            part("WhtSubform"; "WHT Certificate Subform")
            {
                Caption = 'Lines';
                ApplicationArea = all;
                ShowFilter = false;
                SubPageLink = "WHT No." = field("WHT No.");
                UpdatePropagation = Both;
            }
        }


    }

    actions
    {

        area(Reporting)
        {

            action("WHT Certificate4Copies")
            {
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Ellipsis = true;
                ApplicationArea = all;
                PromotedCategory = Report;
                Caption = 'WHT Certificate(4Copies)';
                trigger OnAction()
                var
                    WHTEntry: Record "WHT Header";
                begin
                    WHTEntry.Copy(Rec);
                    WHTEntry.SetFilter("WHT No.", '%1', Rec."WHT No.");
                    Report.Run(Report::"WHT Certificate", TRUE, TRUE, WHTEntry);
                end;
            }
            action("WHT Certificate(Preprint)")
            {
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Ellipsis = true;
                ApplicationArea = all;
                Caption = 'WHT Certificate(Preprint)';
                PromotedCategory = Report;
                trigger OnAction()
                var
                    WHTEntry: Record "WHT Header";
                begin
                    WHTEntry.Copy(Rec);
                    WHTEntry.SetFilter("WHT No.", '%1', Rec."WHT No.");
                    Report.Run(Report::"WHT Certificate Preprint", TRUE, TRUE, WHTEntry);
                end;
            }
        }
        area(Processing)
        {
            action("Get WHT Line from Purch. Invoice")
            {
                ApplicationArea = All;
                Caption = 'Get WHT Line from Purch. Invoice';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                Image = GetLines;
                trigger OnAction()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                    PurchInvLine: Record "Purch. Inv. Line";
                    WHTLine: Record "WHT Lines";
                    LastLineNo: Integer;
                begin
                    VendLedgEntry.reset;
                    VendLedgEntry.SetRange("Applies-to ID", GDocNo);
                    if VendLedgEntry.FindSet() then
                        repeat
                            PurchInvLine.reset;
                            PurchInvLine.SetRange("Document No.", VendLedgEntry."Document No.");
                            PurchInvLine.SetFilter("WHT Business Posting Group", '<>%1', '');
                            if PurchInvLine.findset then
                                repeat
                                    WHTLine.RESET;
                                    WHTLine.SetRange("WHT No.", Rec."WHT No.");
                                    WHTLine.SetRange("WHT Product Posting Group", '%1', PurchInvLine."WHT Product Posting Group");
                                    if WHTLine.FindFirst() then begin
                                        WHTLine.Validate("WHT Base", WHTLine."WHT Base" + PurchInvLine."Line Amount");
                                        WHTLine.Modify();
                                    end else begin
                                        WHTLine.reset;
                                        WHTLine.SetRange("WHT No.", Rec."WHT No.");
                                        if WHTLine.FindLast() then
                                            LastLineNo := WHTLine."WHT Line No." + 10000
                                        else
                                            LastLineNo := 10000;
                                        WHTLine.Reset();
                                        WHTLine.Init();
                                        WHTLine."WHT No." := Rec."WHT No.";
                                        WHTLine."WHT Line No." := LastLineNo;
                                        WHTLine.Insert();
                                        WHTLine.validate("WHT Product Posting Group", PurchInvLine."WHT Product Posting Group");
                                        WHTLine.Validate("WHT Base", PurchInvLine."Line Amount");
                                        WHTLine.modify();
                                    end;
                                until PurchInvLine.Next() = 0;
                        until VendLedgEntry.Next() = 0;
                end;
            }
        }
    }
    /// <summary> 
    /// Description for CreateWHTCertificate.
    /// </summary>
    local procedure "CreateWHTCertificate"() ReturnResult: Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        CurrLine: Integer;
        LastLine: Integer;
        WHTSetup: Record "WHT Business Posting Group";
        WHTEntry: Record "WHT Lines";
        SumAmt: Decimal;
    begin
        IF Rec."WHT Certificate No." = '' THEN BEGIN
            IF CONFIRM('WHT Certificate No. does not exist. Do you want to discard') THEN
                EXIT(TRUE);
        END ELSE BEGIN
            Rec.TESTfield("WHT Business Posting Group");
            IF NOT GenJnlLine.GET(Rec."Gen. Journal Template Code", Rec."Gen. Journal Batch Code", Rec."Gen. Journal Line No.") THEN BEGIN
                GenJnlLine.RESET;
                GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line NO.");
                GenJnlLine.SETRANGE("Journal Template Name", Rec."Gen. Journal Template Code");
                GenJnlLine.SETRANGE("Journal Batch Name", Rec."Gen. Journal Batch Code");
                GenJnlLine.SETFILTER("Document No.", '%1', Rec."Gen. Journal Document No.");
                IF GenJnlLine.FindLast() THEN BEGIN
                    CurrLine := GenJnlLine."Line No.";
                END;

                GenJnlLine2.RESET;
                GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line NO.");
                GenJnlLine2.SETRANGE("Journal Template Name", Rec."Gen. Journal Template Code");
                GenJnlLine2.SETRANGE("Journal Batch Name", Rec."Gen. Journal Batch Code");
                GenJnlLine2.SETFILTER("Document No.", '%1', Rec."Gen. Journal Document No.");
                IF GenJnlLine2.FindLast() THEN;

                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", Rec."Gen. Journal Template Code");
                GenJnlLine.SETRANGE("Journal Batch Name", Rec."Gen. Journal Batch Code");
                GenJnlLine.SETFILTER("Line No.", '>%1', CurrLine);
                IF GenJnlLine.FindFirst() THEN
                    LastLine := GenJnlLine."Line No.";
                IF LastLine = 0 THEN
                    CurrLine += 10000
                ELSE
                    CurrLine := ROUND((CurrLine + LastLine) / 2, 1);

                WHTSetup.GET(Rec."WHT Business Posting Group");
                WHTSetup.TESTfield("G/L Account No.");

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := Rec."Gen. Journal Template Code";
                GenJnlLine."Journal Batch Name" := Rec."Gen. Journal Batch Code";
                GenJnlLine."Line No." := CurrLine;
                GenJnlLine.INSERT;
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", WHTSetup."G/L Account No.");
                GenJnlLine."Posting Date" := GenJnlLine2."Posting Date";
                GenJnlLine."Document Date" := Rec."WHT Date";
                GenJnlLine."Document Type" := GenJnlLine2."Document Type";
                GenJnlLine."Document No." := GenJnlLine2."Document No.";
                GenJnlLine."External Document No." := Rec."WHT Certificate No.";
                GenJnlLine."WHT Document No." := Rec."WHT No.";
                GenJnlLine."Require Screen Detail" := GenJnlLine."Require Screen Detail"::WHT;
                SumAmt := 0;
                WHTEntry.RESET;
                WHTEntry.SETRANGE("WHT No.", Rec."WHT No.");
                IF WHTEntry.FIND('-') THEN begin

                    WHTEntry.CalcSums("WHT Amount");
                    SumAmt := WHTEntry."WHT Amount";
                end;
                GenJnlLine.Amount := -SumAmt;
                GenJnlLine."Amount (LCY)" := -SumAmt;
                GenJnlLine."Balance (LCY)" := -SumAmt; // 2016-12-06
                GenJnlLine."Credit Amount" := SumAmt;
                GenJnlLine.MODIFY;
                Rec."Gen. Journal Line No." := CurrLine;
                Rec."Gen. Journal Document No." := GenJnlLine."Document No.";
                Rec.MODIFY;
            END ELSE BEGIN
                SumAmt := 0;
                WHTEntry.RESET;
                WHTEntry.SETRANGE("WHT No.", Rec."WHT No.");
                IF WHTEntry.FIND('-') THEN begin

                    WHTEntry.CalcSums("WHT Amount");
                    SumAmt := WHTEntry."WHT Amount";

                end;
                GenJnlLine.Amount := -SumAmt;
                GenJnlLine."Amount (LCY)" := -SumAmt;
                GenJnlLine."Balance (LCY)" := -SumAmt; //
                GenJnlLine."Credit Amount" := SumAmt;

                GenJnlLine.MODIFY;
                IF Rec."Gen. Journal Line No." = 0 THEN BEGIN
                    Rec."Gen. Journal Line No." := GenJnlLine."Line No.";
                END;
                Rec."Gen. Journal Document No." := GenJnlLine."Document No.";
                Rec.MODIFY;
            END;
        END;

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        "CreateWHTCertificate"();
    end;

    /// <summary> 
    /// Description for SetGenJnlLine.
    /// </summary>
    /// <param name="LJnlTemplate">Parameter of type code[20].</param>
    /// <param name="LJnlBatch">Parameter of type Code[20].</param>
    /// <param name="LDocNo">Parameter of type Code[20].</param>
    procedure "SetGenJnlLine"(LJnlTemplate: code[20]; LJnlBatch: Code[20]; LDocNo: Code[20]; plineNo: Integer)
    begin
        GJnlTemplate := LJnlTemplate;
        GJnlBatch := LJnlBatch;
        GDocNo := LDocNo;
        MyLineNo := plineNo;
    end;

    var
        GJnlTemplate: Code[20];
        GJnlBatch: Code[20];
        GDocNo: Code[20];
        MyLineNo: Integer;
        GenJnlLineDelte: Record "Gen. Journal Line";

}
