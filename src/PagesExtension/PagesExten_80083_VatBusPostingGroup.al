pageextension 80083 "Vat Business Posting Groups" extends "VAT Business Posting Groups"
{

    layout
    {
        addafter(Description)
        {
            field("Company Name"; Rec."Company Name (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Name (Thai)';
                ToolTip = 'Specifies the value of the Company Name (Thai) field.';
            }
            field("Company Name 2"; Rec."Company Name 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Thai)';
                ToolTip = 'Specifies the value of the Company Name 2 (Thai) field.';
            }
            field("Company Address"; Rec."Company Address (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Thai)';
                ToolTip = 'Specifies the value of the Company Address (Thai) field.';
            }
            field("Company Address 2"; Rec."Company Address 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Thai)';
                ToolTip = 'Specifies the value of the Company Address 2 (Thai) field.';
            }
            field("City (Thai)"; Rec."City (Thai)")
            {
                ApplicationArea = all;
                Caption = 'City (Thai)';
                ToolTip = 'Specifies the value of the City (Thai) field.';
            }
            field("Company Name (Eng)"; Rec."Company Name (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name (Eng)';
                ToolTip = 'Specifies the value of the Company Name (Eng) field.';
            }
            field("Company Name 2 (Eng)"; Rec."Company Name 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Eng)';
                ToolTip = 'Specifies the value of the Company Name 2 (Eng) field.';
            }
            field("Company Address (Eng)"; Rec."Company Address (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Eng)';
                ToolTip = 'Specifies the value of the Company Address (Eng) field.';
            }
            field("Company Address 2 (Eng)"; Rec."Company Address 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Eng)';
                ToolTip = 'Specifies the value of the Company Address 2 (Eng) field.';
            }
            field("City (Eng)"; Rec."City (Eng)")
            {
                ApplicationArea = all;
                Caption = 'City (Eng)';
                ToolTip = 'Specifies the value of the City (Eng) field.';
            }
            field("Postcode"; Rec."Postcode")
            {
                ApplicationArea = all;
                Caption = 'Post code';
                ToolTip = 'Specifies the value of the Post code field.';
            }
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = all;
                Caption = 'Phone No.';
                ToolTip = 'Specifies the value of the Phone No. field.';
            }
            field("Fax No."; Rec."Fax No.")
            {
                ApplicationArea = all;
                Caption = 'Fax No.';
                ToolTip = 'Specifies the value of the Fax No. field.';
            }
            field("Email"; Rec."Email")
            {
                ApplicationArea = all;
                Caption = 'E-mail';
                ToolTip = 'Specifies the value of the E-mail field.';
            }
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
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
        }
    }
}