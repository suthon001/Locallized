tableextension 80038 "ExtenBank Account Ledger" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(80000; "Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80001; "Bank Name"; Text[150])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80002; "Cheque No."; code[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80003; "Cheque Name"; Text[150])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80004; "Cheque Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80005; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = " ","Customer","Vendor";
            OptionCaption = ' ,Customer,Vendor';
        }
        field(80006; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "Bank Code"; code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
}