/// <summary>
/// PageExtension BankAccountPostingGroup (ID 80022) extends Record Bank Account Posting Groups.
/// </summary>
pageextension 80022 "BankAccountPostingGroup" extends "Bank Account Posting Groups"
{
    layout
    {
        addafter(Code)
        {
            field("Description"; Rec."Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description field.';
            }
        }

    }
}