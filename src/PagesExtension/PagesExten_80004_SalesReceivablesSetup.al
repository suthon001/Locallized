/// <summary>
/// PageExtension ExtenSalesReceSetup (ID 80004) extends Record Sales Receivables Setup.
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
        addafter("Number Series")
        {
            group(SalesReceiptInformation)
            {
                Caption = 'Sales Receipt Information';
                field("NCT Default Prepaid WHT Acc."; rec."NCT Default Prepaid WHT Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Prepaid WHT Acc. field.';
                }
                field("NCT Default Bank Fee Acc."; rec."NCT Default Bank Fee Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Bank Fee Acc. field.';
                }
                field("NCT Default Diff Amount Acc."; rec."NCT Default Diff Amount Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Diff Amount Acc. field.';
                }
            }
        }
    }
}