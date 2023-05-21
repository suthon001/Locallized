page 50001 "WHT Business Posting Group"
{

    PageType = List;
    SourceTable = "WHT Business Posting Group";
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
                }
                field("WHT Type"; Rec."WHT Type")
                {
                    ApplicationArea = all;
                    Caption = 'WHT Type';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("WHT Certificate Option"; Rec."WHT Certificate Option")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Certificate Option';
                }
                field("WHT Certificate No. Series"; Rec."WHT Certificate No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'WHT Certificate No. Series';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Caption = 'Name 2';
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    Caption = 'Head Office';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch Code';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Registration No.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account No.';
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
                    Caption = 'Posting Setup';
                }
            }
        }
    }

}
