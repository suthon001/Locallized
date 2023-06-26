/// <summary>
/// TableExtension NCT VatPostingSetup (ID 80040) extends Record VAT Posting Setup.
/// </summary>
tableextension 80040 "NCT VatPostingSetup" extends "VAT Posting Setup"
{
    fields
    {
        field(80000; "NCT Allow to Sales Vat"; Boolean)
        {
            Caption = 'Allow Generate Sales Vat';
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Allow to Purch. Vat"; Boolean)
        {
            Caption = 'Allow Generate Purch. Vat';
            DataClassification = CustomerContent;
        }
    }
}