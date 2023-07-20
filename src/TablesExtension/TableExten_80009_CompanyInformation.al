/// <summary>
/// TableExtension NCT CompanyInformation (ID 80009) extends Record Company Information.
/// </summary>
tableextension 80009 "NCT CompanyInformation" extends "Company Information"
{
    fields
    {
        field(80000; "NCT Name (Eng)"; Text[100])
        {
            Caption = 'Name (Eng)';
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Name 2 (Eng)"; Text[50])
        {
            Caption = 'Name 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Address (Eng)"; Text[100])
        {
            Caption = 'Address (Eng)';
            DataClassification = CustomerContent;
        }
        field(80003; "NCT Address 2 (Eng)"; Text[50])
        {
            Caption = 'Address 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "NCT Head Office" then
                    "NCT VAT Branch Code" := '';
            end;

        }
        field(80005; "NCT VAT Branch Code"; code[5])
        {
            Caption = 'VAT Branch Code';

            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "NCT VAT Branch Code" <> '' then begin
                    if StrLen("NCT VAT Branch Code") <> 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "NCT Head Office" := false;
                end;
                if ("NCT VAT Branch Code" = '00000') OR ("NCT VAT Branch Code" = '') then begin
                    "NCT Head Office" := TRUE;
                    "NCT VAT Branch Code" := '';
                end;
            end;
        }
        field(80006; "NCT City (Eng)"; Text[50])
        {
            Caption = 'City (Eng)';
            DataClassification = CustomerContent;
        }
    }
}