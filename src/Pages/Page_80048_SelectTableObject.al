/// <summary>
/// Page NCT Select Table Object (ID 80048).
/// </summary>
page 80048 "NCT Select Table Object"
{
    ApplicationArea = All;
    Caption = 'Select Table Object';
    PageType = List;
    SourceTable = AllObjWithCaption;
    UsageCategory = Administration;
    ModifyAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies the object type.';
                }
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the object ID.';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the name of the object.';
                }
            }
        }
    }
}
