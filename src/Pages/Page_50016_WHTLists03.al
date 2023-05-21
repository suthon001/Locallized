page 50016 "WHT Lists"
{

    PageType = List;
    SourceTable = "Tax Report Header";
    Caption = 'Withholding tax';
    CardPageId = "WHT Card";
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTableView = sorting("Tax Type", "Document No.") where("Tax Type" = filter(WHT03));
    layout
    {
        area(content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Year-Month"; Rec."Year-Month")
                {
                    ApplicationArea = All;
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = All;
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = All;
                }
                field("Status Lock"; Rec."Status Lock")
                {
                    ApplicationArea = All;
                }
                field("Total Base Amount"; Rec."Total Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
