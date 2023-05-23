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
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = all;
                Caption = 'Branch Code';
                ToolTip = 'Specifies the value of the Branch Code field.';
            }
        }
        addafter(Name)
        {
            field("Name (Eng)"; Rec."Name (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Name (Eng)';
                ToolTip = 'Specifies the value of the Name (Eng) field.';
            }
            field("Address (Eng)"; Rec."Address (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Address (Eng)';
                ToolTip = 'Specifies the value of the Address (Eng) field.';
            }
            field("Address 2 (Eng)"; Rec."Address 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Address 2 (Eng)';
                ToolTip = 'Specifies the value of the Address 2 (Eng) field.';
            }
        }
    }
}