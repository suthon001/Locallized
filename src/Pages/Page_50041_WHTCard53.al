page 50041 "WHT53 Card"
{

    PageType = Document;
    SourceTable = "Tax Report Header";
    Caption = 'Withholding tax Card';
    RefreshOnActivate = true;
    SourceTableView = sorting("Tax Type", "Document No.") where("Tax Type" = filter(WHT53));
    DataCaptionExpression = StrSubstNo('%1 ปี %2', Rec."Month Name", Rec."Year No.");
    layout
    {
        area(content)
        {
            group("General")
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }

                field("End date of Month"; Rec."End date of Month")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Year-Month"; Rec."Year-Month")
                {
                    ApplicationArea = All;
                }
                field("Month No."; Rec."Month No.")
                {
                    ApplicationArea = All;
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = All;
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = All;
                }

                field("Date Filter"; DateFilter)
                {
                    Caption = 'Date Filter';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        ApplicationManagement: Codeunit "Filter Tokens";
                        GLAcc: Record "G/L Account";
                    begin
                        ApplicationManagement.MakeDateFilter(DateFilter);
                        GLAcc.SETFILTER("Date Filter", DateFilter);
                        DateFilter := GLAcc.GETFILTER("Date Filter");
                        CurrPage."WHTSubpage".Page."SumAmount"(TotaBaseAmt, TotalVatAmt);
                    end;
                }
                field("Total Base Amount"; TotaBaseAmt)
                {
                    Caption = 'Total Base Amount';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Total Vat Amount"; TotalVatAmt)
                {
                    Caption = 'Total WHT Amount';
                    Editable = false;
                    ApplicationArea = all;
                }

            }
            part("WHTSubpage"; "WHT Subpage")
            {
                SubPageView = sorting("Tax Type", "Document No.", "Entry No.");
                SubPageLink = "Tax Type" = field("Tax Type"), "Document No." = field("Document No.");
                ApplicationArea = all;
                UpdatePropagation = Both;
                Caption = 'WHT Subpage';
            }

        }
    }
    actions
    {
        area(Reporting)
        {

            action("Export PND")
            {
                Caption = 'Export PND';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ExportFile;
                trigger OnAction()
                begin
                    CurrPage."WHTSubpage".Page."ExportPND"();
                end;
            }
            action("Wighholding Report")
            {
                Caption = 'รายงานใบต่อ ภ.ง.ด.';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                trigger OnAction()
                var
                    TaxReportHeader: Record "Tax Report Header";
                    WithholdingReport: Report "Withholding";
                begin
                    Clear(WithholdingReport);
                    TaxReportHeader.Reset();
                    TaxReportHeader.SetRange("Tax Type", Rec."Tax Type");
                    TaxReportHeader.SetRange("Document No.", Rec."Document No.");
                    TaxReportHeader.FindFirst();
                    WithholdingReport.SetTableView(TaxReportHeader);
                    WithholdingReport."SetFilter"('WHT53', DateFilter);
                    WithholdingReport.Run();
                    Clear(WithholdingReport);
                end;
            }
            action("PND 53")
            {
                Caption = 'PND 53';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                trigger OnAction()
                var
                    TaxReportHeader: Record "Tax Report Header";
                    PND53Report: Report "WHT PND 53";
                    WHTBusRec: Record "WHT Business Posting Group";
                begin
                    Clear(PND53Report);
                    TaxReportHeader.Reset();
                    TaxReportHeader.SetRange("Tax Type", Rec."Tax Type");
                    TaxReportHeader.SetRange("End date of Month", Rec."End date of Month");
                    TaxReportHeader.FindFirst();
                    PND53Report.SetTableView(TaxReportHeader);
                    PND53Report."SetFilter"(DateFilter);
                    PND53Report.Run();
                    Clear(PND53Report);
                end;
            }
        }

    }
    /// <summary> 
    /// Description for GetDataFromReport.
    /// </summary>
    /// <param name="SetWHTBus">Parameter of type Code[250].</param>
    /// <param name="SetDate">Parameter of type Text[250].</param>
    procedure "GetDataFromReport"(var SetWHTBus: Code[250]; var SetDate: Text[250])
    begin
        SetWHTBus := WHTBusFilter;
        SetDate := DateFilter;
    end;

    trigger OnOpenPage()
    begin
        Rec.CalcFields("Total Base Amount", "Total VAT Amount");
        TotaBaseAmt := Rec."Total Base Amount";
        TotalVatAmt := Rec."Total VAT Amount";
    end;


    var

        TotaBaseAmt: Decimal;
        TotalVatAmt: Decimal;
        WHTBusFilter: Code[250];
        DateFilter: Text[250];


}
