/// <summary>
/// Table NCT Billing Receipt Header (ID 80001).
/// </summary>
Table 80001 "NCT Billing Receipt Header"
{
    Caption = 'Billing Receipt Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document Type"; Enum "NCT Billing Document Type")
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if rec."No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Currency Code");
            end;
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD("Status", "Status"::Open);
                VALIDATE("Payment Terms Code");
            end;
        }
        field(5; "Bill/Pay-to Cust/Vend No."; Code[20])
        {
            Caption = 'Bill/Pay-to Cust/Vend No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = FILTER('Sales Billing|Sales Receipt')) Customer."No." ELSE
            IF ("Document Type" = FILTER("Purchase Billing")) Vendor."No.";
            trigger OnValidate()
            var
                Cust: Record Customer;
                Vend: Record Vendor;
            begin
                TESTFIELD("Status", "Status"::Open);
                "Posting Description" := FORMAT("Document Type") + ' ' + "No.";
                TestBillingLine();
                CASE "Document Type" OF
                    "Document Type"::"Sales Billing", "Document Type"::"Sales Receipt":
                        BEGIN
                            IF NOT Cust.GET("Bill/Pay-to Cust/Vend No.") THEN
                                Cust.INIT();
                            rec."Bill/Pay-to Cust/Vend Name" := Cust.Name;
                            rec."Bill/Pay-to Cus/Vend Name 2" := Cust."Name 2";
                            rec."Bill/Pay-to Address" := Cust.Address;
                            rec."Bill/Pay-to Address 2" := Cust."Address 2";
                            rec."Bill/Pay-to Post Code" := Cust."Post Code";
                            rec."Bill/Pay-to City" := Cust.City;
                            rec."Bill/Pay-to County" := Cust.County;
                            rec."Bill/Pay-to Country/Region" := Cust."Country/Region Code";
                            rec."Bill/Pay-to Contact" := Cust.Contact;
                            rec."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                            rec."Vat Registration No." := cust."VAT Registration No.";
                            rec."Head Office" := cust."NCT Head Office";
                            rec."VAT Branch Code" := Cust."NCT VAT Branch Code";
                            if (NOT rec."Head Office") AND (rec."VAT Branch Code" = '') then
                                rec."Head Office" := true;
                            if rec."Document Date" = 0D then
                                rec."Document Date" := TODAY;
                            rec.VALIDATE("Payment Terms Code", Cust."Payment Terms Code");
                            rec.VALIDATE("Payment Method Code", Cust."Payment Method Code");
                            rec.VALIDATE("Currency Code", Cust."Currency Code");
                        END;
                    "Document Type"::"Purchase Billing":
                        BEGIN
                            IF NOT Vend.GET("Bill/Pay-to Cust/Vend No.") THEN
                                Vend.INIT();
                            rec."Bill/Pay-to Cust/Vend Name" := Vend.Name;
                            rec."Bill/Pay-to Cus/Vend Name 2" := Vend."Name 2";
                            rec."Bill/Pay-to Address" := Vend.Address;
                            rec."Bill/Pay-to Address 2" := Vend."Address 2";
                            rec."Bill/Pay-to Post Code" := Vend."Post Code";
                            rec."Bill/Pay-to City" := Vend.City;
                            rec."Bill/Pay-to County" := Vend.County;
                            rec."Bill/Pay-to Country/Region" := Vend."Country/Region Code";
                            rec."Bill/Pay-to Contact" := Vend.Contact;
                            rec."VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                            rec."Vat Registration No." := Vend."VAT Registration No.";
                            rec."Head Office" := Vend."NCT Head Office";
                            rec."VAT Branch Code" := Vend."NCT VAT Branch Code";
                            if (NOT rec."Head Office") AND (rec."VAT Branch Code" = '') then
                                rec."Head Office" := true;
                            if rec."Document Date" = 0D then
                                rec."Document Date" := TODAY;
                            rec.VALIDATE("Payment Terms Code", Vend."Payment Terms Code");
                            rec.VALIDATE("Payment Method Code", Vend."Payment Method Code");
                            rec.VALIDATE("Currency Code", Vend."Currency Code");
                        END;
                END;
            end;
        }
        field(6; "Bill/Pay-to Cust/Vend Name"; Text[100])
        {
            Caption = 'Bill/Pay-to Cust/Vend Name';
            DataClassification = CustomerContent;
        }
        field(7; "Bill/Pay-to Cus/Vend Name 2"; Text[50])
        {
            Caption = 'Bill/Pay-to Cust/Vend Name 2';
            DataClassification = CustomerContent;
        }
        field(8; "Bill/Pay-to Address"; Text[100])
        {
            Caption = 'Bill/Pay-to Cust/Vend Address';
            DataClassification = CustomerContent;
        }
        field(9; "Bill/Pay-to Address 2"; Text[50])
        {
            Caption = 'Bill/Pay-to Cust/Vend Address 2';
            DataClassification = CustomerContent;
        }
        field(10; "Bill/Pay-to Post Code"; Code[20])
        {
            Caption = 'Bill/Pay-to Post Code';
            DataClassification = CustomerContent;
        }
        field(11; "Bill/Pay-to City"; Text[50])
        {
            Caption = 'Bill/Pay-to City';
            DataClassification = CustomerContent;
        }
        field(12; "Bill/Pay-to County"; Text[50])
        {
            Caption = 'Bill/Pay-to County';
            DataClassification = CustomerContent;
        }
        field(13; "Bill/Pay-to Country/Region"; Code[10])
        {
            Caption = 'Bill/Pay-to Country/Region';
            DataClassification = CustomerContent;
        }
        field(14; "Bill/Pay-to Contact"; Text[100])
        {
            Caption = 'Bill/Pay-to Contact';
            DataClassification = CustomerContent;
        }
        field(15; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms".Code;
            trigger OnValidate()
            var
                Payment: Record "Payment Terms";
            begin
                TESTFIELD("Status", "Status"::Open);
                if not Payment.GET("Payment Terms Code") then
                    Payment.init();

                if "Payment Terms Code" <> '' then
                    "Due Date" := CalcDate(Payment."Due Date Calculation", "Document Date")
                else
                    "Due Date" := "Posting Date";
            end;
        }
        field(16; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD("Status", "Status"::Open);
                UpdateBillingLine(FIELDNO("Due Date"));
            end;
        }
        field(17; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method".Code;
            trigger OnValidate()
            begin
                TESTFIELD("Status", "Status"::Open);
            end;
        }
        field(18; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
            DataClassification = CustomerContent;
        }
        field(19; "Your Reference"; Text[30])
        {
            Caption = 'Your Reference';
            DataClassification = CustomerContent;
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CurrExchRate: Record 330;
            begin
                if "Currency Code" <> '' then begin
                    if "Currency Code" <> xRec."Currency Code" then
                        "Currency Factor" := CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                end else
                    "Currency Factor" := 0;
            end;
        }
        field(21; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(23; "Status"; Enum "NCT Billing Receipt Status")
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(24; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(25; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(26; "Create By User"; Code[50])
        {
            Caption = 'Create By User';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(27; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(28; "Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(29; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "VAT Branch Code" := '';
            end;

        }
        field(30; "VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            TableRelation = IF ("Document Type" = FILTER('Sales Billing|Sales Receipt')) "NCT Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Bill/Pay-to Cust/Vend No."))
            ELSE
            IF ("Document Type" = FILTER("Purchase Billing")) "NCT Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Bill/Pay-to Cust/Vend No."));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "VAT Branch Code" <> '' then begin
                    if StrLen("VAT Branch Code") < 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "Head Office" := false;

                end;
                if ("VAT Branch Code" = '00000') OR ("VAT Branch Code" = '') then begin
                    "Head Office" := TRUE;
                    "VAT Branch Code" := '';

                end;

            end;
        }
        field(31; "Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("NCT Billing Receipt Line"."Amount" WHERE("Document Type" = FIELD("Document Type"),
            "Document No." = FIELD("No.")));
        }
        field(32; "Amount (LCY)"; Decimal)
        {
            Editable = false;
            Caption = 'Amount (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum("NCT Billing Receipt Line"."Amount (LCY)" WHERE("Document Type" = FIELD("Document Type"),
            "Document No." = FIELD("No.")));
        }
        field(33; "Prepaid WHT Acc."; Code[20])
        {
            Caption = 'Prepaid WHT Acc.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(34; "Prepaid WHT Amount (LCY)"; Decimal)
        {
            Caption = 'Prepaid WHT Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(35; "Diff Amount Acc."; Code[20])
        {
            Caption = 'Diff Amount Acc.';
            DataClassification = CustomerContent;
        }
        field(36; "Bank Fee Acc."; Code[20])
        {
            Caption = 'Bank Fee Acc.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(37; "Bank Fee Amount (LCY)"; Decimal)
        {
            Caption = 'Bank Fee Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(38; "Prepaid WHT Date"; Date)
        {
            Caption = 'Prepaid WHT Date';
            DataClassification = CustomerContent;
        }
        field(39; "Prepaid WHT No."; Code[20])
        {
            Caption = 'Prepaid WHT No.';
            DataClassification = CustomerContent;
        }
        field(40; "Diff Amount (LCY)"; Decimal)
        {
            Caption = 'Diff Amount (LCY)';
            DataClassification = SystemMetadata;
        }

        field(42; "Journal Template Name"; Code[10])
        {
            Caption = 'Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(43; "Journal Batch Name"; Code[10])
        {

            Caption = 'Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
            trigger OnValidate()
            begin
                TestField("Journal Template Name");
            end;
        }
        field(44; "Journal No. Series"; Code[20])
        {
            Caption = 'Journal No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(45; "Journal Document No."; Code[20])
        {
            Caption = 'Journal Document No.';
            DataClassification = SystemMetadata;
        }

        field(47; "Account Type"; Enum "NCT Billing Receipt Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(48; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Account Type" = CONST("G/L Account")) "G/L Account";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(49; "Journal Date"; Date)
        {
            Caption = 'Journal Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50; "Cheque No."; Code[20])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(51; "Receive & Payment Amount"; Decimal)
        {
            Caption = 'Receive & Payment Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        field(52; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
        }
        field(53; "Create to Journal"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Create to Journal';

        }
    }
    keys
    {
        key("PK"; "Document Type", "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        TestField("No.");
        "Create By User" := COPYSTR(UserId(), 1, 50);
        "Create DateTime" := CurrentDateTime;
        "Posting Date" := Today();
        "Document Date" := Today();

    end;

    trigger OnDelete()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        BillingReceiptLine: Record "NCT Billing Receipt Line";
    begin
        TESTFIELD("Status", "Status"::Open);

        BillingReceiptLine.reset();
        BillingReceiptLine.SetRange("Document Type", BillingReceiptLine."Document Type");
        BillingReceiptLine.SetRange("Document No.", "No.");
        BillingReceiptLine.DeleteAll();
        ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RecordId);
    end;

    trigger OnModify()
    begin
        TESTFIELD("Status", "Status"::Open);
    end;

    trigger OnRename()
    begin
        ERROR(Text003Txt, TABLECAPTION);
    end;


    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldBillingHeader">Parameter of type Record "Billing  Receipt Header".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure "AssistEdit"(OldBillingHeader: Record "NCT Billing Receipt Header"): Boolean
    var
        BillingHeader2, BillingReceiptHeader : Record "NCT Billing Receipt Header";
    begin
        // WITH BillingReceiptHeader DO BEGIN
        BillingReceiptHeader.COPY(Rec);
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldBillingHeader."No. Series", BillingReceiptHeader."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(BillingReceiptHeader."No.");
            IF BillingHeader2.GET(BillingReceiptHeader."Document Type", BillingReceiptHeader."No.") THEN
                ERROR(text051Txt, LOWERCASE(FORMAT(BillingReceiptHeader."Document Type")), BillingReceiptHeader."No.");
            Rec := BillingReceiptHeader;
            EXIT(TRUE);
        END;
        //END;
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
        CASE "Document Type" OF
            "Document Type"::"Sales Billing":
                begin
                    SalesSetup.TestField("NCT Sale Billing Nos.");
                    EXIT(SalesSetup."NCT Sale Billing Nos.");
                end;
            "Document Type"::"Sales Receipt":
                begin
                    SalesSetup.TestField("NCT Sale Receipt Nos.");
                    EXIT(SalesSetup."NCT Sale Receipt Nos.");
                end;
            "Document Type"::"Purchase Billing":
                begin
                    PurchSetup.TestField("NCT Purchase Billing Nos.");
                    EXIT(PurchSetup."NCT Purchase Billing Nos.");
                end;
        END;
    end;

    /// <summary> 
    /// Description for TestBillingLine.
    /// </summary>
    local procedure TestBillingLine()
    var
        BillingReceiptLine: Record "NCT Billing Receipt Line";
    begin
        BillingReceiptLine.RESET();
        BillingReceiptLine.SETRANGE("Document Type", "Document Type");
        BillingReceiptLine.SETRANGE("Document No.", "No.");
        IF not BillingReceiptLine.IsEmpty THEN
            ERROR(Text001Err);
    end;

    /// <summary> 
    /// Description for UpdateBillingLine.
    /// </summary>
    /// <param name="ChangeFieldNo">Parameter of type Integer.</param>
    local procedure UpdateBillingLine(ChangeFieldNo: Integer)
    var
        BillingReceiptLine: Record "NCT Billing Receipt Line";
    begin

        BillingReceiptLine.RESET();
        BillingReceiptLine.SETRANGE("Document Type", "Document Type");
        BillingReceiptLine.SETRANGE("Document No.", "No.");
        CASE ChangeFieldNo OF
            FIELDNO("Posting Date"):
                BillingReceiptLine.MODIFYALL("Posting Date", "Posting Date");
            FIELDNO("Document Date"):
                BillingReceiptLine.MODIFYALL("Document Date", "Document Date");
            FIELDNO("Due Date"):
                BEGIN
                    BillingReceiptLine.MODIFYALL("Due Date", "Due Date");
                    IF BillingReceiptLine.FindSet() THEN
                        BillingReceiptLine.ModifyAll("Due Date", "Due Date");

                END;
        END;
    end;

    /// <summary> 
    /// Description for TestStatusOpen.
    /// </summary>
    procedure TestStatusOpen()
    begin
        TESTFIELD("Status", "Status"::Open);
    end;

    /// <summary> 
    /// Description for TestStatusRelease.
    /// </summary>
    procedure TestStatusRelease()
    begin
        TESTFIELD("Status", "Status"::Released);
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendBillingReceiptforApproval(var BillingReceiptHeader: Record "NCT Billing Receipt Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelBillingReceiptforApproval(var BillingReceiptHeader: Record "NCT Billing Receipt Header");
    begin
    end;


    local procedure IsItemBillingReceiptEnabled(var BillingReceiptHeader: Record "NCT Billing Receipt Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "NCT EventFunction";
    begin
        exit(WFMngt.CanExecuteWorkflow(BillingReceiptHeader, WFCode.RunWorkflowOnSendBillingReceiptApprovalCode()))
    end;

    /// <summary>
    /// CheckRelease.
    /// </summary>
    procedure CheckBeforRelease()
    begin
        if IsItemBillingReceiptEnabled(rec) then
            Error(Text002Msg);
    end;

    /// <summary>
    /// CheckbeforReOpen.
    /// </summary>
    procedure CheckbeforReOpen()
    begin
        if rec.Status = rec.Status::"Pending Approval" then
            Error(Text003Msg);
    end;

    /// <summary>
    /// CheckWorkflowBillingReceiptEnabled.
    /// </summary>
    /// <param name="BillingReceiptHeader">VAR Record "NCT Billing Receipt Header".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckWorkflowBillingReceiptEnabled(var BillingReceiptHeader: Record "NCT Billing Receipt Header"): Boolean
    var
        NoWorkflowEnbMsg: Label 'No workflow Enabled for this Record type';
    begin
        BillingReceiptHeader.TestField("No.");
        if not IsItemBillingReceiptEnabled(BillingReceiptHeader) then
            Error(NoWorkflowEnbMsg);
        exit(true);
    end;

    /// <summary>
    /// CreateToPayment.
    /// </summary>
    procedure CreateToPayment()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalTem: Record "Gen. Journal Template";
        PurchaseBillingLine, PurchaseBillingLineInvoice : Record "NCT Billing Receipt Line";
        ltVendorLedger: Record "Vendor Ledger Entry";
        WHTAppliedFunc: codeunit "NCT EventFunction";
        DocumentNo: code[20];
        TotalAmt: Decimal;
        InvoiceNo: Text;
        whtBus: code[20];
    begin
        TotalAmt := 0;
        InvoiceNO := '';
        whtBus := '';
        rec.TestField("Journal Template Name");
        rec.TestField("Journal Batch Name");
        rec.TestField("Account No.");
        rec.TestField("Journal No. Series");
        rec.TestField("Journal Date");
        GenJournalTem.get(rec."Journal Template Name");
        PurchaseBillingLine.reset();
        PurchaseBillingLine.SetRange("Document Type", rec."Document Type");
        PurchaseBillingLine.SetRange("Document No.", rec."No.");
        PurchaseBillingLine.SetFilter("Amount", '<>%1', 0);
        if PurchaseBillingLine.FindSet() then begin
            if rec."Journal Document No." <> '' then
                DocumentNo := rec."Journal Document No."
            else
                DocumentNo := NoSeriesMgt.GetNextNo(rec."Journal No. Series", WorkDate(), TRUE);
            repeat
                GenJournalLine.Init();
                GenJournalLine."Journal Template Name" := rec."Journal Template Name";
                GenJournalLine."Journal Batch Name" := rec."Journal Batch Name";
                GenJournalLine."Document No." := DocumentNo;
                GenJournalLine."NCT Document No. Series" := rec."Journal No. Series";
                GenJournalLine."Posting Date" := rec."Journal Date";
                GenJournalLine."Document Date" := rec."Journal Date";
                GenJournalLine."Source Code" := GenJournalTem."Source Code";
                GenJournalLine."Line No." := GenJournalLine.GetLastLine();
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.insert();
                GenJournalLine.Validate("Account No.", rec."Bill/Pay-to Cust/Vend No.");
                GenJournalLine."External Document No." := PurchaseBillingLine."Document No.";
                GenJournalLine.Validate(Amount, PurchaseBillingLine."Amount");
                GenJournalLine."NCT Ref. Billing & Receipt No." := rec."No.";

                if PurchaseBillingLine."Source Document Type" = PurchaseBillingLine."Source Document Type"::Invoice then
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice
                else
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";
                GenJournalLine.Validate("Applies-to Doc. No.", PurchaseBillingLine."Source Document No.");
                GenJournalLine.Modify();

                ltVendorLedger.reset();
                ltVendorLedger.SetRange("Document No.", PurchaseBillingLine."Source Document No.");
                if ltVendorLedger.FindFirst() then begin
                    if PurchaseBillingLine."Source Document Type" = PurchaseBillingLine."Source Document Type"::Invoice then
                        ltVendorLedger.Validate("Amount to Apply", -PurchaseBillingLine."Amount")
                    else
                        ltVendorLedger.Validate("Amount to Apply", abs(PurchaseBillingLine."Amount"));
                    ltVendorLedger.Modify();
                end;

                PurchaseBillingLineInvoice.reset();
                PurchaseBillingLineInvoice.SetRange("Document Type", PurchaseBillingLine."Document Type");
                PurchaseBillingLineInvoice.SetFilter("Document No.", '<>%1', PurchaseBillingLine."Document No.");
                PurchaseBillingLineInvoice.SetRange("Source Document No.", PurchaseBillingLine."Source Document No.");
                PurchaseBillingLineInvoice.SetFilter(Status, '>%1', 2);
                if PurchaseBillingLineInvoice.IsEmpty then
                    if StrPos(InvoiceNO, PurchaseBillingLine."Source Document No.") = 0 then begin
                        if InvoiceNO <> '' then
                            InvoiceNO := InvoiceNO + '|';
                        InvoiceNO := InvoiceNO + PurchaseBillingLine."Source Document No.";
                    end;



            until PurchaseBillingLine.Next() = 0;
            if InvoiceNO <> '' then begin
                GenJournalLine.reset();
                GenJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                GenJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                GenJournalLine.SetRange("Document No.", DocumentNo);
                if GenJournalLine.FindFirst() then
                    WHTAppliedFunc.InsertWHTCertificate(GenJournalLine, InvoiceNO);
            end;

            GenJournalLine.reset();
            GenJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
            GenJournalLine.SetRange("Document No.", DocumentNo);
            GenJournalLine.CalcSums(Amount);
            TotalAmt := GenJournalLine.Amount;

            GenJournalLine.Init();
            GenJournalLine."Journal Template Name" := rec."Journal Template Name";
            GenJournalLine."Journal Batch Name" := rec."Journal Batch Name";
            GenJournalLine."Document No." := DocumentNo;
            GenJournalLine."NCT Document No. Series" := rec."Journal No. Series";
            GenJournalLine."Posting Date" := rec."Journal Date";
            GenJournalLine."Document Date" := rec."Journal Date";
            GenJournalLine."Source Code" := GenJournalTem."Source Code";
            GenJournalLine."Line No." := GenJournalLine.GetLastLine();
            if rec."Account Type" = rec."Account Type"::"Bank Account" then
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account"
            else
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            GenJournalLine.insert();
            GenJournalLine."NCT Ref. Billing & Receipt No." := rec."No.";
            GenJournalLine.Validate("Account No.", rec."Account No.");
            GenJournalLine.Validate(Amount, -TotalAmt);
            GenJournalLine.Modify();


            rec."Receive & Payment Amount" := ABS(TotalAmt);
            rec."Journal Document No." := DocumentNo;
            rec."Create to Journal" := true;
            rec.Status := rec.Status::"Created to Journal";
            rec.Modify();
            Message('Created Successfully');
        end else
            Message('Nothing to Create');

    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        text051Txt: Label 'The document %1 %2 already exists.', Locked = true;
        Text001Err: Label 'Cannot Change';
        Text003Txt: Label 'You cannot rename a %1.', Locked = true;
        Text002Msg: Label 'This document can only be released when the approval process is complete.';
        Text003Msg: Label 'The approval process must be cancelled or completed to reopen this document.';


}