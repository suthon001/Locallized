page 50015 "Purchase Vat Subpage"
{

    PageType = ListPart;
    SourceTable = "Tax Report Line";
    Caption = 'Purchase Vat Subpage';
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("Send to Report"; Rec."Send to Report")
                {
                    ApplicationArea = all;
                }
                field("Check Status"; Rec."Check Status")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Voucher No."; Rec."Voucher No.")
                {
                    ApplicationArea = All;
                }
                field("Tax Invoice Date"; Rec."Tax Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Tax Invoice No."; Rec."Tax Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Tax Invoice Name"; Rec."Tax Invoice Name")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
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
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                }

                field("VAT Business Posting Group"; Rec."VAT Business Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Product Posting Group"; Rec."VAT Product Posting Group")
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
                action("Generate Vat Entry")
                {
                    Caption = 'Generate Vat Entry';
                    Image = GetEntries;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Rec."GetVatData"();
                        CurrPage.Update();
                    end;

                }
                action("Move Month")
                {
                    Caption = 'Move Month';
                    Image = MoveToNextPeriod;
                    ApplicationArea = all;
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
    /// Description for SetVatBusFilter.
    /// </summary>
    /// <param name="VatBus">Parameter of type Code[30].</param>
    /// <param name="DateFilter">Parameter of type Text[100].</param>
    procedure "SetVatFilter"(VatBus: Code[30]; Vatprod: Code[30]; DateFilter: Text[100])

    begin
        Rec.SETFILTER("VAT Business Posting Group", VatBus);
        Rec.SETFILTER("Tax Invoice Date", DateFilter);
        rec.SetFilter("VAT Product Posting Group", Vatprod);
        CurrPage.Update();
    end;

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




}
