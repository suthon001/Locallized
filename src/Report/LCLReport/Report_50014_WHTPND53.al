report 50014 "WHT PND 53"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50014_PND_53.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report PND 53';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("Tax Report Header"; "Tax Report Header")
        {
            column(WHTTypeFilter; WHTTypeFilter)
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
            column(VAT_ID_1; VAT_ID[1])
            {
            }
            column(VAT_ID_2; VAT_ID[2])
            {
            }
            column(VAT_ID_3; VAT_ID[3])
            {
            }
            column(VAT_ID_4; VAT_ID[4])
            {
            }
            column(VAT_ID_5; VAT_ID[5])
            {
            }
            column(VAT_ID_6; VAT_ID[6])
            {
            }
            column(VAT_ID_7; VAT_ID[7])
            {
            }
            column(VAT_ID_8; VAT_ID[8])
            {
            }
            column(VAT_ID_9; VAT_ID[9])
            {
            }
            column(VAT_ID_10; VAT_ID[10])
            {
            }
            column(VAT_ID_11; VAT_ID[11])
            {
            }
            column(VAT_ID_12; VAT_ID[12])
            {
            }
            column(VAT_ID_13; VAT_ID[13])
            {
            }
            column(var_VATAddress; var_VATAddress)
            {
            }
            column(Month_No_1; Month_No[1])
            {
            }
            column(Month_No_2; Month_No[2])
            {
            }
            column(Month_No_3; Month_No[3])
            {
            }
            column(Month_No_4; Month_No[4])
            {
            }
            column(Month_No_5; Month_No[5])
            {
            }
            column(Month_No_6; Month_No[6])
            {
            }
            column(Month_No_7; Month_No[7])
            {
            }
            column(Month_No_8; Month_No[8])
            {
            }
            column(Month_No_9; Month_No[9])
            {
            }
            column(Month_No_10; Month_No[10])
            {
            }
            column(Month_No_11; Month_No[11])
            {
            }
            column(Month_No_12; Month_No[12])
            {
            }
            column(var_Amount; var_Amount)
            {
            }
            column(var_WHTAmount; var_WHTAmount)
            {
            }
            column(var_WHTTotalAmount; var_WHTTotalAmount)
            {
            }
            column(var_Send_Type_1; var_Send_Type[1])
            {
            }
            column(var_Send_Type_2; var_Send_Type[2])
            {
            }
            column(var_Send_Type_3; var_Send_Type[3])
            {
            }
            column(var_Send_Option_1; var_Send_Option[1])
            {
            }
            column(var_Send_Option_2; var_Send_Option[2])
            {
            }
            column(var_CountVend; var_CountVend)
            {
            }
            column(Total_Page; 1)
            {
            }
            column(Additional_No; Additional_No)
            {
            }
            column(var_CompanyName; var_CompanyName)
            {
            }

            trigger OnAfterGetRecord()
            var
                var_WHTNo: Code[20];
                var_WHTRegisNo: Code[20];
            begin

                YesrPS := "Year No." + 543;

                Rec_WHTBusinessPostingGroup.GET('WHT53');
                //###### SubString VAT ID #####
                VAT_ID[1] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 1, 1);
                VAT_ID[2] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 2, 1);
                VAT_ID[3] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 3, 1);
                VAT_ID[4] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 4, 1);
                VAT_ID[5] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 5, 1);
                VAT_ID[6] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 6, 1);
                VAT_ID[7] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 7, 1);
                VAT_ID[8] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 8, 1);
                VAT_ID[9] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 9, 1);
                VAT_ID[10] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 10, 1);
                VAT_ID[11] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 11, 1);
                VAT_ID[12] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 12, 1);
                VAT_ID[13] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 13, 1);

                var_VATAddress := Rec_WHTBusinessPostingGroup."Address" + Rec_WHTBusinessPostingGroup."Address 2";
                var_CompanyName := Rec_WHTBusinessPostingGroup."Name";
                Month_No["Month No."] := '/';

                TaxReportLine.RESET;
                TaxReportLine.SETFILTER("Tax Type", '%1', "Tax Type");
                TaxReportLine.SETFILTER("Document No.", '%1', "Document No.");

                if DateFilter <> '' then
                    TaxReportLine.SETFILTER("Posting Date", DateFilter);
                IF TaxReportLine.FIND('-') THEN BEGIN
                    REPEAT

                        var_Amount := var_Amount + TaxReportLine."Base Amount";
                        var_WHTAmount := var_WHTAmount + TaxReportLine."VAT Amount";
                        var_WHTTotalAmount := var_WHTTotalAmount + TaxReportLine."VAT Amount";

                    UNTIL TaxReportLine.NEXT = 0;
                END;

                TaxReportLine.RESET;
                TaxReportLine.SETCURRENTKEY("WHT Registration No.");
                TaxReportLine.SETFILTER("Tax Type", '%1', "Tax Type");
                TaxReportLine.SETFILTER("Document No.", '%1', "Document No.");
                if DateFilter <> '' then
                    TaxReportLine.SETFILTER("Posting Date", DateFilter);
                IF TaxReportLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF var_WHTRegisNo = '' THEN BEGIN
                            var_CountVend := var_CountVend + 1;
                        END ELSE BEGIN
                            IF var_WHTRegisNo = TaxReportLine."WHT Registration No." THEN
                                var_CountVend := var_CountVend
                            ELSE
                                var_CountVend := var_CountVend + 1;
                        END;

                        var_WHTNo := TaxReportLine."WHT Document No.";
                        var_WHTRegisNo := TaxReportLine."WHT Registration No.";


                    UNTIL TaxReportLine.NEXT = 0;
                END;

                //##### Option Type ######
                IF Send_Option = Send_Option::"ยื่นปกติ" THEN
                    var_Send_Option[1] := '/'
                ELSE
                    var_Send_Option[2] := '/';

                //##########################################
                IF Send_Type = Send_Type::"3 เตรส" THEN BEGIN
                    var_Send_Type[1] := '/'
                END ELSE
                    IF Send_Type = Send_Type::"65 จัตวา" THEN BEGIN
                        var_Send_Type[2] := '/'
                    END ELSE
                        IF Send_Type = Send_Type::"69 ทวิ" THEN BEGIN
                            var_Send_Type[3] := '/';
                        END;
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
                    field(Send_Type; Send_Type)
                    {
                        Caption = 'นำส่งภาษีตาม';
                        ApplicationArea = all;
                    }
                    field(Send_Option; Send_Option)
                    {
                        Caption = 'ประเภทการยื่น';
                        ApplicationArea = all;
                    }
                    field(Additional_No; Additional_No)
                    {
                        Caption = 'ครั้งที่';
                        ApplicationArea = all;
                    }
                }
            }
        }


    }



    trigger OnPreReport()
    begin

        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    /// <summary> 
    /// Description for SetFilter.
    /// </summary>
    /// <param name="TempWHT">Parameter of type Code[30].</param>
    /// <param name="Tempdate">Parameter of type Text[100].</param>
    procedure "SetFilter"(Tempdate: Text[100])
    begin

        DateFilter := Tempdate;
    end;

    var
        CompanyInformation: Record 79;
        LineNo: Integer;
        YesrPS: Integer;
        StartDateFilter: Date;
        EndDateFilter: Date;
        WHTTypeFilter: Option "ภ.ง.ด. 3","ภ.ง.ด. 53","ภ.ง.ด. 54";
        Rec_WHTBusinessPostingGroup: Record "WHT Business Posting Group";
        WHTProductPostingGroup: Record "WHT Product Posting Group";
        SumBaseLCY: Decimal;
        SumAmountLCY: Decimal;
        TotalBaseLCY: Decimal;
        TotalAmountLCY: Decimal;
        Show_DocumentNo: Boolean;
        WHTProduct: Code[20];
        DocumentNo: Code[20];
        WHTDocumentNo: Code[20];
        Branch: Text[250];
        VAT_ID: array[15] of Text[10];
        var_VATAddress: Text[150];
        Month_No: array[12] of Text[20];
        var_Amount: Decimal;
        var_WHTAmount: Decimal;
        var_WHTTotalAmount: Decimal;
        TaxReportLine: Record "Tax Report Line";
        Send_Type: Option "3 เตรส","65 จัตวา","69 ทวิ";
        Send_Option: Option "ยื่นปกติ","ยื่นเพิ่มเติม";
        Additional_No: Integer;
        var_Send_Type: array[3] of Text;
        var_Send_Option: array[2] of Text;
        var_CountVend: Integer;
        varWHTBussiness: Record "WHT Business Posting Group";
        var_CompanyName: Text[50];
        DateFilter: Text[100];
}

