/// <summary>
/// Page NCT WHT Product Posting Group (ID 80002).
/// </summary>
page 80002 "NCT WHT Product Posting Group"
{

    PageType = List;
    SourceTable = "NCT WHT Product Posting Group";
    Caption = 'WHT Product Posting Group';
    UsageCategory = Administration;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Sequence"; Rec."Sequence")
                {
                    ApplicationArea = All;
                    Caption = 'Sequence';
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Setup")
            {
                Caption = '&Setup';
                Image = Setup;
                action("WHT Posting Setup")
                {
                    RunObject = page "NCT WHT Posting Setup";
                    RunPageLink = "WHT Bus. Posting Group" = field("Code");
                    ApplicationArea = all;
                    Caption = 'WHT Posting Setup';
                    ToolTip = 'Executes the WHT Posting Setup action.';
                    Image = Setup;
                }
            }
        }
    }

}
