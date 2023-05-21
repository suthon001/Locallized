page 50002 "WHT Product Posting Group"
{

    PageType = List;
    SourceTable = "WHT Product Posting Group";
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
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("Sequence"; Rec."Sequence")
                {
                    ApplicationArea = All;
                    Caption = 'Sequence';
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
                    RunObject = page "WHT Posting Setup";
                    RunPageLink = "WHT Bus. Posting Group" = field("Code");
                    ApplicationArea = all;
                    Caption = 'WHT Posting Setup';
                }
            }
        }
    }

}
