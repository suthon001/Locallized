/// <summary>
/// PageExtension ExtenSalesReceSetup (ID 80004) extends Record Sales  Receivables Setup.
/// </summary>
pageextension 80004 "NCT ExtenSales & ReceSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Sale Billing Nos."; Rec."NCT Sale Billing Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sale Billing Nos. field.';
            }
            field("Sale Receipt Nos."; Rec."NCT Sale Receipt Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sale Receipt Nos. field.';
            }
            field("Sales VAT Nos."; rec."NCT Sales VAT Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sales VAT Nos. field.';
            }

        }
    }
}