/// <summary>
/// EnumExtension ApproveEntryDocType (ID 80000) extends Record Approval Document Type.
/// </summary>
enumextension 80000 "ApproveEntryDocType" extends "Approval Document Type"
{
    value(80000; "Item Journal")
    {
        Caption = 'Item Journal';
    }
    value(80001; "Sales Billing")
    {
        Caption = 'Sales Billing';
    }
    value(80002; "Sales Receipt")
    {
        Caption = 'Sales Receipt';
    }
    value(80003; "Purchase Billing")
    {
        Caption = 'Purchase Billing';
    }

}