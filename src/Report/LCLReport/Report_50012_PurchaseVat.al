report 50012 "Purchase Vat Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50012_PurchaseVat.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report Purchase Vat';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("Tax Report Header"; "Tax Report Header")
        {
            DataItemTableView = sorting("Tax Type", "Document NO.") where("Tax type" = filter(purchase));
            column(VATRegis; VATRegis)
            {
            }
            column(Name_CompanyInformation; Comtext[1])
            {
            }
            column(Address_CompanyInformation; Comtext[2])
            {
            }
            column(Address2_CompanyInformation; Comtext[3])
            {
            }
            column(City; CompanyInformation.City)
            {
            }
            column(PostCode; CompanyInformation."Post Code")
            {
            }
            column(VATRegistrationNo_CompanyInformation; Comtext[4])
            {
            }
            column(YesrPS; "Year No.")
            {
            }
            column(MonthName_TaxReportHeader; "Month Name")
            {
            }
            column(var_BrandNo; var_BrandNo)
            {
            }
            column(var_BrandName; var_BrandName)
            {
            }
            dataitem("Tax Report Line"; "Tax Report Line")
            {
                DataItemTableView = sorting("Tax Type", "Document No.", "Entry No.") where("Send to Report" = const(true));
                DataItemLink = "Tax Type" = field("Tax Type"), "Document No." = field("Document No.");


                column(LineNo; LineNo)
                {
                }
                column(TaxInvoiceNo_TaxReportLine; "Tax Invoice No.")
                {
                }
                column(TaxInvoiceDate_TaxReportLine; format("Tax Invoice Date"))
                {
                }
                column(TaxInvoiceName_TaxReportLine; "Tax Invoice Name")
                {
                }
                column(Establishment_TaxReportLine; "Head Office")
                {
                }
                column(BranchNo_TaxReportLine; "Branch Code")
                {
                }
                column(VATRegistrationNo_TaxReportLine; "VAT Registration No.")
                {
                }
                column(Description_TaxReportLine; "Description")
                {
                }
                column(BaseAmount_TaxReportLine; "Base Amount")
                {
                }
                column(VATAmount_TaxReportLine; "VAT Amount")
                {
                }
                column(Var_EstablishmentLine; Var_EstablishmentLine)
                {
                }
                column(Var_Branch; Var_Branch)
                {
                }
                column(VoucherNo_TaxReportLine; "Voucher No.")
                {
                }
                column(SequenceNo_TaxReportLine; '')
                {
                }
                column(EntryNo_TaxReportLine; "Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                begin


                    LineNo += 1;
                    clear(Var_EstablishmentLine);
                    Clear(Var_Branch);
                    if "Head Office" then
                        Var_EstablishmentLine := '/'
                    else
                        Var_Branch := "Branch Code";
                end;
            }

            trigger OnAfterGetRecord()

            begin

                if VatBus <> '' then begin

                    if not VATBusinessPostingGroup.GET(VatBus) then
                        VATBusinessPostingGroup.init();
                    Comtext[1] := VATBusinessPostingGroup."Company Name (Thai)" + ' ' + VATBusinessPostingGroup."Company Name 2 (Thai)";
                    Comtext[2] := VATBusinessPostingGroup."Company Address (Thai)";
                    Comtext[3] := VATBusinessPostingGroup."Company Address 2 (Thai)";
                    Comtext[4] := VATBusinessPostingGroup."VAT Registration No.";
                    IF VATBusinessPostingGroup."Head Office" then BEGIN
                        var_BrandNo := '';
                        var_BrandName := 'สำนักงานใหญ่';
                    END
                    ELSE BEGIN
                        var_BrandNo := VATBusinessPostingGroup."Branch Code";
                        var_BrandName := 'สาขาที่ ';
                    END;
                    var_BrandAddress := VATBusinessPostingGroup."Company Address (Thai)" + ' ';
                    var_BrandAddress2 := VATBusinessPostingGroup."Company Address 2 (Thai)" + ' ' + VATBusinessPostingGroup."City (Thai)" + ' ' + VATBusinessPostingGroup."Post code";

                    VATRegis := VATBusinessPostingGroup."VAT Registration No.";
                end else begin
                    Comtext[1] := CompanyInformation.Name + ' ' + CompanyInformation."Name 2";
                    Comtext[2] := CompanyInformation.Address;
                    Comtext[3] := CompanyInformation."Address 2";
                    Comtext[4] := CompanyInformation."VAT Registration No.";
                    if CompanyInformation."Head Office" then begin
                        var_BrandName := 'สำนักงานใหญ่';
                        var_BrandNo := '';
                    end else begin
                        var_BrandName := 'สาขาที่ ';
                        var_BrandNo := CompanyInformation."Branch Code";
                    end;
                    var_BrandAddress := CompanyInformation.Address + ' ';
                    var_BrandAddress2 := CompanyInformation."Address 2" + ' ' + CompanyInformation.City + ' ' + CompanyInformation."Post Code";
                    VATRegis := CompanyInformation."VAT Registration No.";

                end;


            end;
        }
    }


    trigger OnPreReport()
    begin

        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
    end;

    /// <summary> 
    /// Description for SetFilter.
    /// </summary>
    /// <param name="TempVatBus">Parameter of type Code[250].</param>
    /// <param name="TemVatPro">Code[250].</param>
    /// <param name="Tempdate">Parameter of type Text[100].</param>
    procedure "SetFilter"(TempVatBus: Code[250]; TemVatPro: Code[250]; Tempdate: Text)
    begin
        if TempVatBus <> '' then
            "Tax Report Line".SetFilter("VAT Business Posting Group", TempVatBus);
        if TemVatPro <> '' then
            "Tax Report Line".SetFilter("VAT Product Posting Group", TemVatPro);
        if Tempdate <> '' then
            "Tax Report Line".SetFilter("Tax Invoice Date", Tempdate);

        VatBus := TempVatBus;
    end;

    var
        CompanyInformation: Record "Company Information";
        LineNo: Integer;
        Var_EstablishmentLine: Text[50];
        Var_Branch: Text[50];
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
        var_BrandNo: Text[10];
        var_BrandName: Code[20];
        var_BrandAddress: Text;
        var_BrandAddress2: Text;
        VATRegis: Text;
        VatBus: Code[250];
        Comtext: Array[10] of text[250];

}

