/// <summary>
/// Page NCT WHT Subpage (ID 80023).
/// </summary>
page 80023 "NCT WHT Subpage"
{

    PageType = ListPart;
    SourceTable = "NCT Tax & WHT Line";
    Caption = 'Withholding tax Subpage';
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                // field("WHT Date"; "WHT Date")
                // {
                //     ApplicationArea = All;
                // }
                field("Voucher No."; Rec."Voucher No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("WHT Document No."; Rec."WHT Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Document No. field.';
                }
                field("WHT Certificate No."; rec."WHT Certificate No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate No. field.';
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base Amount field.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Amount';
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT % field.';
                }
                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                }
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Product Posting Group field.';
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name 2 field.';
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field("WHT Registration No."; Rec."WHT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Registration No. field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Generate WHT Entry")
                {
                    Caption = 'Generate WHT Entry';
                    Image = GetEntries;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Generate WHT Entry action.';
                    trigger OnAction()
                    begin
                        Rec."Get WHTData"();
                        CurrPage.Update();
                    end;

                }
                action("Move Month")
                {
                    Caption = 'Move Month';
                    Image = MoveToNextPeriod;
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Executes the Move Month action.';
                    trigger OnAction()
                    var
                        MoveMonthPage: Page "NCT Tax Move Month";
                        TaxReportHeader: Record "NCT Tax & WHT Header";
                        TaxReportLine: Record "NCT Tax & WHT Line";

                    begin
                        TaxReportHeader.get(Rec."Tax Type", Rec."Document No.");
                        TaxReportLine.reset();
                        TaxReportLine.Copy(Rec);
                        CurrPage.SetSelectionFilter(TaxReportLine);
                        Clear(MoveMonthPage);
                        MoveMonthPage.Editable := false;
                        MoveMonthPage.LookupMode := true;
                        MoveMonthPage."SetData"(Rec."Tax Type", TaxReportHeader."End date of Month", TaxReportLine);
                        MoveMonthPage.RunModal();
                        Clear(MoveMonthPage);
                    end;
                }
            }
        }
    }
    /// <summary> 
    /// Description for SumAmount.
    /// </summary>
    /// <param name="BaseAmount">Parameter of type Decimal.</param>
    /// <param name="VatAmount">Parameter of type Decimal.</param>
    procedure SumAmount(var BaseAmount: Decimal; var VatAmount: Decimal)
    var
        TaxReportLine: Record "NCT Tax & WHT Line";
    begin
        TaxReportLine.reset();
        TaxReportLine.CopyFilters(rec);
        if TaxReportLine.FindFirst() then begin
            TaxReportLine.CalcSums("Base Amount", "VAT Amount");
            BaseAmount := TaxReportLine."Base Amount";
            VatAmount := TaxReportLine."VAT Amount";
        end else begin
            BaseAmount := 0;
            VatAmount := 0;
        end;
    end;

    /// <summary> 
    /// Description for ExportPND.
    /// </summary>
    procedure ExportPND()
    var
        Instrm: InStream;
        OutStrm: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        TaxReportLine: Record "NCT Tax & WHT Line";
        TempTaxt: Text;
        LineNo: Integer;
        TaxReportHeader: Record "NCT Tax & WHT Header";
        ltFileNameLbl: Label '%1_%2%3', Locked = true;
    begin

        LineNo := 0;
        TaxReportHeader.get(Rec."Tax Type", Rec."Document No.");
        WHTBusinessPostingGroup.Get(format(rec."Tax Type"));
        FileName := StrSubstNo(ltFileNameLbl, TaxReportHeader."End date of Month", WHTBusinessPostingGroup."Code", '.txt');
        TempBlob.CreateOutStream(OutStrm, TextEncoding::UTF8);
        TaxReportLine.reset();
        TaxReportLine.CopyFilters(Rec);
        if TaxReportLine.FindSet() then
            repeat
                if TaxReportLine."Head Office" then
                    BranchCode := '00000'
                else
                    BranchCode := TaxReportLine."Branch Code";
                if BranchCode = '' then
                    BranchCode := '-';
                CustVendorBranch.reset();
                CustVendorBranch.SetRange("Source Type", CustVendorBranch."Source Type"::Vendor);
                CustVendorBranch.SetRange("Source No.", TaxReportLine."Vendor No.");
                CustVendorBranch.SetRange("Head Office", TaxReportLine."Head Office");
                CustVendorBranch.SetRange("Branch Code", TaxReportLine."Branch Code");
                if CustVendorBranch.FindFirst() then begin
                    BranchData[1] := format(CustVendorBranch."Title Name");
                    if BranchData[1] = '' then
                        BranchData[1] := '-';
                    BranchData[2] := CustVendorBranch."Name";
                    BranchData[3] := CustVendorBranch."Building";
                    BranchData[4] := CustVendorBranch."House No.";
                    BranchData[5] := CustVendorBranch."Floor";
                    BranchData[6] := CustVendorBranch."No.";
                    BranchData[7] := CustVendorBranch."Village No.";
                    BranchData[8] := CustVendorBranch."Alley/Lane";
                    BranchData[9] := CustVendorBranch."Street";
                    BranchData[10] := CustVendorBranch."Sub-district";
                    BranchData[11] := CustVendorBranch."District";
                    BranchData[12] := CustVendorBranch."Province";
                    BranchData[13] := CustVendorBranch."post Code";
                end;

                IF NOT WHTProductPortingGroup.Get(TaxReportLine."WHT Product Posting Group") then
                    WHTProductPortingGroup.init();
                LineNo += 1;
                if (WHTBusinessPostingGroup."WHT Certificate Option" = WHTBusinessPostingGroup."WHT Certificate Option"::"ภ.ง.ด.3") then
                    TempTaxt := FORMAT(LineNo) + '|' + FORMAT(DelChr(TaxReportLine."VAT Registration No.", '=', '-')) + '|' +
                                BranchCode + '|' + BranchData[1] + '|' + FORMAT(BranchData[2]) + '|' + '|' + FORMAT(BranchData[3]) + '|' +
                                FORMAT(BranchData[4]) + '|' + FORMAT(BranchData[5]) + '|' + FORMAT(BranchData[6]) + '|' + FORMAT(BranchData[7]) + '|' +
                                FORMAT(BranchData[8]) + '|' + FORMAT(BranchData[9]) + '|' + FORMAT(BranchData[10]) + '|' + FORMAT(BranchData[11]) + '|' +
                                FORMAT(BranchData[12]) + '|' + FORMAT(BranchData[13]) + '|' +
                                FORMAT(TaxReportLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '|' + FORMAT(WHTProductPortingGroup."Description") + '|' +
                                DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."WHT %"), '=', ',') + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."Base Amount"), '=', ',')
                                + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."VAT Amount"), '=', ',') + '|' + FORMAT(1)
                else
                    if (WHTBusinessPostingGroup."WHT Certificate Option" = WHTBusinessPostingGroup."WHT Certificate Option"::"ภ.ง.ด.53") then
                        TempTaxt := FORMAT(LineNo) + '|' + FORMAT(DelChr(TaxReportLine."VAT Registration No.", '=', '-')) + '|' +
                              BranchCode + '|' + BranchData[1] + '|' + FORMAT(BranchData[2]) + '|' + FORMAT(BranchData[3]) + '|' +
                              FORMAT(BranchData[4]) + '|' + FORMAT(BranchData[5]) + '|' + FORMAT(BranchData[6]) + '|' + FORMAT(BranchData[7]) + '|' +
                              FORMAT(BranchData[8]) + '|' + FORMAT(BranchData[9]) + '|' + FORMAT(BranchData[10]) + '|' + FORMAT(BranchData[11]) + '|' +
                              FORMAT(BranchData[12]) + '|' + FORMAT(BranchData[13]) + '|' +
                              FORMAT(TaxReportLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '|' + FORMAT(WHTProductPortingGroup."Description") + '|' +
                              DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."WHT %"), '=', ',') + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."Base Amount"), '=', ',')
                              + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."VAT Amount"), '=', ',') + '|' + FORMAT(1);
                OutStrm.WriteText(TempTaxt);
                OutStrm.WriteText();
                TempTaxt := '';
            Until TaxReportLine.Next() = 0;

        TempBlob.CreateInStream(Instrm, TextEncoding::UTF8);
        DownloadFromStream(Instrm, 'Export', '', '*.txt|(*.txt)', FileName);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        WHTHeader: Record "NCT WHT Header";
        WHTLines: Record "NCT WHT Line";
    begin
        if WHTLines.GET(Rec."WHT Document No.", Rec."Ref. Wht Line") then begin
            WHTHeader.GET(Rec."WHT Document No.");
            WHTHeader."Get to WHT" := false;
            WHTLines."Get to WHT" := false;
            WHTLines.Modify();
            WHTHeader.Modify();
        end;


    end;

    var
        WHTBusinessPostingGroup: Record "NCT WHT Business Posting Group";
        BranchCode: Code[5];
        BranchData: array[13] of text;
        CustVendorBranch: Record "NCT Customer & Vendor Branch";
        WHTProductPortingGroup: Record "NCT WHT Product Posting Group";
        FunctionCenter: Codeunit "NCT Function Center";

}
