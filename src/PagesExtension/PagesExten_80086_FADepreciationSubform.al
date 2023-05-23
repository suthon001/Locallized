pageextension 80086 "Depreciation Books Subform" extends "FA Depreciation Books Subform"
{
    layout
    {
        addafter("Straight-Line %")
        {
            field("Acquisition Cost"; rec."Acquisition Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the total acquisition cost for the fixed asset.';
            }
            field(Depreciation; rec.Depreciation)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the total depreciation for the fixed asset.';
            }
        }
        modify("Straight-Line %")
        {
            Visible = true;
        }
        moveafter("Depreciation Method"; "Straight-Line %")
    }
}