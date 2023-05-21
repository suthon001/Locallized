pageextension 80026 "ChartOfAccount" extends "Chart of Accounts"
{
    layout
    {
        addafter(Name)
        {
            field("Search Name"; rec."Search Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Direct Posting")
        {
            Visible = true;
        }
        moveafter(Name; "Direct Posting")
        addafter("Direct Posting")
        {
            field(Blocked; rec.Blocked)
            {
                ApplicationArea = all;
            }
        }
    }
}