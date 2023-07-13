/// <summary>
/// Report Sales Vat (ID 80011).
/// </summary>
report 80011 "NCT Sales Vat"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80011_SalesVat.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report Sales Vat';
    UsageCategory = None;
    dataset
    {
        dataitem("Tax Report Header"; "NCT Tax & WHT Header")
        {
            DataItemTableView = sorting("Tax Type", "Document NO.") where("Tax type" = filter(Sale));

            column(BranchText;
            BranchText)
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
            dataitem("Tax Report Line"; "NCT Tax & WHT Line")
            {
                DataItemTableView = sorting("Tax Type", "Document No.", "Entry No.") where("Send to Report" = const(true));
                DataItemLink = "Tax Type" = field("Tax Type"), "Document No." = field("Document No.");

                column(LineNo; LineNo)
                {
                }


                column(TaxInvoiceNo_TaxReportLine; "Tax Invoice No.")
                {
                }
                column(TaxInvoiceDate_TaxReportLine; "Tax Invoice Date")
                {
                }
                column(TaxInvoiceName_TaxReportLine; "Tax Invoice Name")
                {
                }
                column(Var_EstablishmentLine; Var_EstablishmentLine)
                {
                }
                column(Var_Branch; Var_Branch)
                {
                }
                column(Establishment_TaxReportLine; '')
                {
                }
                column(BranchNo_TaxReportLine; '')
                {
                }
                column(VATRegistrationNo_TaxReportLine; "VAT Registration No.")
                {
                }
                column(Description_TaxReportLine; "Description")
                {
                }
                column(CustAmount_TaxReportLine; "Cust. Amount")
                {
                }
                column(BaseAmount_TaxReportLine; "Base Amount")
                {
                }
                column(BaseAmountVAT7_TaxReportLine; "Base Amount VAT7")
                {
                }
                column(BaseAmountVAT0_TaxReportLine; "Base Amount VAT0")
                {
                }
                column(VATAmount_TaxReportLine; "VAT Amount")
                {
                }
                column(CustAmountPusConcession_TaxReportLine; "Cust. Amt. Pus Concession")
                {
                }
                column(AmountInclVAT_TaxReportLine; "Amount Incl. VAT")
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


                IF VATBusPostingGroup.GET(VatBus) THEN begin
                    Comtext[1] := VATBusPostingGroup."NCT Company Name (Thai)" + ' ' + VATBusPostingGroup."NCT Company Name 2 (Thai)";
                    Comtext[2] := VATBusPostingGroup."NCT Company Address (Thai)";
                    Comtext[3] := VATBusPostingGroup."NCT Company Address 2 (Thai)";
                    Comtext[4] := VATBusPostingGroup."NCT VAT Registration No.";
                    IF VATBusPostingGroup."NCT Head Office" THEN BEGIN

                        var_BrandNo := '';
                        var_BrandName := 'สำนักงานใหญ่';
                    END ELSE BEGIN

                        var_BrandName := 'สาขาที่';
                        var_BrandNo := VATBusPostingGroup."NCT Branch Code";
                    END;
                end else begin
                    Comtext[1] := CompanyInformation.Name + ' ' + CompanyInformation."Name 2";
                    Comtext[2] := CompanyInformation.Address;
                    Comtext[3] := CompanyInformation."Address 2";
                    Comtext[4] := CompanyInformation."VAT Registration No.";
                    IF CompanyInformation."NCT Head Office" THEN BEGIN

                        var_BrandNo := '';
                        var_BrandName := 'สำนักงานใหญ่';
                    END ELSE BEGIN

                        var_BrandName := 'สาขาที่';
                        var_BrandNo := CompanyInformation."NCT Branch Code";
                    END;
                end;

            end;
        }
    }

    /// <summary> 
    /// Description for SetFilter.
    /// </summary>
    /// <param name="TempVatBus">Parameter of type Code[30].</param>
    /// <param name="TempProd">Code[250].</param>
    /// <param name="Tempdate">Parameter of type Text[100].</param>
    procedure "SetFilter"(TempVatBus: Code[250]; TempProd: Code[250]; Tempdate: Text)
    begin
        if TempVatBus <> '' then
            "Tax Report Line".SetFilter("VAT Business Posting Group", TempVatBus);
        if TempProd <> '' then
            "Tax Report Line".SetFilter("VAT Product Posting Group", TempProd);
        if Tempdate <> '' then
            "Tax Report Line".SetFilter("Tax Invoice Date", Tempdate);
        VatBus := TempVatBus;
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);

    end;

    var

        CompanyInformation: Record "Company Information";
        LineNo: Integer;
        Var_EstablishmentLine: Text[50];
        Var_Branch: Text[50];
        VATBusPostingGroup: Record "VAT Business Posting Group";
        var_BrandNo: Text[10];
        var_BrandName: Code[20];
        VatBus: text[250];
        Comtext: Array[10] of text[250];

        BranchText: Code[5];

}

