/// <summary>
/// Table NCT Tax Wht Line (ID 80005).
/// </summary>
table 80005 "NCT Tax & WHT Line"
{
    Caption = 'Tax & WHT Line';
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
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Editable = false;
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(5; "Voucher No."; Code[20])
        {
            Editable = false;
            Caption = 'Voucher No.';
            DataClassification = SystemMetadata;
        }
        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
            DataClassification = SystemMetadata;
        }
        field(7; "Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = SystemMetadata;
        }
        field(8; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = SystemMetadata;
        }
        field(9; "Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = SystemMetadata;
        }
        field(10; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = SystemMetadata;
        }
        field(11; "VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = SystemMetadata;
        }
        field(12; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = SystemMetadata;
        }
        field(13; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(14; "Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = SystemMetadata;
        }
        field(15; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DataClassification = SystemMetadata;
        }
        field(16; "VAT Business Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
            Caption = 'VAT Business Posting Group';
            DataClassification = SystemMetadata;
        }
        field(17; "VAT Product Posting Group"; Code[20])
        {
            Caption = 'VAT Product Posting Group';
            DataClassification = SystemMetadata;
        }
        field(18; "Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = SystemMetadata;
        }
        field(1000; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            DataClassification = SystemMetadata;
        }
        field(1001; "WHT Product Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            DataClassification = SystemMetadata;
        }

        field(1002; "WHT Document No."; Code[20])
        {
            Caption = 'WHT Document No.';
            Description = 'เลขที่หนังสือหัก ณ ที่จ่าย';
            DataClassification = SystemMetadata;
        }
        field(1003; "WHT Sequence No."; Integer)
        {
            Caption = 'ลำดับที่';
            Description = 'ลำดับที่';
            DataClassification = SystemMetadata;
        }
        field(1004; "Name"; Text[160])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(1005; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = SystemMetadata;
        }
        field(1006; "Address"; Text[100])
        {
            Caption = 'Address';
            DataClassification = SystemMetadata;
        }
        field(1007; "Address 2"; Text[100])
        {
            Caption = 'Address 2';
            DataClassification = SystemMetadata;
        }
        field(1008; "City"; Text[50])
        {
            Caption = 'City';
            DataClassification = SystemMetadata;
        }
        field(1009; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
            DataClassification = SystemMetadata;
        }
        field(1010; "County"; Text[30])
        {
            Caption = 'County';
            DataClassification = SystemMetadata;
        }
        field(1011; "WHT Registration No."; Text[20])
        {
            Caption = 'WHT Registration No.';
            DataClassification = SystemMetadata;
        }
        field(1012; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = SystemMetadata;
        }
        field(1016; "Ref. Entry No."; Integer)
        {
            Caption = 'Ref. Entry No.';
            DataClassification = SystemMetadata;
        }
        field(1017; "Cust. Amount"; Decimal)
        {
            Caption = 'Cust. Amount';
            DataClassification = SystemMetadata;
        }

        field(1019; "Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
            DataClassification = SystemMetadata;
        }

        field(1021; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."no.";
            DataClassification = CustomerContent;
        }
        field(1022; "Send to Report"; Boolean)
        {
            Caption = 'Send to Report';
            DataClassification = CustomerContent;
        }
        field(1023; "Ref. Wht Line"; Integer)
        {
            Caption = 'Ref. Wht Line';
            DataClassification = SystemMetadata;
        }
        field(1024; "WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = SystemMetadata;
        }
        field(1025; "WHT Certificate No."; Code[20])
        {
            Caption = 'WHT Certificate No.';
            DataClassification = SystemMetadata;
        }
        field(1026; "Title Name"; text[50])
        {
            Caption = 'คำนำหน้า';
            DataClassification = CustomerContent;
        }
        field(1027; "Building"; Text[100])
        {
            Caption = 'ชื่ออาคาร/หมู่บ้าน';
            DataClassification = CustomerContent;
        }
        field(1028; "Alley/Lane"; Text[100])
        {
            Caption = 'ตรอก/ซอย';
            DataClassification = CustomerContent;
        }
        field(1029; "Sub-district"; Text[100])
        {
            Caption = 'ตำบล/แขวง';
            DataClassification = CustomerContent;
        }
        field(1030; "District"; Text[100])
        {
            Caption = 'อำเภอ/เขต';
            DataClassification = CustomerContent;
        }
        field(1031; "Floor"; Text[10])
        {
            Caption = 'ชั้น';
            DataClassification = CustomerContent;
        }
        field(1032; "House No."; Text[50])
        {
            Caption = 'เลขที่ห้อง';
            DataClassification = CustomerContent;
        }
        field(1033; "Village No."; Text[15])
        {
            Caption = 'หมู่ที่';
            DataClassification = CustomerContent;
        }
        field(1034; "Street"; Text[50])
        {
            Caption = 'ถนน';
            DataClassification = CustomerContent;
        }
        field(1035; "Province"; Text[50])
        {
            Caption = 'จังหวัด';
            DataClassification = CustomerContent;
        }
        field(1036; "No."; Text[50])
        {
            Caption = 'เลขที่';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Tax Type", "Document No.", "Entry No.")
        {
        }
        key(Key2; "Tax Type", "Document No.", "Voucher No.", "Posting Date")
        {
        }
        key(Key3; "Tax Type", "Document No.", "Posting Date")
        {
        }
    }


    trigger OnDelete()
    var
        Vattransection: Record "NCT VAT Transections";
        TaxVatHeader: Record "NCT Tax & WHT Header";
    begin
        TaxVatHeader.GET("Tax Type", "Document No.");
        TaxVatHeader.TestField(Status, TaxVatHeader.Status::Open);
        Vattransection.reset();
        Vattransection.SetRange("Ref. Tax Type", "Tax Type");
        Vattransection.SetRange("Ref. Tax No.", "Document No.");
        Vattransection.SetRange("Ref. Tax Line No.", "Entry No.");
        if Vattransection.FindSet() then
            repeat
                Vattransection."Get to Tax" := false;
                Vattransection."Ref. Tax Line No." := 0;
                Vattransection."Ref. Tax No." := '';
                Vattransection.Modify();
            until Vattransection.Next() = 0;

    end;

    var
        WHTHeader: Record "NCT WHT Header";

    /// <summary> 
    /// Description for Navigate.
    /// </summary>
    procedure "Navigate"()
    var
        NavigateForm: Page 344;
    begin
        NavigateForm.SetDoc("Posting Date", "Voucher No.");
        NavigateForm.RUN();
    end;

    /// <summary> 
    /// Description for GetVatData.
    /// </summary>
    procedure "GetVatData"()
    var
        VatTransection: Record "NCT VAT Transections";
        TaxReportHeader: Record "NCT Tax & WHT Header";
        TaxReportLine: Record "NCT Tax & WHT Line";
        VATProdPostingGroup: Record "VAT Product Posting Group";
        var_Skip: Boolean;
        varPostingSsetup: Record "VAT Posting Setup";
        VendorLedger: Record "Vendor Ledger Entry";
        VendorDetail: Record "Detailed Vendor Ledg. Entry";
        VatAmt, VatBase : Decimal;
        TaxInvoiceNo: Code[35];
        TaxINvoiceLine: Integer;
    begin

        TaxReportHeader.get("Tax Type", "Document No.");
        TaxReportHeader.TestField(Status, TaxReportHeader.Status::Open);
        TaxReportHeader.TestField("End date of Month");
        VatTransection.reset();
        VatTransection.SetRange("Type", "Tax Type".AsInteger() + 1);
        VatTransection.SetFilter("Posting Date", '%1..%2', DMY2Date(01, TaxReportHeader."Month No.", TaxReportHeader."Year No."), CalcDate('<CM>', TaxReportHeader."End date of Month"));
        if "Tax Type" = "Tax Type"::Purchase then
            VatTransection.SetRange("Allow Generate to Purch. Vat", true)
        else
            VatTransection.SetRange("Allow Generate to Sale Vat", true);
        VatTransection.SetFilter("Ref. Tax No.", '%1', '');
        OnAftersetfilterVatTransaction(VatTransection, TaxReportHeader);
        if VatTransection.FindSet() then
            repeat
                var_Skip := false;
                if not VATProdPostingGroup.Get(VatTransection."VAT Prod. Posting Group") then
                    VATProdPostingGroup.init();
                if not varPostingSsetup.GET(VatTransection."VAT Bus. Posting Group", VatTransection."VAT Prod. Posting Group") then
                    varPostingSsetup.Init();
                VatTransection.CalcFields("Unrealized VAT Type");
                VatAmt := ABS(VatTransection."Amount");
                VatBase := ABS(VatTransection.Base);

                if VatTransection."Document Type" = VatTransection."Document Type"::"Credit Memo" then begin
                    VatAmt := ABS(VatTransection."Amount") * -1;
                    VatBase := ABS(VatTransection.Base) * -1;
                end;
                if VatTransection."Document Type" <> VatTransection."Document Type"::Payment then
                    if VatTransection."Type" = VatTransection."Type"::Purchase then
                        if varPostingSsetup."Unrealized VAT Type" = varPostingSsetup."Unrealized VAT Type"::Percentage then begin
                            VendorLedger.reset();
                            VendorLedger.SetRange("Document No.", VatTransection."Document No.");
                            if VendorLedger.FindFirst() then begin
                                VendorDetail.reset();
                                VendorDetail.SetRange("Vendor Ledger Entry No.", VendorLedger."Entry No.");
                                VendorDetail.SetRange("Document Type", VendorDetail."Document Type"::Payment);
                                if not VendorDetail.IsEmpty then
                                    var_Skip := true;
                            end else
                                if (VatTransection."Remaining Unrealized Base" <> 0) OR (VatTransection."Remaining Unrealized Amt." <> 0) then
                                    var_Skip := true;
                        end;

                IF VATProdPostingGroup."NCT Direct VAT" THEN
                    IF (VatTransection."Tax Invoice Base" = 0) THEN
                        var_Skip := TRUE;


                TaxINvoiceLine := 0;
                TaxInvoiceNo := '';
                if VatTransection.Type = VatTransection.Type::Sale then
                    TaxInvoiceNo := VatTransection."Document No."
                else
                    if VatTransection."Tax Invoice No." <> '' then
                        TaxInvoiceNo := VatTransection."Tax Invoice No."
                    else
                        TaxInvoiceNo := VatTransection."External Document No.";


                if not var_Skip then begin
                    TaxReportLine.RESET();
                    TaxReportLine.SetRange("Tax Type", "Tax Type");
                    TaxReportLine.SetRange("Voucher No.", VatTransection."Document No.");
                    TaxReportLine.SetRange("Tax Invoice No.", TaxInvoiceNo);
                    OnAftersetfilterVatLine(TaxReportLine, VatTransection);
                    if not TaxReportLine.FindFirst() then begin
                        TaxReportLine.INIT();
                        TaxReportLine."Tax Type" := "Tax Type";
                        TaxReportLine."Document No." := "Document No.";
                        TaxReportLine."Entry No." := GetLastLineNo();
                        TaxReportLine."Posting Date" := VatTransection."Posting Date";
                        TaxReportLine."Voucher No." := VatTransection."Document No.";
                        TaxReportLine."VAT Business Posting Group" := VatTransection."VAT Bus. Posting Group";
                        TaxReportLine."VAT Product Posting Group" := VatTransection."VAT Prod. Posting Group";
                        TaxReportLine."Head Office" := VatTransection."Head Office";
                        TaxReportLine."VAT Branch Code" := VatTransection."VAT Branch Code";
                        TaxReportLine."VAT Registration No." := VatTransection."VAT Registration No.";
                        TaxReportLine."Description" := VatTransection."Description Line";
                        TaxReportLine."Tax Invoice Name" := VatTransection."Tax Invoice Name";
                        TaxReportLine."Tax Invoice Name 2" := VatTransection."Tax Invoice Name 2";
                        TaxReportLine."Tax Invoice Date" := VatTransection."Tax Invoice Date";
                        TaxReportLine."Tax Invoice No." := TaxInvoiceNo;
                        if VatTransection."Tax Invoice No." <> '' then begin

                            TaxReportLine."Tax Invoice No." := VatTransection."Tax Invoice No.";
                            if ABS(VatTransection."Tax Invoice Base") <> 0 then begin
                                TaxReportLine."Base Amount" := ABS(VatTransection."Tax Invoice Base");
                                TaxReportLine."VAT Amount" := ABS(VatTransection."Tax Invoice Amount");
                            end else begin
                                TaxReportLine."Base Amount" := VatBase;
                                TaxReportLine."VAT Amount" := VatAmt;
                            end;
                        end else begin
                            TaxReportLine."Base Amount" := VatBase;
                            TaxReportLine."VAT Amount" := VatAmt;
                        end;
                        if VatTransection.Type = VatTransection.Type::Sale then
                            TaxReportLine."Customer No." := VatTransection."Bill-to/Pay-to No."
                        else
                            TaxReportLine."Vendor No." := VatTransection."Bill-to/Pay-to No.";
                        TaxReportLine."Send to Report" := true;
                        TaxReportLine."Ref. Entry No." := VatTransection."Entry No.";

                        if VatTransection."Document Type" = VatTransection."Document Type"::Invoice then begin
                            TaxReportLine."Base Amount" := ABS(TaxReportLine."Base Amount");
                            TaxReportLine."VAT Amount" := ABS(TaxReportLine."VAT Amount");
                        end;
                        if VatTransection."Document Type" = VatTransection."Document Type"::"Credit Memo" then begin
                            TaxReportLine."Base Amount" := -ABS(TaxReportLine."Base Amount");
                            TaxReportLine."VAT Amount" := -ABS(TaxReportLine."VAT Amount");
                        end;

                        TaxReportLine."Cust. Amount" := TaxReportLine."Base Amount" + TaxReportLine."VAT Amount";
                        OnBeforeInsertVatLine(TaxReportLine, VatTransection);
                        TaxReportLine.Insert();
                        TaxINvoiceLine := TaxReportLine."Entry No.";
                    end else begin
                        TaxINvoiceLine := TaxReportLine."Entry No.";
                        if VatTransection."Unrealized VAT Type" = VatTransection."Unrealized VAT Type"::Percentage then begin
                            TaxReportLine."Base Amount" += ABS(VatTransection."Remaining Unrealized Base");
                            TaxReportLine."VAT Amount" += ABS(VatTransection."Remaining Unrealized Amt.");
                        end else
                            if VatTransection."Tax Invoice No." <> '' then begin
                                if ABS(VatTransection."Tax Invoice Base") <> 0 then begin
                                    TaxReportLine."Base Amount" += ABS(VatTransection."Tax Invoice Base");
                                    TaxReportLine."VAT Amount" += ABS(VatTransection."Tax Invoice Amount");
                                end else begin
                                    TaxReportLine."Base Amount" += VatBase;
                                    TaxReportLine."VAT Amount" += VatAmt;
                                end;
                            end else begin
                                TaxReportLine."Tax Invoice No." += VatTransection."External Document No.";
                                TaxReportLine."Base Amount" += VatBase;
                                TaxReportLine."VAT Amount" += VatAmt;
                            end;

                        if VatTransection."Document Type" = VatTransection."Document Type"::Invoice then begin
                            TaxReportLine."Base Amount" := ABS(TaxReportLine."Base Amount");
                            TaxReportLine."VAT Amount" := ABS(TaxReportLine."VAT Amount");
                        end;
                        if VatTransection."Document Type" = VatTransection."Document Type"::"Credit Memo" then begin
                            TaxReportLine."Base Amount" := -ABS(TaxReportLine."Base Amount");
                            TaxReportLine."VAT Amount" := -ABS(TaxReportLine."VAT Amount");
                        end;

                        TaxReportLine."Cust. Amount" := TaxReportLine."Base Amount" + TaxReportLine."VAT Amount";
                        TaxReportLine.Modify();
                    end;
                    VatTransection."Ref. Tax Type" := "Tax Type";
                    VatTransection."Ref. Tax No." := "Document No.";
                    VatTransection."Ref. Tax Line No." := TaxINvoiceLine;
                    VatTransection."Get to Tax" := true;
                    VatTransection.Modify();
                end;

            until VatTransection.next() = 0;
    end;
    /// <summary> 
    /// Description for Get WHTData.
    /// </summary>
    /// <param name="pISWHT53">Boolean.</param>
    procedure "Get WHTData"(pISWHT53: Boolean)
    var
        TaxReportHeader: Record "NCT Tax & WHT Header";
        TaxReportLineFind: Record "NCT Tax & WHT Line";
        WHTLine: Record "NCT WHT Line";
        WHTBusPotingGroup: Record "NCT WHT Business Posting Group";
        WHTCode: Text;
    begin
        WHTCode := '';
        TaxReportHeader.get("Tax Type", "Document No.");
        TaxReportHeader.TestField(Status, TaxReportHeader.Status::Open);
        TaxReportHeader.TestField("End date of Month");
        WHTBusPotingGroup.reset();
        if not pISWHT53 then
            WHTBusPotingGroup.SetRange("WHT Certificate Option", WHTBusPotingGroup."WHT Certificate Option"::"ภ.ง.ด.3")
        else
            WHTBusPotingGroup.SetRange("WHT Certificate Option", WHTBusPotingGroup."WHT Certificate Option"::"ภ.ง.ด.53");
        if WHTBusPotingGroup.FindSet() then
            repeat
                if WHTCode <> '' then
                    WHTCode := WHTCode + '|';
                WHTCode := WHTCode + WHTBusPotingGroup.Code;
            until WHTBusPotingGroup.next() = 0;

        WHTHeader.RESET();
        WHTHeader.SETFILTER("WHT Date", '%1..%2', DMY2Date(01, TaxReportHeader."Month No.", TaxReportHeader."Year No."), CalcDate('<CM>', TaxReportHeader."End date of Month"));
        WHTHeader.SETFILTER("WHT No.", '<>%1', '');
        WHTHeader.SetFilter("WHT Business Posting Group", WHTCode);
        WHTHeader.SetRange("Posted", true);
        WHTHeader.SETRANGE("Get to WHT", false);
        OnAftersetfilterWHT(WHTHeader, TaxReportHeader);
        IF WHTHeader.FindFirst() THEN
            repeat
                WHTLine.reset();
                WHTLine.SetRange("WHT No.", WHTHeader."WHT No.");
                WHTLine.SetRange("Get to WHT", false);
                OnAftersetfilterWHTLine(WHTLine, WHTHeader, TaxReportHeader);
                if WHTLine.FindFirst() then
                    repeat
                        TaxReportLineFind.INIT();
                        TaxReportLineFind."Tax Type" := "Tax Type";
                        TaxReportLineFind."Document No." := "Document No.";
                        TaxReportLineFind."Entry No." := GetLastLineNo();
                        TaxReportLineFind."Posting Date" := WHTHeader."WHT Date";

                        TaxReportLineFind."Voucher No." := WHTHeader."Gen. Journal Document No.";
                        TaxReportLineFind."Vendor No." := WHTHeader."WHT Source No.";

                        TaxReportLineFind."Base Amount" := WHTLine."WHT Base";
                        TaxReportLineFind."VAT Amount" := WHTLine."WHT Amount";
                        TaxReportLineFind."WHT Business Posting Group" := WHTHeader."WHT Business Posting Group";
                        TaxReportLineFind."WHT Product Posting Group" := WHTLine."WHT Product Posting Group";
                        TaxReportLineFind."WHT Document No." := WHTHeader."WHT No.";
                        TaxReportLineFind."Name" := WHTHeader."WHT Name";
                        TaxReportLineFind."Name 2" := WHTHeader."WHT Name 2";
                        TaxReportLineFind."Address" := WHTHeader."WHT Address";
                        TaxReportLineFind."Address 2" := WHTHeader."WHT Address 2";

                        TaxReportLineFind."WHT Registration No." := WHTHeader."VAT Registration No.";
                        TaxReportLineFind."WHT %" := WHTLine."WHT %";
                        TaxReportLineFind."Head Office" := WHTHeader."Head Office";
                        TaxReportLineFind."VAT Branch Code" := WHTHeader."VAT Branch Code";
                        TaxReportLineFind."VAT Registration No." := WHTHeader."VAT Registration No.";
                        TaxReportLineFind."Ref. Wht Line" := WHTLine."WHT Line No.";
                        TaxReportLineFind."WHT Certificate No." := WHTHeader."WHT Certificate No.";

                        TaxReportLineFind."Alley/Lane" := WHTHeader."WHT Alley/Lane";
                        TaxReportLineFind."Title Name" := WHTHeader."WHT Title Name";
                        TaxReportLineFind.Province := WHTHeader."WHT Province";
                        TaxReportLineFind.Floor := WHTHeader."WHT Floor";
                        TaxReportLineFind.Building := WHTHeader."WHT Building";
                        TaxReportLineFind."Sub-district" := WHTHeader."WHT Sub-district";
                        TaxReportLineFind."House No." := WHTHeader."WHT House No.";
                        TaxReportLineFind.Street := WHTHeader."WHT Street";
                        TaxReportLineFind.District := WHTHeader."WHT District";
                        TaxReportLineFind."Village No." := WHTHeader."WHT Village No.";
                        TaxReportLineFind."No." := WHTHeader."WHT No.";
                        TaxReportLineFind."City" := WHTHeader."WHT City";
                        TaxReportLineFind."Post Code" := WHTHeader."WHT Post Code";

                        if (NOT TaxReportLineFind."Head Office") AND (TaxReportLineFind."VAT Branch Code" = '') then
                            TaxReportLineFind."Head Office" := true;

                        OnbeforInsertWHTLine(TaxReportLineFind, WHTHeader, WHTLine);
                        TaxReportLineFind.INSERT();
                        WHTLine."Get to WHT" := true;
                        WHTLine.Modify();
                    UNTIL WHTLine.NEXT() = 0;

                WHTHeader."Get to WHT" := true;
                WHTHeader.Modify();
            until WHTHeader.next() = 0
        else
            Message('Nothing to generate');
    end;

    /// <summary> 
    /// Description for GetLastLineNo.
    /// </summary>
    /// <returns>Return variable "Integer".</returns>
    procedure GetLastLineNo(): Integer
    var
        TaxReportLine: Record "NCT Tax & WHT Line";
    begin
        TaxReportLine.reset();
        TaxReportLine.SetCurrentKey("Tax Type", "Document No.", "Entry No.");
        TaxReportLine.SetRange("Tax Type", "Tax Type");
        TaxReportLine.SetRange("Document No.", "Document No.");
        if TaxReportLine.FindLast() then
            exit(TaxReportLine."Entry No." + 1);
        exit(1);
    end;

    [IntegrationEvent(true, false)]

    procedure OnBeforeInsertVatLine(var TaxReportLine: Record "NCT Tax & WHT Line"; VatTransaction: Record "NCT VAT Transections")
    begin

    end;

    [IntegrationEvent(true, false)]

    procedure OnAftersetfilterVatLine(var TaxReportLine: Record "NCT Tax & WHT Line"; VatTransaction: Record "NCT VAT Transections")
    begin

    end;


    [IntegrationEvent(true, false)]

    procedure OnAftersetfilterVatTransaction(var VatTransaction: Record "NCT VAT Transections"; TaxWHT: Record "NCT Tax & WHT Header")
    begin

    end;


    [IntegrationEvent(true, false)]

    procedure OnAftersetfilterWHT(var WHTHeader: Record "NCT WHT Header"; TaxWHT: Record "NCT Tax & WHT Header")
    begin

    end;

    [IntegrationEvent(true, false)]

    procedure OnAftersetfilterWHTLine(var WHTLine: Record "NCT WHT Line"; WHTHeader: Record "NCT WHT Header"; TaxWHT: Record "NCT Tax & WHT Header")
    begin

    end;


    [IntegrationEvent(true, false)]
    procedure OnbeforInsertWHTLine(var TaxWHTLine: Record "NCT Tax & WHT Line"; WHTHeader: Record "NCT WHT Header"; WHTLine: Record "NCT WHT Line")
    begin

    end;


}

