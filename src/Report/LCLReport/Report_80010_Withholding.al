/// <summary>
/// Report Withholding (ID 80010).
/// </summary>
report 80010 "NCT Withholding"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80010_Withholding.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report Withholding';
    UsageCategory = none;
    dataset
    {
        dataitem("Tax Report Header"; "NCT Tax Report Header")
        {
            column(WHTTypeFilter; Rec_WHTBusinessPostingGroup."Description")
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
            {
            }
            column(Address2_CompanyInformation; CompanyInformation."Address 2")
            {
            }
            column(VATRegistrationNo_CompanyInformation; CompanyInformation."VAT Registration No.")
            {
            }
            column(YesrPS; YesrPS)
            {
            }
            column(MonthName_TaxReportHeader; "Month Name")
            {
            }
            column(NoofPerpage; GeneralLedgerSetup."NCT No. of Perpage")
            {

            }
            dataitem("Tax Report Line"; "NCT Tax Report Line")
            {
                DataItemTableView = sorting("Tax Type", "Document No.", "Entry No.");
                DataItemLink = "Tax Type" = FIELD("Tax Type"),
                               "Document No." = FIELD("Document No.");
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
                column(TaxType_TaxReportLine; "Tax Type")
                {
                }
                column(WHTDocumentNo_TaxReportLine; "WHT Document No.")
                {
                }
                column(WHTRegistrationID_TaxReportLine; "WHT Registration No.")
                {
                }
                column(WHTPercent_TaxReportLine; "WHT %")
                {
                }
                column(Name_TaxReportLine; "Name")
                {
                }
                column(Address_TaxReportLine; "Address")
                {
                }
                column(Address2_TaxReportLine; "Address 2")
                {
                }
                column(City_TaxReportLine; "City")
                {
                }
                column(PostCode_TaxReportLine; "Post Code")
                {
                }
                column(County_TaxReportLine; "County")
                {
                }
                column(DocumentNo_TaxReportLine; "Voucher No.")
                {
                }
                column(PostingDate_TaxReportLine; "Posting Date")
                {
                }
                column(WHTProduct; WHTProduct)
                {
                }
                column(DocumentNo; DocumentNo)
                {
                }
                column(WHTDocumentNo; WHTDocumentNo)
                {
                }
                column(WHTPercent_1; WHTPercent[1])
                {
                }
                column(TaxType_1; TaxType[1])
                {
                }
                column(BaseAmount_1; BaseAmount[1])
                {
                }
                column(VATAmount_1; VATAmount[1])
                {
                }
                column(WHTPercent_2; WHTPercent[2])
                {
                }
                column(TaxType_2; TaxType[2])
                {
                }
                column(BaseAmount_2; BaseAmount[2])
                {
                }
                column(VATAmount_2; VATAmount[2])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Show_DocumentNo THEN BEGIN
                        DocumentNo := "Vendor No.";
                        WHTDocumentNo := "WHT Document No."
                    END
                    ELSE BEGIN
                        DocumentNo := '';
                        WHTDocumentNo := '';
                    END;
                    LineNo += 1;
                    WHTProductPostingGroup.GET("WHT Product Posting Group");
                    WHTProduct := WHTProductPostingGroup."Description";

                    CLEAR(WHTPercent);
                    CLEAR(TaxType);
                    CLEAR(BaseAmount);
                    CLEAR(VATAmount);


                    WHTPercent[1] := "WHT %";
                    if not WHTProductPostingGroup.GET("WHT Product Posting Group") then
                        WHTProductPostingGroup.init();
                    TaxType[1] := WHTProductPostingGroup."Description";
                    BaseAmount[1] := "Base Amount";
                    VATAmount[1] := "VAT Amount";

                    TaxReportLineFind.RESET();
                    TaxReportLineFind.SETFILTER("Tax Type", '%1', "Tax Type");
                    TaxReportLineFind.SETFILTER("Document No.", '%1', "Document No.");
                    TaxReportLineFind.SETFILTER("WHT Document No.", '%1', "WHT Document No.");
                    TaxReportLineFind.SetFilter("WHT Product Posting Group", '<>%1', "WHT Product Posting Group");
                    IF TaxReportLineFind.FIND('-') THEN begin
                        //  REPEAT
                        //  i += 1;
                        WHTPercent[2] := TaxReportLineFind."WHT %";
                        if not WHTProductPostingGroup.GET(TaxReportLineFind."WHT Product Posting Group") then
                            WHTProductPostingGroup.init();
                        TaxType[2] := WHTProductPostingGroup."Description";
                        BaseAmount[2] := TaxReportLineFind."Base Amount";
                        VATAmount[2] := TaxReportLineFind."VAT Amount";
                    end;
                    //  UNTIL TaxReportLineFind.NEXT = 0;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("WHT Business Posting Group", WHTBus);
                    if WHTDate <> '' then
                        SetFilter("Posting Date", WHTDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                YesrPS := "Year No." + 543;
                IF NOT Rec_WHTBusinessPostingGroup.GET(WHTBus) THEN
                    CLEAR(Rec_WHTBusinessPostingGroup);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Show Document No"; Show_DocumentNo)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Show_DocumentNo field.';
                        Caption = 'Show Document No.';
                    }
                }
            }
        }


    }



    trigger OnPreReport()
    begin

        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
        GeneralLedgerSetup.get();
        GeneralLedgerSetup.TestField("NCT No. of Perpage");
    end;

    /// <summary> 
    /// Description for SetFilter.
    /// </summary>
    /// <param name="TempWHT">Parameter of type Code[30].</param>
    /// <param name="Tempdate">Parameter of type Text[100].</param>
    procedure "SetFilter"(TempWHT: Code[30]; Tempdate: Text)
    begin
        if Tempdate <> '' then
            "Tax Report Line".SetFilter("Posting Date", Tempdate);
        WHTBus := TempWHT;
        WHTDate := Tempdate;

    end;

    var
        CompanyInformation: Record 79;
        LineNo: Integer;
        YesrPS: Integer;
        Rec_WHTBusinessPostingGroup: Record "NCT WHT Business Posting Group";
        WHTProductPostingGroup: Record "NCT WHT Product Posting Group";
        Show_DocumentNo: Boolean;
        WHTProduct: text[100];
        DocumentNo: Code[20];
        WHTDocumentNo: Code[20];
        WHTPercent: array[2] of Decimal;
        TaxType: array[2] of Text[100];
        BaseAmount: array[2] of Decimal;
        VATAmount: array[2] of Decimal;
        TaxReportLineFind: Record "NCT Tax Report Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        WHTBus: Code[100];
        WHTDate: Text;
}

