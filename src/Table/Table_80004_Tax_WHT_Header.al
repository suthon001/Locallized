/// <summary>
/// Table NCT Tax WHT Header (ID 80004).
/// </summary>
table 80004 "NCT Tax & WHT Header"
{
    Caption = 'Tax & WHT Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Tax Type"; Enum "NCT Tax Type")
        {
            Editable = false;
            Caption = 'Tax Type';
            DataClassification = SystemMetadata;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if rec."Document No." <> xRec."Document No." then begin
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "End date of Month"; Date)
        {
            Caption = 'End date of Month';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                FunctionCenter: Codeunit "NCT Function Center";
            begin
                rec.TestField(Status, rec.Status::Open);
                "Month No." := DATE2DMY("End date of Month", 2);
                "Month Name" := FunctionCenter."Get ThaiMonth"("Month No.");
                "Year No." := DATE2DMY("End date of Month", 3);
                "Year-Month" := format("End date of Month", 0, '<Year4>-<Month,2>');
            end;
        }
        field(4; "Year-Month"; Code[7])
        {
            Caption = 'Year-Month';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(5; "Month No."; Integer)
        {
            Caption = 'Month No';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(6; "Month Name"; Text[50])
        {
            Editable = false;
            Caption = 'Month Name';
            DataClassification = SystemMetadata;
        }
        field(7; "Year No."; Integer)
        {
            Caption = 'Year No';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(8; "Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released';
            OptionMembers = "Open","Released";
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(9; "Total Base Amount"; Decimal)
        {
            CalcFormula = Sum("NCT Tax & WHT Line"."Base Amount" WHERE("Tax Type" = FIELD("Tax Type"),
                                                                     "Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Base Amount';
        }
        field(10; "Total VAT Amount"; Decimal)
        {
            CalcFormula = Sum("NCT Tax & WHT Line"."VAT Amount" WHERE("Tax Type" = FIELD("Tax Type"),
                                                                    "Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total VAT Amount';
        }
        field(11; "Create By"; Code[50])
        {
            Editable = false;
            Caption = 'Create By';
            DataClassification = SystemMetadata;
        }
        field(12; "Create DateTime"; DateTime)
        {
            Editable = false;
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
        }
        field(13; "Vat Option"; Option)
        {
            Caption = 'Vat Option';
            OptionMembers = " ",Additional;
            OptionCaption = ' ,Additional';
            DataClassification = CustomerContent;
        }
        field(14; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = SystemMetadata;
        }
        field(15; "Vat Bus. Post. Filter"; Code[100])
        {
            Caption = 'Vat Bus. PostingGroup Filter';
            TableRelation = "VAT Business Posting Group".Code;
            FieldClass = FlowFilter;
        }
        field(16; "WHT Bus. Post. Filter"; Code[100])
        {
            Caption = 'Vat Bus. PostingGroup Filter';
            TableRelation = "NCT WHT Business Posting Group";
            FieldClass = FlowFilter;
        }
        field(17; "Date Filter"; text[100])
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
            trigger OnValidate()
            var
                ApplicationManagement: Codeunit "Filter Tokens";
                GLAcc: Record "G/L Account";
                ltDateFilter: Text;
            begin
                ltDateFilter := rec."Date Filter";
                ApplicationManagement.MakeDateFilter(ltDateFilter);
                GLAcc.SETFILTER("Date Filter", ltDateFilter);
                "Date Filter" := COPYSTR(GLAcc.GETFILTER("Date Filter"), 1, 100);
            end;
        }
    }

    keys
    {
        key(Key1; "Tax Type", "Document No.")
        {
            Clustered = true;
        }
        key(key2; "Tax Type", "Month No.")
        {

        }
        key(key3; "Tax Type", "Year No.", "Month No.")
        {

        }
        key(key4; "Tax Type", "Year-Month")
        {

        }



    }

    trigger OnDelete()
    begin
        rec.TestField(Status, Status::Open);
        TaxReportLine.RESET();
        TaxReportLine.SETRANGE("Tax Type", "Tax Type");
        TaxReportLine.SETRANGE("Document No.", "Document No.");
        IF TaxReportLine.FindFirst() THEN
            TaxReportLine.DELETEALL(TRUE);
    end;

    trigger OnRename()
    begin
        ERROR('Can not Rename!');
    end;

    trigger OnInsert()
    begin
        TestField("Document No.");
        "Create By" := COPYSTR(UserId(), 1, 50);
        "Create DateTime" := CurrentDateTime;
    end;


    /// <summary> 
    /// Description for GetNoSeriesCode.
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    local procedure "GetNoSeriesCode"(): Code[20]
    var
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.get();
        SalesSetup.get();
        CASE "Tax Type" OF
            "Tax Type"::Sale:
                begin
                    SalesSetup.TestField("NCT Sales VAT Nos.");
                    EXIT(SalesSetup."NCT Sales VAT Nos.");
                end;
            "Tax Type"::Purchase:
                begin
                    PurchSetup.TestField("NCT Purchase VAT Nos.");
                    EXIT(PurchSetup."NCT Purchase VAT Nos.");
                end;
            "Tax Type"::WHT03:
                begin
                    PurchSetup.TestField("NCT WHT03 Nos.");
                    EXIT(PurchSetup."NCT WHT03 Nos.");
                end;
            "Tax Type"::WHT53:
                begin
                    PurchSetup.TestField("NCT WHT53 Nos.");
                    EXIT(PurchSetup."NCT WHT53 Nos.");
                end;
        END;
    end;
    /// <summary> 
    /// Description for ExportPND.
    /// </summary>
    procedure ExportPND()
    var
        TaxReportHeader: Record "NCT Tax & WHT Header";
        WHTBusinessPostingGroup: Record "NCT WHT Business Posting Group";
        WHTProductPortingGroup: Record "NCT WHT Product Posting Group";
        FunctionCenter: Codeunit "NCT Function Center";
        ltGrouppingWHTLine: Query "NCT Groupping WHT Transaction";
        Instrm: InStream;
        OutStrm: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        TempTaxt: Text;
        LineNo, ltLineCheckRec, ltLoopLine : Integer;
        ltFileNameLbl: Label '%1_%2%3', Locked = true;
        BranchCode: Code[5];
        BranchData: array[13] of text;
    begin
        LineNo := 0;
        ltLineCheckRec := 0;
        TaxReportHeader.get(Rec."Tax Type", Rec."Document No.");
        WHTBusinessPostingGroup.Get(format(rec."Tax Type"));
        FileName := StrSubstNo(ltFileNameLbl, TaxReportHeader."End date of Month", WHTBusinessPostingGroup."Code", '.txt');
        TempBlob.CreateOutStream(OutStrm, TextEncoding::UTF8);
        CLEAR(ltGrouppingWHTLine);
        ltGrouppingWHTLine.SetRange(TaxType, TaxReportHeader."Tax Type");
        ltGrouppingWHTLine.SetRange(DocumentNo, TaxReportHeader."Document No.");
        ltGrouppingWHTLine.Open();
        while ltGrouppingWHTLine.Read() do begin
            Clear(TempTaxt);
            CLEAR(ltLineCheckRec);
            LineNo := LineNo + 1;
            TaxReportLine.reset();
            TaxReportLine.SetRange("Tax Type", TaxReportHeader."Tax Type");
            TaxReportLine.SetRange("Document No.", TaxReportHeader."Document No.");
            TaxReportLine.SetRange("WHT Certificate No.", ltGrouppingWHTLine.WHTCertificateNo);
            if TaxReportLine.FindSet() then begin
                repeat
                    ltLineCheckRec := ltLineCheckRec + 1;
                    if TaxReportLine."Head Office" then
                        BranchCode := '00000'
                    else
                        BranchCode := TaxReportLine."VAT Branch Code";
                    if BranchCode = '' then
                        BranchCode := '-';

                    BranchData[1] := format(TaxReportLine."Title Name");
                    if BranchData[1] = '' then
                        BranchData[1] := '-';
                    BranchData[2] := TaxReportLine."Name";
                    BranchData[3] := TaxReportLine."Building";
                    BranchData[4] := TaxReportLine."House No.";
                    BranchData[5] := TaxReportLine."Floor";
                    BranchData[6] := TaxReportLine."No.";
                    BranchData[7] := TaxReportLine."Village No.";
                    BranchData[8] := TaxReportLine."Alley/Lane";
                    BranchData[9] := TaxReportLine."Street";
                    BranchData[10] := TaxReportLine."Sub-district";
                    BranchData[11] := TaxReportLine."District";
                    BranchData[12] := TaxReportLine."Province";
                    BranchData[13] := TaxReportLine."post Code";


                    IF NOT WHTProductPortingGroup.Get(TaxReportLine."WHT Product Posting Group") then
                        WHTProductPortingGroup.init();

                    if ltLineCheckRec = 1 then begin
                        if (WHTBusinessPostingGroup."WHT Certificate Option" = WHTBusinessPostingGroup."WHT Certificate Option"::"ภ.ง.ด.3") then
                            TempTaxt := FORMAT(LineNo) + '|' + FORMAT(DelChr(TaxReportLine."VAT Registration No.", '=', '-')) + '|' +
                                        BranchCode + '|' + BranchData[1] + '|' + FORMAT(BranchData[2]) + '|' + '|' + FORMAT(BranchData[3]) + '|' +
                                        FORMAT(BranchData[4]) + '|' + FORMAT(BranchData[5]) + '|' + FORMAT(BranchData[6]) + '|' + FORMAT(BranchData[7]) + '|' +
                                        FORMAT(BranchData[8]) + '|' + FORMAT(BranchData[9]) + '|' + FORMAT(BranchData[10]) + '|' + FORMAT(BranchData[11]) + '|' +
                                        FORMAT(BranchData[12]) + '|' + FORMAT(BranchData[13]) + '|' +
                                        FORMAT(TaxReportLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '|' + FORMAT(WHTProductPortingGroup."Description") + '|' +
                                        DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."WHT %"), '=', ',') + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."Base Amount"), '=', ',')
                                        + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."VAT Amount"), '=', ',') + '|' + FORMAT(1)
                        else
                            if (WHTBusinessPostingGroup."WHT Certificate Option" = WHTBusinessPostingGroup."WHT Certificate Option"::"ภ.ง.ด.53") then
                                TempTaxt := FORMAT(LineNo) + '|' + FORMAT(DelChr(TaxReportLine."VAT Registration No.", '=', '-')) + '|' +
                                      BranchCode + '|' + BranchData[1] + '|' + FORMAT(BranchData[2]) + '|' + FORMAT(BranchData[3]) + '|' +
                                      FORMAT(BranchData[4]) + '|' + FORMAT(BranchData[5]) + '|' + FORMAT(BranchData[6]) + '|' + FORMAT(BranchData[7]) + '|' +
                                      FORMAT(BranchData[8]) + '|' + FORMAT(BranchData[9]) + '|' + FORMAT(BranchData[10]) + '|' + FORMAT(BranchData[11]) + '|' +
                                      FORMAT(BranchData[12]) + '|' + FORMAT(BranchData[13]) + '|' +
                                      FORMAT(TaxReportLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '|' + FORMAT(WHTProductPortingGroup."Description") + '|' +
                                      DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."WHT %"), '=', ',') + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."Base Amount"), '=', ',')
                                      + '|' + DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."VAT Amount"), '=', ',') + '|' + FORMAT(1);
                    end else
                        TempTaxt := TempTaxt + '|' + FORMAT(TaxReportLine."WHT Date", 0, '<Day,2>/<Month,2>/<Year4>') + '|' + FORMAT(WHTProductPortingGroup."Description") + '|' +
                                                              DELCHR(FunctionCenter."ConverseDecimalToText"(TaxReportLine."WHT %"), '=', ',') + '|' + DELCHR(FORMAT(TaxReportLine."Base Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',')
                                                              + '|' + DELCHR(FORMAT(TaxReportLine."VAT Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',') + '|' + FORMAT(1);

                Until TaxReportLine.Next() = 0;
                for ltLoopLine := 1 to 3 - ltLineCheckRec do
                    TempTaxt := TempTaxt + '||||||';
            end;
            OutStrm.WriteText(TempTaxt);
            OutStrm.WriteText();
            TempTaxt := '';
        end;
        TempBlob.CreateInStream(Instrm, TextEncoding::UTF8);
        DownloadFromStream(Instrm, 'Export', '', '*.txt|(*.txt)', FileName);
    end;

    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldVatHeader">Parameter of type Record "NCT Tax WHT Header".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure AssistEdit(OldVatHeader: Record "NCT Tax & WHT Header"): Boolean
    var
        VatHeader: Record "NCT Tax & WHT Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        VatHeader.COPY(Rec);
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldVatHeader."No. Series",
          VatHeader."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(VatHeader."Document No.");
            Rec := VatHeader;
            EXIT(TRUE);
        END;
    end;

    var
        TaxReportLine: Record "NCT Tax & WHT Line";
}

