/// <summary>
/// TableExtension NCT VatProductPostingGroup (ID 80024) extends Record VAT Product Posting Group.
/// </summary>
tableextension 80024 "NCT VatProductPostingGroup" extends "VAT Product Posting Group"
{
    fields
    {
        field(80000; "NCT Direct VAT"; Boolean)
        {
            Caption = 'Direct VAT';
            DataClassification = CustomerContent;
        }
    }
}