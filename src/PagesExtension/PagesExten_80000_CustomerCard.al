/// <summary>
/// PageExtension ExtenCustomer Card (ID 80000) extends Record Customer Card.
/// </summary>
pageextension 80000 "NCT ExtenCustomer Card" extends "Customer Card"
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
            field("NCT WHT Business Posting Group"; rec."NCT WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                ShowMandatory = true;
            }
            field("Head Office"; rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;
        }

    }

    actions
    {
        addafter("&Customer")
        {
            action(TEST)
            {
                Image = TestDatabase;
                ApplicationArea = all;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Caption = 'TEST';
                ToolTip = 'Executes the TEST action.';
                trigger OnAction()
                begin
                    MESSAGE('%1 %2', DMY2Date(1, 1, 2022), CalcDate('<CM>', DMY2Date(1, 1, 2022)));

                end;
            }
        }
    }
}