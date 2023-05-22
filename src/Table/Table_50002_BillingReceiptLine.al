/// <summary>
/// Table Billing Receipt Line (ID 50002).
/// </summary>
table 50002 "Billing Receipt Line"
{
    Caption = 'Billing & Receipt Line';
    Permissions = TableData 21 = rm, TableData 25 = rm;
    fields
    {
        field(1; "Document Type"; Enum "Billing Document Type")
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
                BillingReceiptLine: Record "Billing Receipt Line";
                SumBillAmt: Decimal;
                CurrencyFactor: Decimal;
            begin
                TestOpenStatus();
                CurrencyFactor := "Source Amount" / "Source Amount (LCY)";
                "Amount (LCY)" := "Amount" * CurrencyFactor;

                CLEAR(SumBillAmt);
                BillingReceiptLine.RESET();
                BillingReceiptLine.SETRANGE("Document Type", "Document Type");
                BillingReceiptLine.SETRANGE("Source Ledger Entry No.", "Source Ledger Entry No.");
                BillingReceiptLine.SETFILTER("Document No.", '<>%1', "Document No.");
                IF BillingReceiptLine.FIND('-') THEN begin
                    BillingReceiptLine.CalcSums("Amount");
                    SumBillAmt := BillingReceiptLine."Amount";
                end;

                CASE "Document Type" OF
                    "Document Type"::"Sales Billing", "Document Type"::"Sales Receipt":
                        IF ((SumBillAmt + "Amount") > "Source Amount") OR ("Amount" <= 0) THEN
                            ERROR(Text001Txt, "Source Amount" - SumBillAmt, "Source Document No.", "Source Posting Date", "Source Amount", SumBillAmt);
                    "Document Type"::"Purchase Billing":
                        IF ((SumBillAmt + "Amount") > "Source Amount") OR ("Amount" <= 0) THEN
                            ERROR(Text001Txt, "Source Amount" - SumBillAmt, "Source Document No.", "Source Posting Date", "Source Amount", SumBillAmt);

                END;
                SumBillAmt += "Amount";

                UpdateCustVendLedgStatus(SumBillAmt);
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


    }
    keys
    {
        key("PK"; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    /// <summary> 
    /// Description for UpdateCustVendLedgStatus.
    /// </summary>
    /// <param name="SumAmount">Parameter of type Decimal.</param>
    local procedure UpdateCustVendLedgStatus(SumAmount: Decimal)

    begin
        CASE "Document Type" OF
            "Document Type"::"Sales Billing", "Document Type"::"Sales Receipt":
                IF CustLedgEntry.GET("Source Ledger Entry No.") THEN BEGIN
                    CustLedgEntry.CALCFIELDS("Original Amount", "Original Amt. (LCY)", "Billing Amount", "Billing Amount (LCY)", "Receipt Amount", "Receipt Amount (LCY)");
                    IF "Document Type" = "Document Type"::"Sales Billing" THEN BEGIN
                        CustLedgEntry."Completed Billing" := (CustLedgEntry."Original Amount" - SumAmount) = 0;
                        CustLedgEntry.MODIFY();
                    END ELSE BEGIN
                        CustLedgEntry."Completed Receipt" := (CustLedgEntry."Original Amount" - SumAmount) = 0;
                        CustLedgEntry.MODIFY();
                    END;
                END;
            "Document Type"::"Purchase Billing":
                IF VendLedgEntry.GET("Source Ledger Entry No.") THEN BEGIN
                    VendLedgEntry.CALCFIELDS("Original Amount", "Original Amt. (LCY)");
                    VendLedgEntry."Completed Billing" := (VendLedgEntry."Original Amount" - SumAmount) = 0;
                    VendLedgEntry.MODIFY();
                END;
        END;
    end;

    trigger OnDelete()
    begin
        "TestOpenStatus"();
        CASE "Document Type" OF
            "Document Type"::"Sales Billing":

                if CustLedgEntry.GET("Source Ledger Entry No.") then begin
                    CustLedgEntry."Completed Billing" := FALSE;
                    CustLedgEntry."Aging Due Date" := CustLedgEntry."Due Date";
                    CustLedgEntry.MODIFY();
                end;
            "Document Type"::"Sales Receipt":
                if CustLedgEntry.GET("Source Ledger Entry No.") then begin
                    CustLedgEntry."Completed Receipt" := FALSE;
                    CustLedgEntry.MODIFY();
                end;
            "Document Type"::"Purchase Billing":
                if VendLedgEntry.GET("Source Ledger Entry No.") then begin
                    VendLedgEntry."Completed Billing" := FALSE;
                    VendLedgEntry."Aging Due Date" := VendLedgEntry."Due Date";
                    VendLedgEntry.MODIFY();
                end;

        END;
    end;

    trigger OnModify()
    begin
        "TestOpenStatus"();
    end;


    /// <summary> 
    /// Description for TestOpenStatus.
    /// </summary>
    local procedure "TestOpenStatus"()
    var
        BillingReceiptHrd: Record "Billing Receipt Header";
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
        BillingLines: Record "Billing Receipt Line";
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
        Text001Txt: Label 'You cannot issue more than %1.\Source Document No. %2 (%3)   \Amount %4   \Issued Amount %5.', Locked = true;
}