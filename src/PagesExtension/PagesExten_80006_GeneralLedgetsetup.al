/// <summary>
/// PageExtension ExtenGeneralSetup (ID 80006) extends Record General Ledger Setup.
/// </summary>
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
                    ToolTip = 'Specifies the value of the No. of Copy WHT Cert. field.';
                }
                field("No. of Perpage"; Rec."No. of Perpage")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. of Perpage field.';
                }
                field("WHT Pre-Document Nos."; Rec."WHT Document Nos.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Document Nos. field.';
                }
                field("WHT Certificate 1"; Rec."WHT Certificate Caption 1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 1 field.';
                }
                field("WHT Certificate 2"; Rec."WHT Certificate Caption 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 2 field.';
                }
                field("WHT Certificate 3"; Rec."WHT Certificate Caption 3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 3 field.';
                }
                field("WHT Certificate 4"; Rec."WHT Certificate Caption 4")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 4 field.';
                }

            }

        }
    }
}