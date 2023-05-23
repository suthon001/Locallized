pageextension 80088 "BankAccountLists" extends "Bank Account List"
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