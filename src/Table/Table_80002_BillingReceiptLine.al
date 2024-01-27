/// <summary>
/// Table NC Billing Receipt Line (ID 80002).
/// </summary>
table 80002 "NCT Billing Receipt Line"
{
    Caption = 'Billing Receipt Line';
    Permissions = TableData 21 = rm, TableData 25 = rm;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document Type"; Enum "NCT Billing Document Type")
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(6; "Bill/Pay-to Cust/Vend No."; Code[20])
        {
            Caption = 'Bill/Pay-to Cust/Vend No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = FILTER('Sales Billing|Sales Receipt')) Customer."No." ELSE
            IF ("Document Type" = FILTER("Purchase Billing")) Vendor."No.";
            Editable = false;
        }
        field(7; "Source Ledger Entry No."; Integer)
        {
            Caption = 'Source Ledger Entry No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(8; "Source Document Type"; Enum "Gen. Journal Document Type")
        {

            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Source Document Type';

        }
        field(9; "Source Document No."; code[20])
        {
            Caption = 'Source Document No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(10; "Source Posting Date"; Date)
        {
            Caption = 'Source Posting Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(11; "Source Document Date"; Date)
        {
            Caption = 'Source Document Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(12; "Source Ext. Document No."; Code[35])
        {
            Caption = 'Source Ext. Document No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(13; "Source Due Date"; Date)
        {
            Caption = 'Source Due Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(15; "Source Currency Code"; Code[10])
        {
            Caption = 'Source Currency Code';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(16; "Source Amount"; Decimal)
        {
            Caption = 'Source Amount';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(17; "Source Amount (LCY)"; Decimal)
        {
            Caption = 'Source Amount (LCY)';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(18; "Source Description"; text[100])
        {
            Caption = 'Source Description';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(19; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                VendorLedger: Record "Vendor Ledger Entry";
                CustLedger: Record "Cust. Ledger Entry";
                PurchaseBilling, ltBillingLine : Record "NCT Billing Receipt Line";
                PurchaseBillingHeader: Record "NCT Billing Receipt Header";
                TOtalAmt: Decimal;
            begin
                PurchaseBillingHeader.GET(rec."Document Type", rec."Document No.");
                PurchaseBillingHeader.TestField("Status", PurchaseBillingHeader."Status"::Open);
                if PurchaseBillingHeader."Document Type" = PurchaseBillingHeader."Document Type"::"Purchase Billing" then begin
                    if not VendorLedger.GET("Source Ledger Entry No.") then
                        VendorLedger.Init();
                    VendorLedger.CalcFields("Remaining Amount");
                    PurchaseBilling.reset();
                    PurchaseBilling.SetRange("Document Type", PurchaseBillingHeader."Document Type");
                    PurchaseBilling.SetRange("Document No.", rec."Document No.");
                    PurchaseBilling.SetFilter("Line No.", '<>%1', rec."Line No.");
                    PurchaseBilling.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");

                    PurchaseBilling.CalcSums("Amount");

                    TOtalAmt := PurchaseBilling."Amount";

                    PurchaseBilling.reset();
                    PurchaseBilling.SetRange("Document Type", PurchaseBillingHeader."Document Type");
                    PurchaseBilling.SetFilter("Document No.", '<>%1', rec."Document No.");
                    PurchaseBilling.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");
                    PurchaseBilling.SetFilter("Status", '<>%1', PurchaseBilling."Status"::"Posted");
                    PurchaseBilling.CalcSums("Amount");
                    TOtalAmt := TOtalAmt + PurchaseBilling."Amount";


                    if (ABS(VendorLedger."Remaining Amount") - (rec."Amount" + TOtalAmt)) < 0 then
                        VendorLedger.FieldError("Remaining Amount", strsubstno('remaining amount is %1', ABS(VendorLedger."Remaining Amount" - TOtalAmt)));
                end;

                if PurchaseBillingHeader."Document Type" = PurchaseBillingHeader."Document Type"::"Sales Receipt" then begin

                    if not CustLedger.GET("Source Ledger Entry No.") then
                        CustLedger.Init();
                    CustLedger.CalcFields("Remaining Amount");

                    PurchaseBilling.reset();
                    PurchaseBilling.SetRange("Document Type", PurchaseBillingHeader."Document Type");
                    PurchaseBilling.SetRange("Document No.", rec."Document No.");
                    PurchaseBilling.SetFilter("Line No.", '<>%1', rec."Line No.");
                    PurchaseBilling.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");

                    PurchaseBilling.CalcSums("Amount");

                    TOtalAmt := PurchaseBilling."Amount";

                    PurchaseBilling.reset();
                    PurchaseBilling.SetRange("Document Type", PurchaseBillingHeader."Document Type");
                    PurchaseBilling.SetFilter("Document No.", '<>%1', rec."Document No.");
                    PurchaseBilling.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");
                    PurchaseBilling.SetFilter("Status", '<>%1', PurchaseBilling."Status"::"Posted");
                    PurchaseBilling.CalcSums("Amount");
                    TOtalAmt := TOtalAmt + PurchaseBilling."Amount";


                    if (ABS(CustLedger."Remaining Amount") - (TOtalAmt + rec."Amount")) < 0 then
                        CustLedger.FieldError("Remaining Amount", strsubstno('remaining amount is %1', ABS(CustLedger."Remaining Amount" - TOtalAmt)));



                    TOtalAmt := TOtalAmt + rec.Amount;

                    PurchaseBillingHeader."Receive & Payment Amount" := TOtalAmt;
                    PurchaseBillingHeader.CalDiffAmt();
                    PurchaseBillingHeader.Modify();
                end;

                if rec."Document Type" = rec."Document Type"::"Sales Billing" then begin
                    if not CustLedger.GET(rec."Source Ledger Entry No.") then
                        CustLedger.Init();
                    CustLedger.CalcFields("Remaining Amount");

                    ltBillingLine.reset();
                    ltBillingLine.SetRange("Document Type", rec."Document Type");
                    ltBillingLine.SetRange("Document No.", rec."Document No.");
                    ltBillingLine.SetFilter("Line No.", '<>%1', rec."Line No.");
                    ltBillingLine.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");
                    ltBillingLine.CalcSums("Amount");
                    TOtalAmt := ltBillingLine."Amount";


                    ltBillingLine.reset();
                    ltBillingLine.SetRange("Document Type", rec."Document Type");
                    ltBillingLine.SetFilter("Document No.", '<>%1', rec."Document No.");
                    ltBillingLine.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");
                    ltBillingLine.CalcSums("Amount");
                    TOtalAmt := TOtalAmt + ltBillingLine."Amount";

                    if (ABS(CustLedger."Remaining Amount") - ABS((TOtalAmt + rec."Amount"))) < 0 then
                        CustLedger.FieldError("Remaining Amount", strsubstno('remaining amount is %1', ABS(CustLedger."Remaining Amount" - TOtalAmt)));

                end;

                rec.CalAmtExcludeVat();

            end;
        }
        field(20; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(21; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(22; "Source Currency Factor"; Decimal)
        {
            Caption = 'Source Currency Factor';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(23; "Status"; Enum "NCT Billing Receipt Status")
        {

            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("NCT Billing Receipt Header"."Status" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;

        }
        field(24; "Amount Exclude Vat"; Decimal)
        {
            Caption = 'Amount Exclude Vat';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(25; "Vat %"; Decimal)
        {
            Caption = 'Vat %';
            DataClassification = CustomerContent;
            Editable = false;
        }


    }
    keys
    {
        key("PK"; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        TestOpenStatus();
        CASE "Document Type" OF
            "Document Type"::"Sales Billing":
                if CustLedgEntry.GET("Source Ledger Entry No.") then begin
                    CustLedgEntry."NCT Aging Due Date" := CustLedgEntry."Due Date";
                    CustLedgEntry.MODIFY();
                end;
            "Document Type"::"Purchase Billing":
                if VendLedgEntry.GET("Source Ledger Entry No.") then begin
                    VendLedgEntry."NCT Aging Due Date" := VendLedgEntry."Due Date";
                    VendLedgEntry.MODIFY();
                end;

        END;
    end;

    trigger OnModify()
    begin
        TestOpenStatus();
    end;

    /// <summary>
    /// Description for TestOpenStatus.
    /// </summary>
    procedure CalAmtExcludeVat()
    begin
        "Amount Exclude Vat" := Round(Amount / (1 + (1 / 100) * "VAT %" / 100), 0.01);
    end;

    /// <summary> 
    /// Description for TestOpenStatus.
    /// </summary>
    local procedure TestOpenStatus()
    var
        BillingReceiptHrd: Record "NCT Billing Receipt Header";
    begin
        BillingReceiptHrd.GET("Document Type", "Document No.");
        BillingReceiptHrd.TESTFIELD("Status", BillingReceiptHrd."Status"::Open);
    end;

    /// <summary> 
    /// Description for FindLastLineNo.
    /// </summary>
    /// <returns>Return variable "Integer".</returns>
    procedure "FindLastLineNo"(): Integer
    var
        BillingLines: Record "NCT Billing Receipt Line";
    begin
        BillingLines.reset();
        BillingLines.SetCurrentKey("Document Type", "Document No.", "Line No.");
        BillingLines.SetRange("Document Type", "Document Type");
        BillingLines.SetRange("Document No.", "Document No.");
        if BillingLines.FindLast() then
            exit(BillingLines."Line No." + 10000);
        exit(10000);

    end;

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";

}