/// <summary>
/// Page NCT WHT Card (ID 80017).
/// </summary>
page 80017 "NCT WHT Card"
{

    PageType = Document;
    SourceTable = "NCT Tax & WHT Header";
    Caption = 'WHT03 Card';
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Request Approval,Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTableView = sorting("Tax Type", "Document No.") where("Tax Type" = filter(WHT03));
    UsageCategory = None;
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
                    ToolTip = 'Specifies the value of the Document No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }

                field("End date of Month"; Rec."End date of Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End date of Month field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Year-Month"; Rec."Year-Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year-Month field.';
                }
                field("Month No."; Rec."Month No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Month No field.';
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Month Name field.';
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year No field.';
                }

                field("Date Filter"; DateFilter)
                {
                    Caption = 'Date Filter';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Filter field.';
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
                    ToolTip = 'Specifies the value of the Total Base Amount field.';
                }
                field("Total Vat Amount"; TotalVatAmt)
                {
                    Caption = 'Total WHT Amount';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total WHT Amount field.';
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }

            }
            part("WHTSubpage"; "NCT WHT Subpage")
            {
                SubPageView = sorting("Tax Type", "Document No.", "Entry No.");
                SubPageLink = "Tax Type" = field("Tax Type"), "Document No." = field("Document No.");
                ApplicationArea = all;
                UpdatePropagation = Both;
                Caption = 'WHT Subpage';
                Editable = rec.Status = rec.Status::Open;
            }

        }
    }
    actions
    {
        area(Processing)
        {
            group("ReleaseReOpen")
            {
                Caption = 'Release&ReOpen';
                action("Release")
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Release action.';
                    trigger OnAction()

                    begin
                        if rec.Status = rec.Status::Released then
                            exit;
                        rec.Status := rec.Status::Released;
                        rec.Modify();
                    end;
                }
                action("Open")
                {
                    Caption = 'Open';
                    Image = ReOpen;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Open action.';
                    trigger OnAction()
                    var

                    begin
                        if rec.Status = rec.Status::Open then
                            exit;
                        rec.Status := rec.Status::Open;
                        rec.Modify();
                    end;
                }
            }
        }
        area(Reporting)
        {


            action("Wighholding Report")
            {
                Caption = 'รายงานใบต่อ ภ.ง.ด.';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                ToolTip = 'Executes the รายงานใบต่อ ภ.ง.ด. action.';
                trigger OnAction()
                var
                    TaxReportHeader: Record "NCT Tax & WHT Header";
                    WithholdingReport: Report "NCT Withholding";
                begin
                    Clear(WithholdingReport);
                    TaxReportHeader.Reset();
                    TaxReportHeader.SetRange("Tax Type", Rec."Tax Type");
                    TaxReportHeader.SetRange("Document No.", Rec."Document No.");
                    TaxReportHeader.FindFirst();
                    WithholdingReport.SetTableView(TaxReportHeader);
                    WithholdingReport."SetFilter"('WHT03', DateFilter);
                    WithholdingReport.Run();
                    Clear(WithholdingReport);
                end;
            }
            action("WHT 03")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                Caption = 'รายงานใบแนบ ภ.ง.ด.';
                ToolTip = 'Executes the รายงานใบแนบ ภ.ง.ด. action.';
                trigger OnAction()
                var
                    TaxReportHeader: Record "NCT Tax & WHT Header";
                begin
                    TaxReportHeader.Reset();
                    TaxReportHeader.SetRange("Tax Type", rec."Tax Type");
                    TaxReportHeader.SetRange("Document No.", rec."Document No.");
                    REPORT.RUN(REPORT::"NCT WHT03 Report", TRUE, TRUE, TaxReportHeader);
                end;
            }
            action("PND 03")
            {
                Caption = 'PND 03';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                ToolTip = 'Executes the PND 03 action.';
                trigger OnAction()
                var
                    TaxReportHeader: Record "NCT Tax & WHT Header";
                    PND03Report: Report "NCT WHT PND 03";
                begin
                    Clear(PND03Report);
                    TaxReportHeader.Reset();
                    TaxReportHeader.SetRange("Tax Type", Rec."Tax Type");
                    TaxReportHeader.SetRange("End date of Month", Rec."End date of Month");
                    TaxReportHeader.FindFirst();
                    PND03Report.SetTableView(TaxReportHeader);
                    PND03Report."SetFilter"(DateFilter);
                    PND03Report.Run();
                    Clear(PND03Report);
                end;
            }
        }

    }
    /// <summary> 
    /// Description for GetDataFromReport.
    /// </summary>
    /// <param name="SetWHTBus">Parameter of type Code[100].</param>
    /// <param name="SetDate">Parameter of type Text[100].</param>
    procedure GetDataFromReport(var SetWHTBus: Code[100]; var SetDate: Text[100])
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
        WHTBusFilter: Code[100];
        DateFilter: Text[100];


}
