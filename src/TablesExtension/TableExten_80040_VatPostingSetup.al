/// <summary>
/// TableExtension VatPostingSetup (ID 80040) extends Record VAT Posting Setup.
/// </summary>
tableextension 80040 "VatPostingSetup" extends "VAT Posting Setup"
{
    fields
    {
        field(80000; "Allow Generate to Sales Vat"; Boolean)
        {
            Caption = 'Allow Generate Sales Vat';
            DataClassification = CustomerContent;
        }
        field(80001; "Allow Generate to Purch. Vat"; Boolean)
        {
            Caption = 'Allow Generate Purch. Vat';
            DataClassification = CustomerContent;
        }
    }
}