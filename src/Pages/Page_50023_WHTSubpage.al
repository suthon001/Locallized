page 50023 "WHT Subpage"
{

    PageType = ListPart;
    SourceTable = "Tax Report Line";
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
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                // field("WHT Date"; "WHT Date")
                // {
                //     ApplicationArea = All;
                // }
                field("Voucher No."; Rec."Voucher No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }
                field("WHT Document No."; Rec."WHT Document No.")
                {
                    ApplicationArea = All;
                }
                field("WHT Certificate No."; rec."WHT Certificate No.")
                {
                    ApplicationArea = all;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Amount';
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = All;
                }
                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = All;
                }
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("WHT Registration No."; Rec."WHT Registration No.")
                {
                    ApplicationArea = All;
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
                    trigger OnAction()
                    var
                        MoveMonthPage: Page "Tax Move Month";
                        TaxReportHeader: Record "Tax Report Header";
                        TempTaxReportLine: Record "Tax Report Line" temporary;
                        TaxReportLine: Record "Tax Report Line";

                    begin
                        TaxReportHeader.get(Rec."Tax Type", Rec."Document No.");
                        TaxReportLine.reset;
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
    procedure "SumAmount"(var BaseAmount: Decimal; var VatAmount: Decimal)
    var
        TaxReportLine: Record "Tax Report Line";
    begin
        TaxReportLine.reset;
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
    procedure "ExportPND"()
    var
        Instrm: InStream;
        OutStrm: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        TaxReportLine: Record "Tax Report Line";
        TempTaxt: Text;
        LineNo: Integer;
        TaxReportHeader: Record "Tax Report Header";
    begin

        LineNo := 0;
        TaxReportHeader.get(Rec."Tax Type", Rec."Document No.");
        WHTBusinessPostingGroup.Get(format(rec."Tax Type"));
        FileName := StrSubstNo('%1_%2%3', TaxReportHeader."End date of Month", WHTBusinessPostingGroup."Code", '.txt');
        TempBlob.CreateOutStream(OutStrm, TextEncoding::UTF8);
        TaxReportLine.reset;
        TaxReportLine.CopyFilters(Rec);
        if TaxReportLine.FindFirst() then begin
            repeat
                if TaxReportLine."Head Office" then
                    BranchCode := '00000'
                else
                    BranchCode := TaxReportLine."Branch Code";
                if BranchCode = '' then
                    BranchCode := '-';
                CustVendorBranch.reset;
                CustVendorBranch.SetRange("Source Type", CustVendorBranch."Source Type"::Vendor);
                CustVendorBranch.SetRange("Source No.", TaxReportLine."Vendor No.");
                CustVendorBranch.SetRange("Head Office", TaxReportLine."Head Office");
                CustVendorBranch.SetRange("Branch Code", TaxReportLine."Branch Code");
                if CustVendorBranch.FindFirst() then begin
                    BranchData[1] := CustVendorBranch."Title Name";
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
                    WHTProductPortingGroup.init;
                LineNo += 1;
                if (WHTBusinessPostingGroup."WHT Certificate Option" = WHTBusinessPostingGroup."WHT Certificate Option"::"ภ.ง.ด.3") then begin
                    TempTaxt := FORMAT(LineNo) + '|' + FORMAT(DelChr(TaxReportLine."VAT Registration No.", '=', '-')) + '|' +
                                BranchCode + '|' + BranchData[1] + '|' + FORMAT(BranchData[2]) + '|' + '|' + FORMAT(BranchData[3]) + '|' +
                                FORMAT(BranchData[4]) + '|' + FORMAT(BranchData[5]) + '|' + FORMAT(BranchData[6]) + '|' + FORMAT(BranchData[7]) + '|' +
                                FORMAT(BranchData[8]) + '|' + FORMAT(BranchData[9]) + '|' + FORMAT(BranchData[10]) + '|' + FORMAT(BranchData[11]) + '|' +
                                FORMAT(BranchData[12]) + '|' + FORMAT(BranchData[13]) + '|' +
                                FORMAT(TaxReportLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '|' + FORMAT(WHTProductPortingGroup."Description") + '|' +
                                DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."WHT %"), '=', ',') + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."Base Amount"), '=', ',')
                                + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."VAT Amount"), '=', ',') + '|' + FORMAT(1);
                end else begin
                    if (WHTBusinessPostingGroup."WHT Certificate Option" = WHTBusinessPostingGroup."WHT Certificate Option"::"ภ.ง.ด.53") then begin
                        TempTaxt := FORMAT(LineNo) + '|' + FORMAT(DelChr(TaxReportLine."VAT Registration No.", '=', '-')) + '|' +
                              BranchCode + '|' + BranchData[1] + '|' + FORMAT(BranchData[2]) + '|' + FORMAT(BranchData[3]) + '|' +
                              FORMAT(BranchData[4]) + '|' + FORMAT(BranchData[5]) + '|' + FORMAT(BranchData[6]) + '|' + FORMAT(BranchData[7]) + '|' +
                              FORMAT(BranchData[8]) + '|' + FORMAT(BranchData[9]) + '|' + FORMAT(BranchData[10]) + '|' + FORMAT(BranchData[11]) + '|' +
                              FORMAT(BranchData[12]) + '|' + FORMAT(BranchData[13]) + '|' +
                              FORMAT(TaxReportLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '|' + FORMAT(WHTProductPortingGroup."Description") + '|' +
                              DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."WHT %"), '=', ',') + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."Base Amount"), '=', ',')
                              + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."VAT Amount"), '=', ',') + '|' + FORMAT(1);
                    end;
                end;
                OutStrm.WriteText(TempTaxt);
                OutStrm.WriteText();
                TempTaxt := '';
            Until TaxReportLine.Next() = 0;
        end;

        TempBlob.CreateInStream(Instrm, TextEncoding::UTF8);
        DownloadFromStream(Instrm, 'Export', '', '*.txt|(*.txt)', FileName);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        WHTHeader: Record "WHT Header";
        WHTLines: Record "WHT Lines";
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
        WHTCode: Code[30];
        WHTBusinessPostingGroup: Record "WHT Business Posting Group";
        BranchCode: Code[5];
        BranchData: array[13] of text;
        CustVendorBranch: Record "Customer & Vendor Branch";
        WHTProductPortingGroup: Record "WHT Product Posting Group";
        FunctionCenter: Codeunit "Function Center";

}
