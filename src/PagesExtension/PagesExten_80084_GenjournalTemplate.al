pageextension 80084 GenjournalTemplate extends "General Journal Templates"
{
    layout
    {
        addafter(Description)
        {
            field("Description Eng"; rec."Description Eng")
            {
                ApplicationArea = all;
            }
            field("Description Thai"; rec."Description Thai")
            {
                ApplicationArea = all;
            }

        }
    }
}