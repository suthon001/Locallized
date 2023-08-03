/// <summary>
/// PageExtension NCT GenjournalTemplate (ID 80084) extends Record General Journal Templates.
/// </summary>
pageextension 80084 "NCT GenjournalTemplate" extends "General Journal Templates"
{
    layout
    {
        addafter(Description)
        {
            field("Description Thai"; rec."NCT Description Thai")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description Thai field.';
            }

        }
    }
}