/// <summary>
/// Page NCT WHT Business Posting Group (ID 80001).
/// </summary>
page 80001 "NCT WHT Business Posting Group"
{

    PageType = List;
    SourceTable = "NCT WHT Business Posting Group";
    ApplicationArea = all;
    UsageCategory = Administration;
    Caption = 'WHT Business Posting Group';
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
                field("WHT Type"; Rec."WHT Type")
                {
                    ApplicationArea = all;
                    Caption = 'WHT Type';
                    ToolTip = 'Specifies the value of the WHT Type field.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("WHT Certificate Option"; Rec."WHT Certificate Option")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Certificate Option';
                    ToolTip = 'Specifies the value of the WHT Certificate Option field.';
                }
                field("WHT Certificate No. Series"; Rec."WHT Certificate No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Certificate No. Series';
                    ToolTip = 'Specifies the value of the WHT Certificate No. Series field.';
                }
                field("WHT Account No."; Rec."WHT Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Account No.';
                    ToolTip = 'Specifies the value of the WHT Account No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Caption = 'Name 2';
                    ToolTip = 'Specifies the value of the Name 2 field.';
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    Caption = 'Head Office';
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Branch Code';
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Registration No.';
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
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
                    Image = Setup;
                    RunObject = page "NCT WHT Posting Setup";
                    RunPageLink = "WHT Bus. Posting Group" = field("Code");
                    ApplicationArea = all;
                    Caption = 'Posting Setup';
                    ToolTip = 'Executes the Posting Setup action.';

                }
            }
        }
    }

}
