/// <summary>
/// Table Billing Receipt Header (ID 50001).
/// </summary>
Table 50001 "Billing Receipt Header"
{
    Caption = 'Billing Receipt Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document Type"; Enum "Billing Document Type")
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
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
                            rec."Head Office" := cust."Head Office";
                            rec."Branch Code" := Cust."Branch Code";
                            if (NOT rec."Head Office") AND (rec."Branch Code" = '') then
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
                            rec."Head Office" := Vend."Head Office";
                            rec."Branch Code" := Vend."Branch Code";
                            if (NOT rec."Head Office") AND (rec."Branch Code" = '') then
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
        field(23; "Status"; Enum "Billing Receipt Status")
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
                    "Branch Code" := '';
            end;

        }
        field(30; "Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
            TableRelation = IF ("Document Type" = FILTER('Sales Billing|Sales Receipt')) "Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Bill/Pay-to Cust/Vend No."))
            ELSE
            IF ("Document Type" = FILTER("Purchase Billing")) "Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Bill/Pay-to Cust/Vend No."));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Branch Code" <> '' then begin
                    if StrLen("Branch Code") < 5 then
                        Error('Branch Code must be 5 characters');
                    "Head Office" := false;

                end;
                if ("Branch Code" = '00000') OR ("Branch Code" = '') then begin
                    "Head Office" := TRUE;
                    "Branch Code" := '';

                end;

            end;
        }
        field(31; "Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Billing Receipt Line"."Amount" WHERE("Document Type" = FIELD("Document Type"),
            "Document No." = FIELD("No.")));
        }
        field(32; "Amount (LCY)"; Decimal)
        {
            Editable = false;
            Caption = 'Amount (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum("Billing Receipt Line"."Amount (LCY)" WHERE("Document Type" = FIELD("Document Type"),
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
        field(41; "Receive Status"; Option)
        {
            Caption = 'Receive Status';
            OptionCaption = ' ,In used,Used';
            OptionMembers = " ","In used",Used;
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(42; "Template Name"; Code[10])
        {
            Caption = 'Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(43; "Batch Name"; Code[10])
        {

            Caption = 'Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Template Name"));
            trigger OnValidate()
            begin
                TestField("Template Name");
            end;
        }
        field(44; "RV No. Series"; Code[20])
        {
            Caption = 'RV No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(45; "Journal Document No."; Code[20])
        {
            Caption = 'Journal Document No.';
            DataClassification = SystemMetadata;
            Editable = false;
            trigger OnLookup()
            var
                GenJnlLine: Record "Gen. Journal Line";
            begin
                GenJnlLine.RESET();
                GenJnlLine.FILTERGROUP := 2;
                GenJnlLine.SETRANGE("Journal Template Name", "Template Name");
                GenJnlLine.FILTERGROUP := 0;
                GenJnlLine.SETRANGE("Journal Batch Name", "Batch Name");
                GenJnlLine."Journal Template Name" := '';
                GenJnlLine."Journal Batch Name" := "Batch Name";
                GenJnlLine.SETFILTER("Document No.", '%1', "Journal Document No.");
                PAGE.RUN(PAGE::"Cash Receipt Journal", GenJnlLine);
            end;
        }
        field(46; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(47; "Receive Type"; Enum "Billing Receipt Receive Type")
        {
            Caption = 'Receive Type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(48; "Receive Account No."; Code[20])
        {
            Caption = 'Receive Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Receive Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Receive Type" = CONST("G/L Account")) "G/L Account";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(49; "Receive Date"; Date)
        {
            Caption = 'Receive Date';
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
        field(51; "Receive Amount"; Decimal)
        {
            Caption = 'Receive Amount';
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
        "Create By User" := COPYSTR(UserId(), 1, 50);
        "Create DateTime" := CurrentDateTime;
        "Posting Date" := Today();
        "Document Date" := Today();
        TestField("No.");
    end;

    trigger OnDelete()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        BillingReceiptLine: Record "Billing Receipt Line";
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
    procedure "AssistEdit"(OldBillingHeader: Record "Billing Receipt Header"): Boolean
    var
        BillingHeader2, BillingReceiptHeader : Record "Billing Receipt Header";
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
                    SalesSetup.TestField("Sale Billing Nos.");
                    EXIT(SalesSetup."Sale Billing Nos.");
                end;
            "Document Type"::"Sales Receipt":
                begin
                    SalesSetup.TestField("Sale Receipt Nos.");
                    EXIT(SalesSetup."Sale Receipt Nos.");
                end;
            "Document Type"::"Purchase Billing":
                begin
                    PurchSetup.TestField("Purchase Billing Nos.");
                    EXIT(PurchSetup."Purchase Billing Nos.");
                end;
        END;
    end;

    /// <summary> 
    /// Description for TestBillingLine.
    /// </summary>
    local procedure TestBillingLine()
    var
        BillingReceiptLine: Record "Billing Receipt Line";
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
        BillingReceiptLine: Record "Billing Receipt Line";
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
    PROCEDURE OnSendBillingReceiptforApproval(var BillingReceiptHeader: Record "Billing Receipt Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelBillingReceiptforApproval(var BillingReceiptHeader: Record "Billing Receipt Header");
    begin
    end;


    local procedure IsItemBillingReceiptEnabled(var BillingReceiptHeader: Record "Billing Receipt Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit EventFunction;
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
    /// <param name="BillingReceiptHeader">VAR Record "Billing Receipt Header".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckWorkflowBillingReceiptEnabled(var BillingReceiptHeader: Record "Billing Receipt Header"): Boolean
    var
        NoWorkflowEnbMsg: Label 'No workflow Enabled for this Record type';
    begin
        BillingReceiptHeader.TestField("No.");
        if not IsItemBillingReceiptEnabled(BillingReceiptHeader) then
            Error(NoWorkflowEnbMsg);
        exit(true);
    end;


    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        text051Txt: Label 'The document %1 %2 already exists.', Locked = true;
        Text001Err: Label 'Cannot Change';
        Text003Txt: Label 'You cannot rename a %1.', Locked = true;
        Text002Msg: Label 'This document can only be released when the approval process is complete.';
        Text003Msg: Label 'The approval process must be cancelled or completed to reopen this document.';


}