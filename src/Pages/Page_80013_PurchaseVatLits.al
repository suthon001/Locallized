/// <summary>
/// Page Purchase Vat Lists (ID 80013).
/// </summary>
page 80013 "NCT Purchase Vat Lists"
{

    PageType = List;
    SourceTable = "NCT Tax Report Header";
    Caption = 'Purchase Vat';
    CardPageId = "NCT Purchase Vat Card";
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTableView = sorting("Tax Type", "Document No.") where("Tax Type" = filter(Purchase));
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
                field("Status Lock"; Rec."Status Lock")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Lock field.';
                }
                field("Vat Option"; Rec."Vat Option")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vat Option field.';
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
