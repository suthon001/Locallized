tableextension 80007 "ExtenItem Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {

        field(80000; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(80001; "Cost Amount (Stock)"; Decimal)
        {
            Caption = 'Cost Amount (Stock)';
            DataClassification = SystemMetadata;
        }
        field(80002; "Cost Amount (Actual Cal.)"; Decimal)
        {
            Caption = 'Cost Amount (Actual Cal.)';
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Entry No."), "Posting Date" = FIELD("Date Filter")));
        }
        field(80003; "Charge Item Ledg.Entry No."; Integer)
        {
            Caption = 'Charge Item Ledger Entry No.';
            DataClassification = SystemMetadata;
        }
        field(80004; "Invoice No."; Code[30])
        {
            Caption = 'Invoice No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80005; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group".Code;
            DataClassification = SystemMetadata;
        }
        field(80006; "Ref. Entry No."; Integer)
        {
            Caption = 'Ref. Entry No.';
            DataClassification = SystemMetadata;
        }
        field(80007; "Vat Bus. Posting Group"; Code[20])
        {
            Caption = 'Vat Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(80008; "Vendor/Customer Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Vendor/Customer Name';
        }
        field(80009; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bin Code';
        }
        field(80010; "Document Invoice No."; Code[30])
        {
            Caption = 'Document Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Value Entry"."Document No." WHERE("Item Ledger Entry No." = field("Entry No."), "Document Type" = filter("Sales Invoice" | "Purchase Invoice")));
        }

    }
}