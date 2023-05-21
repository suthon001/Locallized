pageextension 80085 GenjournalBatch extends "General Journal Batches"
{
    layout
    {
        addafter(Description)
        {
            field("Description TH Voucher"; rec."Description TH Voucher")
            {
                ApplicationArea = all;
            }
            field("Description EN Voucher"; rec."Description EN Voucher")
            {
                ApplicationArea = all;
            }

        }
        addafter("No. Series")
        {
            field("Document No. Series"; rec."Document No. Series")
            {
                ApplicationArea = all;
            }
        }
        modify("No. Series")
        {
            Visible = false;
        }
    }
}