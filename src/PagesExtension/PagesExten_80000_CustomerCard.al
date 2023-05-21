pageextension 80000 "ExtenCustomer Card" extends "Customer Card"
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
                trigger OnAction()
                var
                    OutSteam: OutStream;
                    InSteam: InStream;
                    TempBlob: Codeunit "Temp Blob";
                    gvFileName: Text;
                begin
                    MESSAGE('%1 %2', DMY2Date(1, 1, 2022), CalcDate('<CM>', DMY2Date(1, 1, 2022)));

                end;
            }
        }
    }
}