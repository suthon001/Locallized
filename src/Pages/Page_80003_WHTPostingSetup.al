/// <summary>
/// Page NCT WHT Posting Setup (ID 80003).
/// </summary>
page 80003 "NCT WHT Posting Setup"
{

    PageType = List;
    SourceTable = "NCT WHT Posting Setup";
    Caption = 'WHT Posting Setup';
    UsageCategory = Administration;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("WHT Bus. Posting Group"; Rec."WHT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Bus. Posting Group';
                    ToolTip = 'Specifies the value of the WHT Bus. Posting Group field.';
                }
                field("WHT Prod. Posting Group"; Rec."WHT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Prod. Posting Group';
                    ToolTip = 'Specifies the value of the WHT Prod. Posting Group field.';
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = All;
                    Caption = 'WHT %';
                    ToolTip = 'Specifies the value of the WHT % field.';
                }

            }
        }
    }

}
