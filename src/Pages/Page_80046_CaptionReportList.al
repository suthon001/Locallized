/// <summary>
/// Page NCT Caption Report List (ID 80034).
/// </summary>
page 80046 "NCT Caption Report List"
{
    ApplicationArea = All;
    Caption = 'Caption Report List';
    PageType = List;
    SourceTable = "NCT Caption Report Setup";
    UsageCategory = Administration;
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the "Document Type" field.';
                    ApplicationArea = All;
                }
                field("Name (Thai)"; Rec."Name (Thai)")
                {
                    ToolTip = 'Specifies the value of the Name (Thai) field.';
                    ApplicationArea = All;
                }
                field("Name (Eng)"; Rec."Name (Eng)")
                {
                    ToolTip = 'Specifies the value of the Name (Eng) field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
