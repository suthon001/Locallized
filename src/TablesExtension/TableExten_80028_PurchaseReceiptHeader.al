/// <summary>
/// TableExtension Purchase Rcpt. Header (ID 80028) extends Record Purch. Rcpt. Header.
/// </summary>
tableextension 80028 "Purchase Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(80000; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80002; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            TableRelation = "Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Buy-from Vendor No."));
            DataClassification = CustomerContent;
        }

        field(80003; "Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}