/// <summary>
/// PageExtension BankAccountPostingGroup (ID 80022) extends Record Bank Account Posting Groups.
/// </summary>
pageextension 80022 "NCT BankAccountPostingGroup" extends "Bank Account Posting Groups"
{
    layout
    {
        addafter(Code)
        {
            field("Description"; Rec."NCT Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description field.';
            }
        }

    }
}