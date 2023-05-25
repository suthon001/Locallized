/// <summary>
/// PageExtension ExtenPurchaPayablesSetup (ID 80005) extends Record Purchases Payables Setup.
/// </summary>
pageextension 80005 "ExtenPurchaPayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Purchase Billing Nos."; Rec."Purchase Billing Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Billing Nos. field.';
            }
            field("Purchase Receipt Nos."; Rec."Purchase Receipt Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Receipt Nos. field.';
            }
            field("Purchase VAT Nos."; rec."Purchase VAT Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase VAT Nos. field.';
            }
            field("WHT03 Nos."; rec."WHT03 Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT03 Nos. field.';
            }
            field("WHT53 Nos."; rec."WHT53 Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT53 Nos. field.';
            }
        }
    }
}