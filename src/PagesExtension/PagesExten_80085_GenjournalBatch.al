pageextension 80085 GenjournalBatch extends "General Journal Batches"
{
    layout
    {
        addafter(Description)
        {
            field("Description TH Voucher"; rec."Description TH Voucher")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description TH Voucher field.';
            }
            field("Description EN Voucher"; rec."Description EN Voucher")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description EN Voucher field.';
            }

        }
        addafter("No. Series")
        {
            field("Document No. Series"; rec."Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. Series field.';
            }
        }
        modify("No. Series")
        {
            Visible = false;
        }
    }
}