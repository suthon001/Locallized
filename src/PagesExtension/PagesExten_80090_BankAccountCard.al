/// <summary>
/// PageExtension BankAccountCard (ID 80090) extends Record Bank Account Card.
/// </summary>
pageextension 80090 "NCT BankAccountCard" extends "Bank Account Card"
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