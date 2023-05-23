/// <summary>
/// TableExtension FAPostingGroup (ID 80041) extends Record FA Posting Group.
/// </summary>
tableextension 80041 "FAPostingGroup" extends "FA Posting Group"
{
    fields
    {
        field(80000; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
}