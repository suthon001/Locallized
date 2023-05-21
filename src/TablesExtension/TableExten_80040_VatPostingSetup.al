tableextension 80040 "VatPostingSetup" extends "VAT Posting Setup"
{
    fields
    {


        field(80000; "Generate Sales Vat Report"; Boolean)
        {
            Caption = 'Generate Sales Vat Report';
            DataClassification = CustomerContent;
        }
        field(80001; "Generate Purch. Vat Report"; Boolean)
        {
            Caption = 'Generate Purch. Vat Report';
            DataClassification = CustomerContent;
        }
    }
}