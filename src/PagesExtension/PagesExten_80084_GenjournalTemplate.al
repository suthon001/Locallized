pageextension 80084 GenjournalTemplate extends "General Journal Templates"
{
    layout
    {
        addafter(Description)
        {
            field("Description Eng"; rec."Description Eng")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description Eng field.';
            }
            field("Description Thai"; rec."Description Thai")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description Thai field.';
            }

        }
    }
}