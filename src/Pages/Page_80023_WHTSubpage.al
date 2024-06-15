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
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT % field.';
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
                field("Building"; Rec."Building")
                {
                    ApplicationArea = All;
                    Caption = 'ชื่ออาคาร/หมู่บ้าน';
                    ToolTip = 'Specifies the value of the ชื่ออาคาร/หมู่บ้าน field.';
                }
                field("House No."; Rec."House No.")
                {
                    ApplicationArea = All;
                    Caption = 'บ้านเลขที่';
                    ToolTip = 'Specifies the value of the เลขที่บ้าน field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'เลขที่ห้อง';
                    ToolTip = 'Specifies the value of the เลขที่ field.';
                }
                field("Floor"; Rec."Floor")
                {
                    ApplicationArea = All;
                    Caption = 'ชั้น';
                    ToolTip = 'Specifies the value of the ชั้น field.';
                }
                field("Village No."; Rec."Village No.")
                {
                    ApplicationArea = All;
                    Caption = 'หมู่ที่';
                    ToolTip = 'Specifies the value of the หมู่ที่ field.';
                }
                field("Street"; Rec."Street")
                {
                    ApplicationArea = All;
                    Caption = 'ถนน';
                    ToolTip = 'Specifies the value of the ถนน field.';
                }
                field("Alley/Lane"; Rec."Alley/Lane")
                {
                    ApplicationArea = All;
                    Caption = 'ตรอก/ซอย';
                    ToolTip = 'Specifies the value of the ตรอก/ซอย field.';
                }
                field("Sub-district"; Rec."Sub-district")
                {
                    ApplicationArea = All;
                    Caption = 'ตำบล/แขวง';
                    ToolTip = 'Specifies the value of the ตำบล/แขวง field.';
                }
                field("District"; Rec."District")
                {
                    ApplicationArea = All;
                    Caption = 'อำเภอ/เขต';
                    ToolTip = 'Specifies the value of the อำเภอ/เขต field.';
                }

                field("Province"; Rec."Province")
                {
                    ApplicationArea = All;
                    Caption = 'จังหวัด';
                    ToolTip = 'Specifies the value of the จังหวัด field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field.';
                    Caption = 'รหัสไปร์ษณีย์';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
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
                    var
                        ltTaxWHTHeader: Record "NCT Tax & WHT Header";
                    begin
                        ltTaxWHTHeader.GET(rec."Tax Type", rec."Document No.");
                        if ltTaxWHTHeader."Tax Type" = ltTaxWHTHeader."Tax Type"::WHT53 then
                            Rec."Get WHTData"(true)
                        else
                            Rec."Get WHTData"(false);
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
                        CurrPage.Update();
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

}
