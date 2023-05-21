pageextension 80086 "Depreciation Books Subform" extends "FA Depreciation Books Subform"
{
    layout
    {
        addafter("Straight-Line %")
        {
            field("Acquisition Cost"; rec."Acquisition Cost")
            {
                ApplicationArea = all;
            }
            field(Depreciation; rec.Depreciation)
            {
                ApplicationArea = all;
            }
        }
        modify("Straight-Line %")
        {
            Visible = true;
        }
        moveafter("Depreciation Method"; "Straight-Line %")
    }
}