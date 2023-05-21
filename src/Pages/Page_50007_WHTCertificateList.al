page 50007 "WHT Certificate List"
{
    PageType = List;
    SourceTable = "WHT Header";
    CardPageId = "WHT Certificate";
    UsageCategory = Lists;
    ApplicationArea = all;
    Caption = 'WHT Certificate';

    layout
    {
        area(content)
        {
            repeater("Group")
            {
                Caption = 'Lists';
                field("WHT No."; Rec."WHT No.")
                {
                    ApplicationArea = all;
                }
                field("WHT Certificate No."; Rec."WHT Certificate No.")
                {
                    ApplicationArea = all;
                }
                field("Posted"; Rec."Posted")
                {
                    ApplicationArea = all;
                }


                field("WHT Source Type"; Rec."WHT Source Type")
                {
                    ApplicationArea = all;
                }
                field("WHT Source No."; Rec."WHT Source No.")
                {
                    ApplicationArea = all;
                }
                field("WHT Name"; Rec."WHT Name")
                {
                    ApplicationArea = all;
                }
                field("WHT Name 2"; Rec."WHT Name 2")
                {
                    ApplicationArea = all;
                }
                field("WHT Address"; Rec."WHT Address")
                {
                    ApplicationArea = all;
                }
                field("WHT Address 2"; Rec."WHT Address 2")
                {
                    ApplicationArea = all;
                }
                field("WHT City"; Rec."WHT City")
                {
                    ApplicationArea = all;
                }
                field("Wht Post Code"; Rec."Wht Post Code")
                {
                    ApplicationArea = all;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}