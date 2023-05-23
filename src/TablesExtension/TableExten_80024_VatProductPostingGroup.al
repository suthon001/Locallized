/// <summary>
/// TableExtension VatProductPostingGroup (ID 80024) extends Record VAT Product Posting Group.
/// </summary>
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