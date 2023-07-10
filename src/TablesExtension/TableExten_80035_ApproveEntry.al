/// <summary>
/// TableExtension NCT Approve Entry (ID 80035) extends Record Approval Entry.
/// </summary>
tableextension 80035 "NCT Approve Entry" extends "Approval Entry"
{
    fields
    {
        field(80000; "Journal Template Name"; Code[10])
        {
            DataClassification = SystemMetadata;
            Editable = false;
            Caption = 'Journal Template Name';
        }
    }
}