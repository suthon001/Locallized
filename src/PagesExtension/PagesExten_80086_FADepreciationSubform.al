/// <summary>
/// PageExtension NCT Depreciation Books Subform (ID 80086) extends Record FA Depreciation Books Subform.
/// </summary>
pageextension 80086 "NCT Depreciation Books Subform" extends "FA Depreciation Books Subform"
{
    layout
    {
        modify("Straight-Line %")
        {
            Visible = true;
        }
        addafter("No. of Depreciation Years")
        {
            field("NCT No. of Years"; Rec."NCT No. of Years")
            {
                ApplicationArea = all;
                Caption = 'No. of Depreciation Years.';
                ToolTip = 'Specifies the value of the No. of Years field.';
            }
        }
        modify("No. of Depreciation Years")
        {
            Visible = false;
        }
        addafter("NCT No. of Years")
        {
            field("NCT Acquisition Cost"; Rec."Acquisition Cost")
            {
                ApplicationArea = all;
                Caption = 'Acquisition Cost';
                ToolTip = 'Specifies the total acquisition cost for the fixed asset.';
            }
            field("NCT Depreciation"; Rec.Depreciation)
            {
                ApplicationArea = all;
                Caption = 'Depreciation';
                ToolTip = 'Specifies the total depreciation for the fixed asset.';
            }
        }
        addafter(BookValue)
        {
            field("NCT Salvage Value"; Rec."Salvage Value")
            {
                ApplicationArea = all;
                Caption = 'Salvage Value';
                ToolTip = 'Specifies the estimated residual value of a fixed asset when it can no longer be used.';
            }
            field("NCT Proceeds on Disposal"; Rec."Proceeds on Disposal")
            {
                ApplicationArea = all;
                Caption = 'Proceeds on Disposal';
                ToolTip = 'Specifies the total proceeds on disposal for the fixed asset.';
            }
            field("NCT Gain/Loss"; Rec."Gain/Loss")
            {
                ApplicationArea = all;
                Caption = 'Gain/Loss';
                ToolTip = 'Specifies the total gain (credit) or loss (debit) for the fixed asset.';
            }

        }
    }
}
