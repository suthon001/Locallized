pageextension 80100 "NCT FA Depreciation Books" extends "FA Depreciation Books"
{
    layout
    {
        addbefore("No. of Depreciation Years")
        {
            field("NCT No. of Years"; Rec."NCT No. of Years")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the No. of Years field.';
            }
        }
        modify("No. of Depreciation Years")
        {
            Visible = false;
        }
    }
}
