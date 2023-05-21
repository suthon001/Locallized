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
            }
            field("Company Name 2"; Rec."Company Name 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Thai)';
            }
            field("Company Address"; Rec."Company Address (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Thai)';
            }
            field("Company Address 2"; Rec."Company Address 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Thai)';
            }
            field("City (Thai)"; Rec."City (Thai)")
            {
                ApplicationArea = all;
                Caption = 'City (Thai)';
            }
            field("Company Name (Eng)"; Rec."Company Name (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name (Eng)';
            }
            field("Company Name 2 (Eng)"; Rec."Company Name 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Eng)';
            }
            field("Company Address (Eng)"; Rec."Company Address (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Eng)';
            }
            field("Company Address 2 (Eng)"; Rec."Company Address 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Eng)';
            }
            field("City (Eng)"; Rec."City (Eng)")
            {
                ApplicationArea = all;
                Caption = 'City (Eng)';
            }
            field("Postcode"; Rec."Postcode")
            {
                ApplicationArea = all;
                Caption = 'Post code';
            }
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = all;
                Caption = 'Phone No.';
            }
            field("Fax No."; Rec."Fax No.")
            {
                ApplicationArea = all;
                Caption = 'Fax No.';
            }
            field("Email"; Rec."Email")
            {
                ApplicationArea = all;
                Caption = 'E-mail';
            }
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
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
            }
        }
    }
}