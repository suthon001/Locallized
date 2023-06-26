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
    }
}