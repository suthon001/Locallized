pageextension 80090 "BankAccountCard" extends "Bank Account Card"
{
    layout
    {
        modify("Bank Branch No.")
        {
            Visible = true;
        }
        movebefore("Bank Account No."; "Bank Branch No.")
    }
}