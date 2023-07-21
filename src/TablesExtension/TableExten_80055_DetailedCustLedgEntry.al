tableextension 80055 "NCT Detailed Cust. Ledg. Entry" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(80000; "NCT Ref. Invoice_CN No."; Code[20])
        {
            Caption = 'Ref. Invoice_CN No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Detailed Cust. Ledg. Entry"."Document No." where("Document Type" = filter(Invoice | "Credit Memo"), "Cust. Ledger Entry No." = field("Cust. Ledger Entry No.")));
        }
    }
}
