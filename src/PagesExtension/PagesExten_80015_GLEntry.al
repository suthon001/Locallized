pageextension 80015 "GLEntry" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Journal Description"; Rec."Journal Description")
            {
                ApplicationArea = All;
                Caption = 'Journal Description';
            }
            field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
            {
                ApplicationArea = all;
            }
        }
        modify("External Document No.")
        {
            Visible = true;
        }
    }
}