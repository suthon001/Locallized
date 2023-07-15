pageextension 80101 "NCT Depreciation Book Card" extends "Depreciation Book Card"
{
    layout
    {
        addafter("Fiscal Year 365 Days")
        {
            field("NCT Fiscal Year 366 Days"; Rec."NCT Fiscal Year 366 Days")
            {
                Caption = 'Fiscal Year 366 Days';
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Fiscal Year 366 Days field.';
            }
            field("NCT No. of Days in Fiscal Year"; Rec."No. of Days in Fiscal Year")
            {
                ApplicationArea = all;
                Caption = 'No. of Days in Fiscal Year';
                ToolTip = 'Specifies the value of the No. of Days in Fiscal Year field.';
            }
        }
    }
}
