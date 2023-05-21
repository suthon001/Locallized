tableextension 80035 "Approve Entry" extends "Approval Entry"
{
    fields
    {
        field(80000; "Journal Template Name"; Code[30])
        {
            DataClassification = SystemMetadata;
            Editable = false;
            Caption = 'Journal Template Name';
        }
    }
}