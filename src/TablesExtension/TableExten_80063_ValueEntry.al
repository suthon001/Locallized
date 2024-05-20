/// <summary>
/// TableExtension NCT Value Entry (ID 80063) extends Record Value Entry.
/// </summary>
tableextension 80063 "NCT Value Entry" extends "Value Entry"
{
    fields
    {
        field(80000; "NCT Ref. Document No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ref. Document No.';
            Editable = false;
        }
    }
}
