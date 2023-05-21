tableextension 80037 "ExtenVendorLedger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(80000; "Completed Billing"; Boolean)
        {
            Editable = false;
            Caption = 'Completed Billing';
            DataClassification = SystemMetadata;
        }
        field(80001; "Billing Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Billing Amount';
            Editable = false;
            CalcFormula = Sum("Billing Receipt Line"."Amount" WHERE("Document Type" = filter('Purchase Billing'),
             "Source Ledger Entry No." = FIELD("Entry No.")));
        }
        field(80002; "Billing Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Billing Amount (LCY)';
            Editable = false;
            CalcFormula = Sum("Billing Receipt Line"."Amount (LCY)" WHERE("Document Type" = filter('Purchase Billing'),
             "Source Ledger Entry No." = FIELD("Entry No.")));
        }
        field(80003; "Aging Due Date"; Date)
        {
            Editable = false;
            Caption = 'Aging Due Date';
            DataClassification = SystemMetadata;
        }

        field(80004; "Head Office"; Boolean)
        {
            Caption = 'Header Office';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "Bank Name"; Text[150])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "Cheque No."; code[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80009; "Cheque Name"; Text[150])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80010; "Cheque Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80011; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80012; "Bank Code"; code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80013; "Bank Account No."; text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
    }
}