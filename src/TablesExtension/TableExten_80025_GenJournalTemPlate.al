/// <summary>
/// TableExtension GenJournalTemplat (ID 80025) extends Record Gen. Journal Template.
/// </summary>
tableextension 80025 GenJournalTemplat extends "Gen. Journal Template"
{
    fields
    {
        field(80000; "Description Eng"; Text[100])
        {

            Caption = 'Description Eng';
            DataClassification = CustomerContent;
        }
        field(80001; "Description Thai"; Text[100])
        {
            Caption = 'Description Thai';
            DataClassification = CustomerContent;
        }
    }
}