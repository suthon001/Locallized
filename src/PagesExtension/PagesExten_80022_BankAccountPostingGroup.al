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