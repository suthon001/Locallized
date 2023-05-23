pageextension 80021 "UserSetup" extends "User Setup"
{
    actions
    {
        addfirst(Processing)
        {
            group("Picture")
            {
                Caption = 'Picture';
                Image = Signature;
                action("Signature")
                {
                    Caption = 'Signature';
                    Promoted = true;
                    ApplicationArea = all;
                    PromotedCategory = Process;
                    RunObject = page "Signature";
                    RunPageLink = "User ID" = field("User ID");
                    ToolTip = 'Executes the Signature action.';
                }
            }
        }
    }
}