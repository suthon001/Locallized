/// <summary>
/// TableExtension NCT Detailed Vendor Ledg.Entry (ID 80056) extends Record Detailed Vendor Ledg. Entry.
/// </summary>
tableextension 80056 "NCT Detailed Vendor Ledg.Entry" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        field(80000; "NCT Invoice Entry No."; Integer)
        {
            Caption = 'Invoice Entry Entry No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No." where("Document Type" = filter(Invoice), "Vendor Ledger Entry No." = field("Vendor Ledger Entry No.")));
        }
    }
}
