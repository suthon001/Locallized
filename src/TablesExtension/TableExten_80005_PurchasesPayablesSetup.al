/// <summary>
/// TableExtension NCT ExtenPurchaPayablesSetup (ID 80005) extends Record Purchases Payables Setup.
/// </summary>
tableextension 80005 "NCT ExtenPurcha&PayablesSetup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(80000; "NCT Purchase Billing Nos."; Code[20])
        {
            Caption = 'Purchase Billing Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Purchase Receipt Nos."; Code[20])
        {
            Caption = 'Purchase Receipt Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Purchase VAT Nos."; Code[20])
        {
            Caption = 'Purchase VAT Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80003; "NCT WHT Nos."; Code[20])
        {
            Caption = 'WHT Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80004; "NCT WHT03 Nos."; Code[20])
        {
            Caption = 'WHT03 Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80005; "NCT WHT53 Nos."; Code[20])
        {
            Caption = 'WHT53 Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
}