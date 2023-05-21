pageextension 80091 "GLAccountLists" extends "G/L Account List"
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
    }
}