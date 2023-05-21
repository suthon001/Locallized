page 50029 "Sales Receipt Subform"
{

    PageType = ListPart;
    SourceTable = "Billing Receipt Line";
    Caption = 'Sales Receipt Subfrom';
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
                }
                field("Source Document Date"; Rec."Source Document Date")
                {
                    ApplicationArea = All;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                }
                field("Source Description"; Rec."Source Description")
                {
                    ApplicationArea = All;
                }

                field("Source Currency Code"; Rec."Source Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Source Due Date"; Rec."Source Due Date")
                {
                    ApplicationArea = All;
                }
                field("Source Amount"; Rec."Source Amount")
                {
                    ApplicationArea = All;
                }
                field("Source Amount (LCY)"; Rec."Source Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
