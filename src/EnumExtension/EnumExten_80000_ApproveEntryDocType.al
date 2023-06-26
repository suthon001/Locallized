/// <summary>
/// EnumExtension NCT ApproveEntryDocType (ID 80000) extends Record Approval Document Type.
/// </summary>
enumextension 80000 "NCT ApproveEntryDocType" extends "Approval Document Type"
{
    value(80000; "NCT Item Journal")
    {
        Caption = 'Item Journal';
    }
    value(80001; "NCT Sales Billing")
    {
        Caption = 'Sales Billing';
    }
    value(80002; "NCT Sales Receipt")
    {
        Caption = 'Sales Receipt';
    }
    value(80003; "NCT Purchase Billing")
    {
        Caption = 'Purchase Billing';
    }

}