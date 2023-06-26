/// <summary>
/// TableExtension NCT ExtenVendorLedger Entry (ID 80037) extends Record Vendor Ledger Entry.
/// </summary>
tableextension 80037 "NCT ExtenVendorLedger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(80000; "NCT Completed Billing"; Boolean)
        {
            Editable = false;
            Caption = 'Completed Billing';
            DataClassification = SystemMetadata;
        }
        field(80001; "NCT Billing Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Billing Amount';
            Editable = false;
            CalcFormula = Sum("NCT Billing Receipt Line"."Amount" WHERE("Document Type" = filter('Purchase Billing'),
             "Source Ledger Entry No." = FIELD("Entry No.")));
        }
        field(80002; "Billing Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Billing Amount (LCY)';
            Editable = false;
            CalcFormula = Sum("NCT Billing Receipt Line"."Amount (LCY)" WHERE("Document Type" = filter('Purchase Billing'),
             "Source Ledger Entry No." = FIELD("Entry No.")));
        }
        field(80003; "NCT Aging Due Date"; Date)
        {
            Editable = false;
            Caption = 'Aging Due Date';
            DataClassification = SystemMetadata;
        }

        field(80004; "NCT Head Office"; Boolean)
        {
            Caption = 'Header Office';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "NCT Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "NCT Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "NCT Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "NCT Cheque No."; code[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80009; "NCT Cheque Name"; Text[150])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80010; "NCT Cheque Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80011; "NCT Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80012; "NCT Bank Code"; code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80013; "NCT Bank Account No."; text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
    }
}