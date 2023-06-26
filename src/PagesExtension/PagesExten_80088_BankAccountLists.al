/// <summary>
/// PageExtension NCT BankAccountLists (ID 80088) extends Record Bank Account List.
/// </summary>
pageextension 80088 "NCT BankAccountLists" extends "Bank Account List"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("Bank Branch No."; rec."Bank Branch No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies a number of the bank branch.';
            }
        }
    }
}