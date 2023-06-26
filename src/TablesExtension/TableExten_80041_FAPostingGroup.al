/// <summary>
/// TableExtension NCT FAPostingGroup (ID 80041) extends Record FA Posting Group.
/// </summary>
tableextension 80041 "NCT FAPostingGroup" extends "FA Posting Group"
{
    fields
    {
        field(80000; "NCT Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
}