pageextension 80006 "ExtenGeneralSetup" extends "General Ledger Setup"
{
    layout
    {
        addafter(General)
        {
            group("WHT Information")
            {
                Caption = 'WHT Information';

                field("No. of Copy WHT Cert."; Rec."No. of Copy WHT Cert.")
                {
                    ApplicationArea = all;
                }
                field("No. of Perpage"; Rec."No. of Perpage")
                {
                    ApplicationArea = all;

                }
                field("WHT Pre-Document Nos."; Rec."WHT Document Nos.")
                {
                    ApplicationArea = all;

                }
                field("WHT Certificate 1"; Rec."WHT Certificate Caption 1")
                {
                    ApplicationArea = all;

                }
                field("WHT Certificate 2"; Rec."WHT Certificate Caption 2")
                {
                    ApplicationArea = all;

                }
                field("WHT Certificate 3"; Rec."WHT Certificate Caption 3")
                {
                    ApplicationArea = all;

                }
                field("WHT Certificate 4"; Rec."WHT Certificate Caption 4")
                {
                    ApplicationArea = all;

                }

            }

        }
    }
}