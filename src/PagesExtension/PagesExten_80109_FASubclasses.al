/// <summary>
/// PageExtension NCT FA Subclasses (ID 80109) extends Record FA Subclasses.
/// </summary>
pageextension 80109 "NCT FA Subclasses" extends "FA Subclasses"
{
    layout
    {
        addafter("Default FA Posting Group")
        {
            field("NCT No. of Depreciation Years"; Rec."NCT No. of Depreciation Years")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the No. of Depreciation Years field.';
            }
        }
    }
}
