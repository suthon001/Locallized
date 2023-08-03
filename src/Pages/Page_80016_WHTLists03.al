/// <summary>
/// Page WHT Lists (ID 80016).
/// </summary>
page 80016 "NCT WHT Lists"
{

    PageType = List;
    SourceTable = "NCT Tax & WHT Header";
    Caption = 'WHT03 Lists';
    CardPageId = "NCT WHT Card";
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
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Year-Month"; Rec."Year-Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year-Month field.';
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Month Name field.';
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year No field.';
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Total Base Amount"; Rec."Total Base Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Base Amount field.';
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total VAT Amount field.';
                }
            }
        }
    }

}
