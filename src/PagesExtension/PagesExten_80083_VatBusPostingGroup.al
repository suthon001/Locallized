/// <summary>
/// PageExtension NCT Vat Bus Posting Groups (ID 80083) extends Record VAT Business Posting Groups.
/// </summary>
pageextension 80083 "NCT Vat Bus Posting Groups" extends "VAT Business Posting Groups"
{

    layout
    {
        addafter(Description)
        {
            field("Company Name"; Rec."NCT Company Name (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Name (Thai)';
                ToolTip = 'Specifies the value of the Company Name (Thai) field.';
            }
            field("Company Name 2"; Rec."NCT Company Name 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Thai)';
                ToolTip = 'Specifies the value of the Company Name 2 (Thai) field.';
            }
            field("Company Address"; Rec."NCT Company Address (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Thai)';
                ToolTip = 'Specifies the value of the Company Address (Thai) field.';
            }
            field("Company Address 2"; Rec."NCT Company Address 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Thai)';
                ToolTip = 'Specifies the value of the Company Address 2 (Thai) field.';
            }
            field("City (Thai)"; Rec."NCT City (Thai)")
            {
                ApplicationArea = all;
                Caption = 'City (Thai)';
                ToolTip = 'Specifies the value of the City (Thai) field.';
            }
            field("Company Name (Eng)"; Rec."NCT Company Name (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name (Eng)';
                ToolTip = 'Specifies the value of the Company Name (Eng) field.';
            }
            field("Company Name 2 (Eng)"; Rec."NCT Company Name 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Eng)';
                ToolTip = 'Specifies the value of the Company Name 2 (Eng) field.';
            }
            field("Company Address (Eng)"; Rec."NCT Company Address (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Eng)';
                ToolTip = 'Specifies the value of the Company Address (Eng) field.';
            }
            field("Company Address 2 (Eng)"; Rec."NCT Company Address 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Eng)';
                ToolTip = 'Specifies the value of the Company Address 2 (Eng) field.';
            }
            field("City (Eng)"; Rec."NCT City (Eng)")
            {
                ApplicationArea = all;
                Caption = 'City (Eng)';
                ToolTip = 'Specifies the value of the City (Eng) field.';
            }
            field("Post code"; Rec."NCT Post code")
            {
                ApplicationArea = all;
                Caption = 'Post code';
                ToolTip = 'Specifies the value of the Post code field.';
            }
            field("Phone No."; Rec."NCT Phone No.")
            {
                ApplicationArea = all;
                Caption = 'Phone No.';
                ToolTip = 'Specifies the value of the Phone No. field.';
            }
            field("Fax No."; Rec."NCT Fax No.")
            {
                ApplicationArea = all;
                Caption = 'Fax No.';
                ToolTip = 'Specifies the value of the Fax No. field.';
            }
            field("Email"; Rec."NCT Email")
            {
                ApplicationArea = all;
                Caption = 'E-mail';
                ToolTip = 'Specifies the value of the E-mail field.';
            }
            field("Head Office"; Rec."NCT Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; Rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
            field("VAT Registration No."; Rec."NCT VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
        }
    }
}