/// <summary>
/// TableExtension NCT ExtenCustLedger Entry (ID 80036) extends Record Cust. Ledger Entry.
/// </summary>
tableextension 80036 "NCT ExtenCustLedger Entry" extends "Cust. Ledger Entry"
{
    fields
    {

        field(80000; "NCT Billing Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Billing Amount';
            Editable = false;
            CalcFormula = Sum("NCT Billing Receipt Line"."Amount" WHERE("Document Type" = filter('Sales Billing'),
             "Source Ledger Entry No." = FIELD("Entry No."), "Status" = filter(<> "Posted")));
        }


        field(80001; "NCT Receipt Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Receipt Amount';
            Editable = false;
            CalcFormula = Sum("NCT Billing Receipt Line"."Amount" WHERE("Document Type" = filter('Sales Receipt'),
             "Source Ledger Entry No." = FIELD("Entry No."), "Status" = filter(<> "Posted")));
        }
        field(80002; "NCT Remaining Amt."; Decimal)
        {
            Caption = 'Remaining Amt.';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(80003; "NCT Aging Due Date"; Date)
        {
            Editable = false;
            Caption = 'Aging Due Date';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT Head Office"; Boolean)
        {
            Caption = 'Header Office';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80005; "NCT VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80006; "NCT Billing Due Date"; date)
        {
            Caption = 'Billing Due Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "NCT Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "NCT Bank Code"; code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80009; "Bank Account No."; text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80010; "NCT Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80011; "NCT Cheque No."; code[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80012; "NCT Cheque Name"; Text[150])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80013; "NCT Cheque Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80014; "NCT Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
        }


    }
}