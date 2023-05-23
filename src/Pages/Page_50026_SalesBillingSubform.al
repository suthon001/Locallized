/// <summary>
/// Page Sales Billing Subform (ID 50026).
/// </summary>
page 50026 "Sales Billing Subform"
{

    PageType = ListPart;
    SourceTable = "Billing Receipt Line";
    Caption = 'Sales Billing Subfrom';
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Source Document Type"; Rec."Source Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Document Type field.';
                }
                field("Source Document Date"; Rec."Source Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Document Date field.';
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Document No. field.';
                }
                field("Source Description"; Rec."Source Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Description field.';
                }
                field("Source Currency Code"; Rec."Source Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Currency Code field.';
                }
                field("Source Due Date"; Rec."Source Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Due Date field.';
                }
                field("Source Amount"; Rec."Source Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Amount field.';
                }
                field("Source Amount (LCY)"; Rec."Source Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Amount (LCY) field.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                }
            }
        }
    }

}
