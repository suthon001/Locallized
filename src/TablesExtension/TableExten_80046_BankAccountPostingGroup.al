/// <summary>
/// TableExtension NCT BankAccPostingGroup (ID 80046) extends Record Bank Account Posting Group.
/// </summary>
tableextension 80046 "NCT BankAccPostingGroup" extends "Bank Account Posting Group"
{
    fields
    {
        field(80000; "NCT Description"; text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
}