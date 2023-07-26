/// <summary>
/// Page NCT WHT Certificate List (ID 80007).
/// </summary>
page 80007 "NCT WHT Certificate List"
{
    PageType = List;
    SourceTable = "NCT WHT Header";
    CardPageId = "NCT WHT Certificate";
    SourceTableView = sorting("WHT No.") where(Posted = const(true));
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
                    ToolTip = 'Specifies the value of the WHT No. field.';
                }
                field("WHT Certificate No."; Rec."WHT Certificate No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate No field.';
                }
                field("Posted"; Rec."Posted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted field.';
                }


                field("WHT Source Type"; Rec."WHT Source Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Source Type field.';
                }
                field("WHT Source No."; Rec."WHT Source No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Source No. field.';
                }
                field("WHT Name"; Rec."WHT Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Name field.';
                }
                field("WHT Name 2"; Rec."WHT Name 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Name 2 field.';
                }
                field("WHT Address"; Rec."WHT Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Address field.';
                }
                field("WHT Address 2"; Rec."WHT Address 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Address 2 field.';
                }
                field("WHT City"; Rec."WHT City")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT City field.';
                }
                field("Wht Post Code"; Rec."Wht Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Wht Post Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT VAT Branch Code"; Rec."VAT VAT Branch Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT VAT Branch Code field.';
                }
            }
        }
    }
}