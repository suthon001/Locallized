pageextension 80001 "ExtenVendor Card" extends "Vendor Card"
{

    layout
    {
        addlast(General)
        {

            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
            field("WHT Business Posting Group"; rec."WHT Business Posting Group")
            {
                ApplicationArea = all;
            }
            field("Head Office"; rec."Head Office")
            {
                ApplicationArea = all;
            }
            field("Branch Code"; rec."Branch Code")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Branch Code"; "VAT Registration No.")
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;
        }
    }

}