/// <summary>
/// PageExtension NCT FA Ledger Entries (ID 80102) extends Record FA Ledger Entries.
/// </summary>
pageextension 80102 "NCT FA Ledger Entries" extends "FA Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No field.';
            }
        }
    }
}
