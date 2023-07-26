/// <summary>
/// TableExtension NCT ExtenGeneral Ledger Setup (ID 80003) extends Record General Ledger Setup.
/// </summary>
tableextension 80003 "NCT ExtenGeneral Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(80000; "NCT No. of Copy WHT Cert."; Integer)
        {
            Caption = 'No. of Copy WHT Cert.';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(80002; "NCT WHT Certificate Caption 1"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 1';
            DataClassification = CustomerContent;
        }
        field(80003; "NCT WHT Certificate Caption 2"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 2';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT WHT Certificate Caption 3"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 3';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT WHT Certificate Caption 4"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 4';
            DataClassification = CustomerContent;
        }
        field(80006; "NCT WHT Document Nos."; Code[20])
        {
            Caption = 'WHT Document Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80007; "NCT Auto WHT Purchase Bill."; Boolean)
        {
            Caption = 'Auto WHT Purchase Bill.';
            TableRelation = "No. Series";
        }
        field(80008; "NCT Auto WHT Applies"; Boolean)
        {
            Caption = 'Auto WHT Applies';
            TableRelation = "No. Series";
        }
    }
}