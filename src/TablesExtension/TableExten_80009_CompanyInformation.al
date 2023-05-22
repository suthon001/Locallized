/// <summary>
/// TableExtension CompanyInformation (ID 80009) extends Record Company Information.
/// </summary>
tableextension 80009 CompanyInformation extends "Company Information"
{
    fields
    {
        field(80000; "Name (Eng)"; Text[100])
        {
            Caption = 'Name (Eng)';
            DataClassification = CustomerContent;
        }
        field(80001; "Name 2 (Eng)"; Text[50])
        {
            Caption = 'Name 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80002; "Address (Eng)"; Text[100])
        {
            Caption = 'Address (Eng)';
            DataClassification = CustomerContent;
        }
        field(80003; "Address 2 (Eng)"; Text[50])
        {
            Caption = 'Address 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80004; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "Branch Code" := '';
            end;

        }
        field(80005; "Branch Code"; code[5])
        {
            Caption = 'Branch Code';

            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "Branch Code" <> '' then begin
                    if StrLen("Branch Code") <> 5 then
                        Error('Branch Code must be 5 characters');
                    "Head Office" := false;
                end;
                if ("Branch Code" = '00000') OR ("Branch Code" = '') then begin
                    "Head Office" := TRUE;
                    "Branch Code" := '';
                end;
            end;
        }
        field(80006; "City (Eng)"; Text[50])
        {
            Caption = 'City (Eng)';
            DataClassification = CustomerContent;
        }
    }
}