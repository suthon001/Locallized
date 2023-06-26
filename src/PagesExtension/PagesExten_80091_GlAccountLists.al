/// <summary>
/// PageExtension GLAccountLists (ID 80091) extends Record G/L Account List.
/// </summary>
pageextension 80091 "NCT GLAccountLists" extends "G/L Account List"
{
    layout
    {
        addafter(Name)
        {
            field("Search Name"; rec."Search Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
            }
        }
    }
}