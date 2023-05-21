tableextension 80024 VatProductPostingGroup extends "VAT Product Posting Group"
{
    fields
    {
        field(80000; "Direct VAT"; Boolean)
        {
            Caption = 'Direct VAT';
            DataClassification = CustomerContent;
        }
    }
}