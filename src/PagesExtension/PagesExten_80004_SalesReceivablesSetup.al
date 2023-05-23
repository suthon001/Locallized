pageextension 80004 "ExtenSales&ReceSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Sale Billing Nos."; Rec."Sale Billing Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sale Billing Nos. field.';
            }
            field("Sale Receipt Nos."; Rec."Sale Receipt Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sale Receipt Nos. field.';
            }
            field("Sales VAT Nos."; rec."Sales VAT Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sales VAT Nos. field.';
            }

        }
    }
}