/// <summary>
/// Table Tax Report Line (ID 50005).
/// </summary>
table 50005 "Tax Report Line"
{
    Caption = 'Tax Report Line';

    fields
    {
        field(1; "Tax Type"; Enum "Tax Type")
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
        field(9; "Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = SystemMetadata;
        }
        field(10; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = SystemMetadata;
        }
        field(11; "Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
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
        field(1004; "Name"; Text[100])
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
        field(1007; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = SystemMetadata;
        }
        field(1008; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = SystemMetadata;
        }
        field(1009; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
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
        field(1013; "Base Amount VAT7"; Decimal)
        {
            Caption = 'Base Amount VAT7';
            DataClassification = SystemMetadata;
        }
        field(1014; "Base Amount VAT0"; Decimal)
        {
            Caption = 'Base Amount VAT0';
            DataClassification = SystemMetadata;
        }
        field(1015; "Consession Fee"; Decimal)
        {
            Caption = 'Consession Fee';
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
        field(1018; "Cust. Amt. Pus Concession"; Decimal)
        {
            Caption = 'Cust. Amount Pus Concession';
            DataClassification = SystemMetadata;
        }
        field(1019; "Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
            DataClassification = SystemMetadata;
        }
        field(1020; "Check Status"; Option)
        {
            Caption = 'Check Status';
            OptionCaption = ' ,Checked,Reconcile,Mark';
            OptionMembers = " ",Checked,Reconcile,Mark;
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
        Vattransection: Record "VAT Transections";
    begin

        Vattransection.reset();
        Vattransection.SetRange("Ref. Tax Type", "Tax Type");
        Vattransection.SetRange("Ref. Tax No.", "Document No.");
        Vattransection.SetRange("Ref. Tax Line No.", "Entry No.");
        if Vattransection.FindSet() then begin
            Vattransection.ModifyAll("Get to Tax", false);
            Vattransection.ModifyAll("Ref. Tax Line No.", 0);
            Vattransection.ModifyAll("Ref. Tax No.", '');
        end;
    end;

    var
        WHTHeader: Record "WHT Header";

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
        VatTransection: Record "VAT Transections";
        TaxReportHeader: Record "Tax Report Header";
        TaxReportLine: Record "Tax Report Line";
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
        TaxReportHeader.TestField("End date of Month");
        VatTransection.reset();
        VatTransection.SetRange("Type", "Tax Type".AsInteger() + 1);
        VatTransection.SetFilter("Posting Date", '%1..%2', DMY2Date(01, TaxReportHeader."Month No.", TaxReportHeader."Year No."), CalcDate('<CM>', TaxReportHeader."End date of Month"));
        if "Tax Type" = "Tax Type"::Purchase then
            VatTransection.SetRange("Allow Generate to Purch. Vat", true)
        else
            VatTransection.SetRange("Allow Generate to Sale Vat", true);
        VatTransection.SetFilter("Ref. Tax No.", '<>%1', '');
        if VatTransection.FindSet() then
            repeat
                var_Skip := false;
                if not VATProdPostingGroup.Get(VatTransection."VAT Prod. Posting Group") then
                    VATProdPostingGroup.init();
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
                            end;
                        end;

                IF VATProdPostingGroup."Direct VAT" THEN
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
                        TaxReportLine."Branch Code" := VatTransection."Branch Code";
                        TaxReportLine."VAT Registration No." := VatTransection."VAT Registration No.";
                        TaxReportLine."Description" := VatTransection."Description Line";
                        TaxReportLine."Tax Invoice Name" := VatTransection."Tax Invoice Name";
                        TaxReportLine."Tax Invoice Name 2" := VatTransection."Tax Invoice Name 2";
                        TaxReportLine."Tax Invoice Date" := VatTransection."Tax Invoice Date";
                        TaxReportLine."Tax Invoice No." := TaxInvoiceNo;
                        if VatTransection."Unrealized VAT Type" = VatTransection."Unrealized VAT Type"::Percentage then begin
                            TaxReportLine."Base Amount" := ABS(VatTransection."Remaining Unrealized Base");
                            TaxReportLine."VAT Amount" := ABS(VatTransection."Remaining Unrealized Amt.");
                        end else
                            if VatTransection."Tax Invoice No." <> '' then begin
                                TaxReportLine."Tax Invoice No." := VatTransection."Tax Invoice No.";
                                TaxReportLine."Base Amount" := ABS(VatTransection."Tax Invoice Base");
                                TaxReportLine."VAT Amount" := ABS(VatTransection."Tax Invoice Amount");
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
                        "OnBeforeInsertVatLine"(TaxReportLine, VatTransection);
                        TaxReportLine.Insert();
                        TaxINvoiceLine := TaxReportLine."Entry No.";
                    end else begin
                        TaxINvoiceLine := TaxReportLine."Entry No.";
                        if VatTransection."Unrealized VAT Type" = VatTransection."Unrealized VAT Type"::Percentage then begin
                            TaxReportLine."Base Amount" += ABS(VatTransection."Remaining Unrealized Base");
                            TaxReportLine."VAT Amount" += ABS(VatTransection."Remaining Unrealized Amt.");
                        end else
                            if VatTransection."Tax Invoice No." <> '' then begin
                                TaxReportLine."Tax Invoice No." += VatTransection."Tax Invoice No.";
                                TaxReportLine."Base Amount" += ABS(VatTransection."Tax Invoice Base");
                                TaxReportLine."VAT Amount" += ABS(VatTransection."Tax Invoice Amount");
                            end else begin
                                TaxReportLine."Tax Invoice No." += VatTransection."External Document No.";
                                TaxReportLine."Base Amount" += VatBase;
                                TaxReportLine."VAT Amount" += VatAmt;
                            end;
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
    procedure "Get WHTData"()
    var
        TaxReportHeader: Record "Tax Report Header";
        TaxReportLineFind: Record "Tax Report Line";
        WHTLine: Record "WHT Lines";
    begin

        TaxReportHeader.get("Tax Type", "Document No.");
        TaxReportHeader.TestField("End date of Month");
        WHTHeader.RESET();
        WHTHeader.SETFILTER("WHT Date", '%1..%2', DMY2Date(01, TaxReportHeader."Month No.", TaxReportHeader."Year No."), CalcDate('<CM>', TaxReportHeader."End date of Month"));
        WHTHeader.SETFILTER("WHT No.", '<>%1', '');
        WHTHeader.SetFilter("WHT Business Posting Group", TaxReportHeader."WHT Bus. Post. Filter");
        WHTHeader.SetRange("Posted", true);
        WHTHeader.SETRANGE("Get to WHT", false);
        IF WHTHeader.FindFirst() THEN
            repeat
                WHTLine.reset();
                WHTLine.SetRange("WHT No.", WHTHeader."WHT No.");
                WHTLine.SetRange("Get to WHT", false);
                if WHTLine.FindFirst() then
                    repeat
                        TaxReportLineFind.INIT();
                        TaxReportLineFind."Tax Type" := "Tax Type";
                        TaxReportLineFind."Document No." := "Document No.";
                        TaxReportLineFind."Entry No." := GetLastLineNo();
                        TaxReportLineFind."Posting Date" := WHTHeader."WHT Date";
                        //  TaxReportLineFind."WHT Date" := WHTHeader.

                        //  TaxReportLineFind.
                        TaxReportLineFind."Voucher No." := WHTHeader."Gen. Journal Document No.";
                        TaxReportLineFind."Vendor No." := WHTHeader."WHT Source No.";
                        // TaxReportLineFind."Description" := WHTHeader."WHT Revenue Description";
                        TaxReportLineFind."Base Amount" := WHTLine."WHT Base";
                        TaxReportLineFind."VAT Amount" := WHTLine."WHT Amount";
                        TaxReportLineFind."WHT Business Posting Group" := WHTHeader."WHT Business Posting Group";
                        TaxReportLineFind."WHT Product Posting Group" := WHTLine."WHT Product Posting Group";
                        TaxReportLineFind."WHT Document No." := WHTHeader."WHT No.";
                        TaxReportLineFind."Name" := WHTHeader."WHT Name";
                        TaxReportLineFind."Name 2" := WHTHeader."WHT Name 2";
                        // TaxReportLineFind.
                        TaxReportLineFind."Address" := WHTHeader."WHT Address";
                        TaxReportLineFind."Address 2" := WHTHeader."WHT Address 2";
                        TaxReportLineFind."City" := WHTHeader."WHT City";
                        TaxReportLineFind."Post Code" := WHTHeader."WHT Post Code";
                        TaxReportLineFind."WHT Registration No." := WHTHeader."VAT Registration No.";
                        TaxReportLineFind."WHT %" := WHTLine."WHT %";
                        TaxReportLineFind."Head Office" := WHTHeader."Head Office";
                        TaxReportLineFind."Branch Code" := WHTHeader."VAT Branch Code";
                        TaxReportLineFind."VAT Registration No." := WHTHeader."VAT Registration No.";
                        TaxReportLineFind."Ref. Wht Line" := WHTLine."WHT Line No.";
                        TaxReportLineFind."WHT Certificate No." := WHTHeader."WHT Certificate No.";
                        if (NOT TaxReportLineFind."Head Office") AND (TaxReportLineFind."Branch Code" = '') then
                            TaxReportLineFind."Head Office" := true;
                        TaxReportLineFind.INSERT();

                        // PostedGenJournalLine."Get to WHT" := true;
                        // PostedGenJournalLine.MODIFY;
                        WHTLine."Get to WHT" := true;
                        WHTLine.Modify();
                    UNTIL WHTLine.NEXT() = 0;

                WHTHeader."Get to WHT" := true;
                WHTHeader.Modify();
            until WHTHeader.next() = 0;
    end;

    /// <summary> 
    /// Description for GetLastLineNo.
    /// </summary>
    /// <returns>Return variable "Integer".</returns>
    procedure GetLastLineNo(): Integer
    var
        TaxReportLine: Record "Tax Report Line";
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
    /// <summary> 
    /// Description for OnBeforeInsertVatLine.
    /// </summary>
    /// <param name="TaxReportLine">Parameter of type Record "Tax Report Line".</param>
    /// <param name="VatTransaction">Parameter of type Record "VAT Transections".</param>
    procedure "OnBeforeInsertVatLine"(var TaxReportLine: Record "Tax Report Line"; var VatTransaction: Record "VAT Transections")
    begin

    end;

}

