tableextension 80003 "ExtenGeneral Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(80000; "No. of Copy WHT Cert."; Integer)
        {
            Caption = 'No. of Copy WHT Cert.';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(80001; "No. of Perpage"; Integer)
        {
            Caption = 'No. of Perpage';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(80002; "WHT Certificate Caption 1"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 1';
            DataClassification = CustomerContent;
        }
        field(80003; "WHT Certificate Caption 2"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 2';
            DataClassification = CustomerContent;
        }
        field(80004; "WHT Certificate Caption 3"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 3';
            DataClassification = CustomerContent;
        }
        field(80005; "WHT Certificate Caption 4"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 4';
            DataClassification = CustomerContent;
        }
        field(80006; "WHT Document Nos."; Code[20])
        {
            Caption = 'WHT Document Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
}