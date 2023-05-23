/// <summary>
/// TableExtension VATBusinessPostingGroup (ID 80023) extends Record VAT Business Posting Group.
/// </summary>
tableextension 80023 VATBusinessPostingGroup extends "VAT Business Posting Group"
{
    fields
    {
        field(80000; "Company Name (Thai)"; Text[100])
        {
            Caption = 'Company Name (Thai)';
            DataClassification = CustomerContent;
        }
        field(80001; "Company Name 2 (Thai)"; Text[50])
        {
            Caption = 'Company Name 2 (Thai)';
            DataClassification = CustomerContent;
        }
        field(80002; "Company Address (Thai)"; Text[100])
        {
            Caption = 'Company Address (Thai)';
            DataClassification = CustomerContent;
        }
        field(80003; "Company Address 2 (Thai)"; Text[50])
        {
            Caption = 'Company Address 2 (Thai)';
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
                    if StrLen("Branch Code") < 5 then
                        Error('Branch Code must be 5 characters');
                    "Head Office" := false;
                end;
                if "Branch Code" = '00000' then begin
                    "Head Office" := TRUE;
                    "Branch Code" := '';

                end;

            end;
        }
        field(80006; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80007; "Phone No."; Text[20])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(80008; "Fax No."; Text[20])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(80009; "Email"; Text[100])
        {
            Caption = 'E-mail';
            DataClassification = CustomerContent;
        }
        field(80010; "City (Thai)"; Text[30])
        {
            Caption = 'City (Thai)';
            DataClassification = CustomerContent;
        }
        field(80012; "Post code"; Code[20])
        {
            Caption = 'Post code';
            DataClassification = CustomerContent;
        }

        field(80013; "Company Name (Eng)"; Text[100])
        {
            Caption = 'Company Name (Eng)';
            DataClassification = CustomerContent;
        }
        field(80014; "Company Name 2 (Eng)"; Text[50])
        {
            Caption = 'Company Name 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80015; "Company Address (Eng)"; Text[100])
        {
            Caption = 'Company Address (Eng)';
            DataClassification = CustomerContent;
        }
        field(80016; "Company Address 2 (Eng)"; Text[50])
        {
            Caption = 'Company Address 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80017; "City (Eng)"; Text[30])
        {
            Caption = 'City (Eng)';
            DataClassification = CustomerContent;
        }

    }
}