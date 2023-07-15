/// <summary>
/// Page NCT WHT Certificate (ID 80008).
/// </summary>
page 80008 "NCT WHT Certificate"
{
    PageType = Document;
    SourceTable = "NCT WHT Header";
    RefreshOnActivate = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Certificate Card';
    UsageCategory = None;
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
                    ToolTip = 'Specifies the value of the WHT No. field.';
                }
                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                }
                field("WHT Certificate No."; Rec."WHT Certificate No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate No field.';
                    trigger OnAssistEdit()
                    begin
                        Rec."AssistEditCertificate"();
                    end;
                }
                field("WHT Date"; Rec."WHT Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Date field.';
                }
                field("WHT Source Type"; Rec."WHT Source Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Source Type field.';
                }
                field("WHT Source No."; Rec."WHT Source No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Source No. field.';
                }

                field("WHT Name"; Rec."WHT Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Name field.';
                }
                field("WHT Name 2"; Rec."WHT Name 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Name 2 field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("WHT Type"; Rec."WHT Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Type field.';
                }
                field("WHT Option"; Rec."WHT Option")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Option field.';
                }
                field("WHT Base"; Rec."WHT Base")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Base field.';
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }
                field("Gen. Journal Template Code"; Rec."Gen. Journal Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Journal Template Code field.';
                }
                field("Gen. Journal Batch Code"; Rec."Gen. Journal Batch Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Journal Batch Code field.';
                }
                field("Gen. Journal Document No."; Rec."Gen. Journal Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Journal Document No. field.';
                }
                field("Gen. Journal Line No."; Rec."Gen. Journal Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Journal Line No. field.';
                }
                field("Posted"; Rec."Posted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted field.';
                }


            }
            part("WhtSubform"; "NCT WHT Certificate Subform")
            {
                Caption = 'Lines';
                ApplicationArea = all;
                ShowFilter = false;
                SubPageLink = "WHT No." = field("WHT No.");
                UpdatePropagation = Both;
            }
            group(AddressInfor)
            {
                Caption = 'Address Information';
                field("NCT WHT Title Name"; rec."WHT Title Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the คำนำหน้า field.';
                }
                field("NCT WHT Name"; rec."WHT Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชื่อ field.';
                }
                field("NCT WHT Building"; rec."WHT Building")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชื่ออาคาร/หมู่บ้าน field.';
                }
                field("NCT WHT House No."; rec."WHT House No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the เลขที่ห้อง field.';
                }
                field("NCT WHT Village No."; rec."WHT Village No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the หมู่ที่ field.';
                }
                field("NCT WHT Floor"; rec."WHT Floor")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชั้น field.';
                }
                field("NCT WHT No."; rec."WHT No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the เลขที่ field.';
                }
                field("NCT WHT Street"; rec."WHT Street")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ถนน field.';
                }
                field("NCT WHT Alley/Lane"; rec."WHT Alley/Lane")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ตรอก/ซอย field.';
                }
                field("NCT WHT Sub-district"; rec."WHT Sub-district")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ตำบล/แขวง field.';
                }
                field("NCT WHT District"; rec."WHT District")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the อำเภอ/เขต field.';
                }
                field("NCT WHT Province"; rec."WHT Province")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the จังหวัด field.';
                }
                field("NCT WHT Post Code"; rec."WHT Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the รหัสไปรษณีย์ field.';
                }
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
                ToolTip = 'Executes the WHT Certificate(4Copies) action.';
                trigger OnAction()
                var
                    WHTEntry: Record "NCT WHT Header";
                begin
                    WHTEntry.Copy(Rec);
                    WHTEntry.SetFilter("WHT No.", '%1', Rec."WHT No.");
                    Report.Run(Report::"NCT WHT Certificate", TRUE, TRUE, WHTEntry);
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
                ToolTip = 'Executes the WHT Certificate(Preprint) action.';
                trigger OnAction()
                var
                    WHTEntry: Record "NCT WHT Header";
                begin
                    WHTEntry.Copy(Rec);
                    WHTEntry.SetFilter("WHT No.", '%1', Rec."WHT No.");
                    Report.Run(Report::"NCT WHT Certificate Preprint", TRUE, TRUE, WHTEntry);
                end;
            }
        }
    }
    /// <summary> 
    /// Description for CreateWHTCertificate.
    /// </summary>
    local procedure CreateWHTCertificate(): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        CurrLine: Integer;
        LastLine: Integer;
        WHTSetup: Record "NCT WHT Business Posting Group";
        WHTEntry: Record "NCT WHT Line";
        SumAmt: Decimal;
    begin
        IF Rec."WHT Certificate No." = '' THEN BEGIN
            IF CONFIRM('WHT Certificate No. does not exist. Do you want to discard') THEN
                EXIT(TRUE);
        END ELSE BEGIN
            Rec.TESTfield("WHT Business Posting Group");
            IF NOT GenJnlLine.GET(Rec."Gen. Journal Template Code", Rec."Gen. Journal Batch Code", Rec."Gen. Journal Line No.") THEN BEGIN
                GenJnlLine.RESET();
                GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line NO.");
                GenJnlLine.SETRANGE("Journal Template Name", Rec."Gen. Journal Template Code");
                GenJnlLine.SETRANGE("Journal Batch Name", Rec."Gen. Journal Batch Code");
                GenJnlLine.SETRANGE("Document No.", Rec."Gen. Journal Document No.");
                IF GenJnlLine.FindLast() THEN
                    CurrLine := GenJnlLine."Line No.";

                GenJnlLine2.RESET();
                GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line NO.");
                GenJnlLine2.SETRANGE("Journal Template Name", Rec."Gen. Journal Template Code");
                GenJnlLine2.SETRANGE("Journal Batch Name", Rec."Gen. Journal Batch Code");
                GenJnlLine2.SETRANGE("Document No.", Rec."Gen. Journal Document No.");
                IF GenJnlLine2.FindLast() THEN;

                GenJnlLine.RESET();
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
                WHTSetup.TESTfield("WHT Account No.");

                GenJnlLine.INIT();
                GenJnlLine."Journal Template Name" := Rec."Gen. Journal Template Code";
                GenJnlLine."Journal Batch Name" := Rec."Gen. Journal Batch Code";
                GenJnlLine."Line No." := CurrLine;
                GenJnlLine.INSERT();
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", WHTSetup."WHT Account No.");
                GenJnlLine."Posting Date" := GenJnlLine2."Posting Date";
                GenJnlLine."Document Date" := Rec."WHT Date";
                GenJnlLine."Document Type" := GenJnlLine2."Document Type";
                GenJnlLine."Document No." := GenJnlLine2."Document No.";
                GenJnlLine."External Document No." := Rec."WHT Certificate No.";
                GenJnlLine."NCT WHT Document No." := Rec."WHT No.";
                GenJnlLine."NCT Require Screen Detail" := GenJnlLine."NCT Require Screen Detail"::WHT;
                SumAmt := 0;
                WHTEntry.RESET();
                WHTEntry.SETRANGE("WHT No.", Rec."WHT No.");
                IF WHTEntry.FindFirst() THEN begin

                    WHTEntry.CalcSums("WHT Amount");
                    SumAmt := WHTEntry."WHT Amount";
                end;
                GenJnlLine.validate(Amount, -SumAmt);
                GenJnlLine.MODIFY();
                Rec."Gen. Journal Line No." := CurrLine;
                Rec."Gen. Journal Document No." := GenJnlLine."Document No.";
                Rec.MODIFY();
            END ELSE BEGIN
                SumAmt := 0;
                WHTEntry.RESET();
                WHTEntry.SETRANGE("WHT No.", Rec."WHT No.");
                IF WHTEntry.FindFirst() THEN begin

                    WHTEntry.CalcSums("WHT Amount");
                    SumAmt := WHTEntry."WHT Amount";

                end;
                GenJnlLine.validate(Amount, -SumAmt);
                GenJnlLine.MODIFY();
                IF Rec."Gen. Journal Line No." = 0 THEN
                    Rec."Gen. Journal Line No." := GenJnlLine."Line No.";
                Rec."Gen. Journal Document No." := GenJnlLine."Document No.";
                Rec.MODIFY();
            END;
        END;

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CreateWHTCertificate();
    end;


}
