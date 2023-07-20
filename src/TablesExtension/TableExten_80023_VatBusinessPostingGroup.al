/// <summary>
/// TableExtension NCT VATBusinessPostingGroup (ID 80023) extends Record VAT Business Posting Group.
/// </summary>
tableextension 80023 "NCT VATBusinessPostingGroup" extends "VAT Business Posting Group"
{
    fields
    {
        field(80000; "NCT Company Name (Thai)"; Text[100])
        {
            Caption = 'Company Name (Thai)';
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Company Name 2 (Thai)"; Text[50])
        {
            Caption = 'Company Name 2 (Thai)';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Company Address (Thai)"; Text[100])
        {
            Caption = 'Company Address (Thai)';
            DataClassification = CustomerContent;
        }
        field(80003; "NCT Company Address 2 (Thai)"; Text[50])
        {
            Caption = 'Company Address 2 (Thai)';
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
                    if StrLen("NCT VAT Branch Code") < 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "NCT Head Office" := false;
                end;
                if "NCT VAT Branch Code" = '00000' then begin
                    "NCT Head Office" := TRUE;
                    "NCT VAT Branch Code" := '';

                end;

            end;
        }
        field(80006; "NCT VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80007; "NCT Phone No."; Text[20])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(80008; "NCT Fax No."; Text[20])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(80009; "NCT Email"; Text[100])
        {
            Caption = 'E-mail';
            DataClassification = CustomerContent;
        }
        field(80010; "NCT City (Thai)"; Text[30])
        {
            Caption = 'City (Thai)';
            DataClassification = CustomerContent;
        }
        field(80012; "NCT Post code"; Code[20])
        {
            Caption = 'Post code';
            DataClassification = CustomerContent;
        }

        field(80013; "NCT Company Name (Eng)"; Text[100])
        {
            Caption = 'Company Name (Eng)';
            DataClassification = CustomerContent;
        }
        field(80014; "NCT Company Name 2 (Eng)"; Text[50])
        {
            Caption = 'Company Name 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80015; "NCT Company Address (Eng)"; Text[100])
        {
            Caption = 'Company Address (Eng)';
            DataClassification = CustomerContent;
        }
        field(80016; "NCT Company Address 2 (Eng)"; Text[50])
        {
            Caption = 'Company Address 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80017; "NCT City (Eng)"; Text[30])
        {
            Caption = 'City (Eng)';
            DataClassification = CustomerContent;
        }

    }
}