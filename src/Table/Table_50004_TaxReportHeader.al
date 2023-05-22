/// <summary>
/// Table Tax Report Header (ID 50004).
/// </summary>
table 50004 "Tax Report Header"
{
    Caption = 'Tax Report Header';
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
            DataClassification = CustomerContent;
        }
        field(3; "End date of Month"; Date)
        {
            Caption = 'End date of Month';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                FunctionCenter: Codeunit "Function Center";
            begin
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
        field(8; "Status Lock"; Boolean)
        {
            Caption = 'Status Lock';
            DataClassification = SystemMetadata;
        }
        field(9; "Total Base Amount"; Decimal)
        {
            CalcFormula = Sum("Tax Report Line"."Base Amount" WHERE("Tax Type" = FIELD("Tax Type"),
                                                                     "Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Base Amount';
        }
        field(10; "Total VAT Amount"; Decimal)
        {
            CalcFormula = Sum("Tax Report Line"."VAT Amount" WHERE("Tax Type" = FIELD("Tax Type"),
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
        field(15; "Vat Bus. Post. Filter"; Code[30])
        {
            Caption = 'Vat Bus. PostingGroup Filter';
            TableRelation = "VAT Business Posting Group".Code;
            FieldClass = FlowFilter;
        }
        field(16; "WHT Bus. Post. Filter"; Code[30])
        {
            Caption = 'Vat Bus. PostingGroup Filter';
            TableRelation = "WHT Business Posting Group";
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

        TaxReportLine.RESET();
        TaxReportLine.SETRANGE("Tax Type", "Tax Type");
        TaxReportLine.SETRANGE("Document No.", "Document No.");
        IF TaxReportLine.FindSet() THEN
            TaxReportLine.DELETEALL(TRUE);
    end;

    trigger OnRename()
    begin

        TaxReportLine.RESET();
        TaxReportLine.SETRANGE("Tax Type", xRec."Tax Type");
        TaxReportLine.SETRANGE("Document No.", xRec."Document No.");
        IF TaxReportLine.FindFirst() THEN
            ERROR('Can not change!');
    end;

    trigger OnInsert()
    begin
        TestField("Document No.");
        "Create By" := COPYSTR(UserId(), 1, 50);
        "Create DateTime" := CurrentDateTime;

    end;

    var
        TaxReportLine: Record "Tax Report Line";


    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldVatHeader">Parameter of type Record "Tax Report Header".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure AssistEdit(OldVatHeader: Record "Tax Report Header"): Boolean
    var
        VatHeader: Record "Tax Report Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        purchaseSetup: Record "Purchases & Payables Setup";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        // WITH VatHeader DO BEGIN
        VatHeader.COPY(Rec);
        if VatHeader."Tax Type" = VatHeader."Tax Type"::Purchase then begin
            purchaseSetup.GET();
            purchaseSetup.TESTFIELD("Purchase VAT Nos.");
            IF NoSeriesMgt.SelectSeries(purchaseSetup."Purchase VAT Nos.", OldVatHeader."No. Series",
              VatHeader."No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries(VatHeader."Document No.");
                Rec := VatHeader;
                EXIT(TRUE);
            END;
        end;
        if VatHeader."Tax Type" = VatHeader."Tax Type"::Sale then begin
            SalesSetup.GET();
            SalesSetup.TESTFIELD("Sales VAT Nos.");
            IF NoSeriesMgt.SelectSeries(SalesSetup."Sales VAT Nos.", OldVatHeader."No. Series",
              VatHeader."No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries(VatHeader."Document No.");
                Rec := VatHeader;
                EXIT(TRUE);
            END;
        end;
        if VatHeader."Tax Type".AsInteger() > 1 then begin
            purchaseSetup.GET();
            if "Tax Type" = "Tax Type"::WHT03 then begin
                purchaseSetup.TESTFIELD("WHT03 Nos.");
                IF NoSeriesMgt.SelectSeries(purchaseSetup."WHT03 Nos.", OldVatHeader."No. Series",
                  VatHeader."No. Series") THEN BEGIN
                    NoSeriesMgt.SetSeries(VatHeader."Document No.");
                    Rec := VatHeader;
                    EXIT(TRUE);
                END;
            end;
            if "Tax Type" = "Tax Type"::WHT53 then begin
                purchaseSetup.TESTFIELD("WHT53 Nos.");
                IF NoSeriesMgt.SelectSeries(purchaseSetup."WHT53 Nos.", OldVatHeader."No. Series",
                  VatHeader."No. Series") THEN BEGIN
                    NoSeriesMgt.SetSeries(VatHeader."Document No.");
                    Rec := VatHeader;
                    EXIT(TRUE);
                END;
            end;
        end;
    END;
    //  end;
}

