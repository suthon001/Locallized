pageextension 80081 "Company Information" extends "Company Information"
{
    layout
    {
        addbefore("VAT Registration No.")
        {
            field("Head Office"; Rec."Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
                Caption = 'Branch Code';
            }
        }
        addafter(Name)
        {
            field("Name (Eng)"; Rec."Name (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Name (Eng)';
            }
            field("Address (Eng)"; Rec."Address (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Address (Eng)';
            }
            field("Address 2 (Eng)"; Rec."Address 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Address 2 (Eng)';
            }
        }
    }
}