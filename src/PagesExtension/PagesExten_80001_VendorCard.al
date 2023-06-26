/// <summary>
/// PageExtension ExtenVendor Card (ID 80001) extends Record Vendor Card.
/// </summary>
pageextension 80001 "NCT ExtenVendor Card" extends "Vendor Card"
{

    layout
    {
        addlast(General)
        {

            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
            field("WHT Business Posting Group"; rec."WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
            }
            field("Head Office"; rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("Branch Code"; rec."NCT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Branch Code field.';
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