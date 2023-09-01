/// <summary>
/// TableExtension NCT ExtenSalesReceivableSetup (ID 80004) extends Record Sales  Receivables Setup.
/// </summary>
tableextension 80004 "NCT ExtenSales&ReceivableSetup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(80000; "NCT Sale Billing Nos."; Code[20])
        {
            Caption = 'Sale Billing Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Sale Receipt Nos."; Code[20])
        {
            Caption = 'Sale Receipt Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Sales VAT Nos."; Code[20])
        {
            Caption = 'Sales VAT Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80003; "NCT Default Prepaid WHT Acc."; code[20])
        {
            Caption = 'Default Prepaid WHT Acc.';
            TableRelation = "G/L Account"."No." where(Blocked = const(false), "Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }

        field(80004; "NCT Default Bank Fee Acc."; code[20])
        {
            Caption = 'Default Bank Fee Acc.';
            TableRelation = "G/L Account"."No." where(Blocked = const(false), "Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }
        field(80005; "NCT Default Diff Amount Acc."; code[20])
        {
            Caption = 'Default Diff Amount Acc.';
            TableRelation = "G/L Account"."No." where(Blocked = const(false), "Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }
    }

}