page 50011 "Sales Vat Card"
{

    PageType = Document;
    SourceTable = "Tax Report Header";
    Caption = 'Sales Vat Card';
    RefreshOnActivate = true;
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
                field("Vat Option"; Rec."Vat Option")
                {
                    ApplicationArea = all;
                }
                field("Vat Bus. Post. Filter"; VatBusFilter)
                {
                    Caption = 'Vat Business Posing Group Filter';
                    TableRelation = "VAT Business Posting Group".Code;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin

                        CurrPage."SalesVatSubpage".Page."SetVatFilter"(VatBusFilter, VatProdFilter, DateFilter);
                        CurrPage."SalesVatSubpage".Page."SumAmount"(TotaBaseAmt, TotalVatAmt);
                    end;

                }
                field(VatProdFilter; VatProdFilter)
                {
                    Caption = 'Vat Prod. Posing Group Filter';
                    TableRelation = "VAT Product Posting Group".Code;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin

                        CurrPage."SalesVatSubpage".Page."SetVatFilter"(VatBusFilter, VatProdFilter, DateFilter);
                        CurrPage."SalesVatSubpage".Page."SumAmount"(TotaBaseAmt, TotalVatAmt);
                    end;

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

                        CurrPage."SalesVatSubpage".Page."SetVatFilter"(VatBusFilter, VatProdFilter, DateFilter);
                        CurrPage."SalesVatSubpage".Page."SumAmount"(TotaBaseAmt, TotalVatAmt);
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
                    Caption = 'Total Vat Amount';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            part("SalesVatSubpage"; "Sales Vat Subpage")
            {
                SubPageView = sorting("Tax Type", "Document No.", "Entry No.");
                SubPageLink = "Tax Type" = field("Tax Type"), "Document No." = field("Document No.");
                ApplicationArea = all;
                UpdatePropagation = Both;
                Caption = 'Sales Vat Subpage';
            }

        }

    }
    actions
    {
        area(Reporting)
        {
            action("Sales Vat Report")
            {
                Caption = 'รายงานภาษีขาย';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintVAT;
                trigger OnAction()
                var
                    TaxReportHeader: Record "Tax Report Header";
                    ReportSalesVat: Report "Sales Vat";
                begin

                    Clear(ReportSalesVat);
                    TaxReportHeader.Reset();
                    TaxReportHeader.SetRange("Tax Type", Rec."Tax Type");
                    TaxReportHeader.SetRange("Document No.", Rec."Document No.");
                    TaxReportHeader.FindFirst();
                    ReportSalesVat.SetTableView(TaxReportHeader);
                    ReportSalesVat."SetFilter"(vatBusFilter, VatProdFilter, DateFilter);
                    ReportSalesVat.Run();
                    Clear(ReportSalesVat);
                end;
            }
        }

    }
    /// <summary> 
    /// Description for GetDataFromReport.
    /// </summary>
    /// <param name="SetVatBus">Parameter of type Code[250].</param>
    /// <param name="SetDate">Parameter of type Text[250].</param>
    procedure "GetDataFromReport"(var SetVatBus: Code[250]; var SetDate: Text[250])
    begin
        SetVatBus := VatBusFilter;
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
        VatBusFilter, VatProdFilter : Code[250];
        DateFilter: Text[250];


}
