table 50003 "Customer & Vendor Branch"
{
    Caption = 'Customer & Vendor Branch';
    DrillDownPageId = "Cust. & Vendor BranchLists";
    LookupPageId = "Cust. & Vendor BranchLists";
    fields
    {
        field(1; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "Head Office"; boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "Branch Code" := '';
            end;

        }
        field(4; "Branch Code"; Code[5])
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
        field(5; "Name"; Text[160])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }

        field(6; "Address"; Text[160])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(7; "Title Name"; Text[50])
        {
            Caption = 'Title Name';
            DataClassification = CustomerContent;
        }
        field(8; "Building"; Text[100])
        {
            Caption = 'Building';
            DataClassification = CustomerContent;
        }
        field(9; "Alley/Lane"; Text[100])
        {
            Caption = 'ตรอก/ซอย';
            DataClassification = CustomerContent;
        }
        field(10; "Sub-district"; Text[100])
        {
            Caption = 'Sub-district';
            DataClassification = CustomerContent;
        }
        field(11; "District"; Text[100])
        {
            Caption = 'District';
            DataClassification = CustomerContent;
        }
        field(12; "Floor"; Text[10])
        {
            Caption = 'Floor';
            DataClassification = CustomerContent;
        }
        field(13; "House No."; Text[50])
        {
            Caption = 'House No.';
            DataClassification = CustomerContent;
        }
        field(14; "Village No."; Text[15])
        {
            Caption = 'Village No.';
            DataClassification = CustomerContent;
        }
        field(15; "Street"; Text[50])
        {
            Caption = 'Street';
            DataClassification = CustomerContent;
        }
        field(16; "Province"; Text[50])
        {
            Caption = 'Province';
            DataClassification = CustomerContent;
        }
        field(17; "Post Code"; code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(18; "No."; code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(19; "Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(20; "Contact"; Text[30])
        {
            Caption = 'Contact';
            DataClassification = CustomerContent;
        }
        field(21; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(22; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Source Type", "Source No.", "Head Office", "Branch Code")
        {
            Clustered = true;
        }
    }
}