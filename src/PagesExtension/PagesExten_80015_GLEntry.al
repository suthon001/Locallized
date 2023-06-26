/// <summary>
/// PageExtension GLEntry (ID 80015) extends Record General Ledger Entries.
/// </summary>
pageextension 80015 "NCT GLEntry" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Journal Description"; Rec."NCT Journal Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies value of the field.';
            }

        }
        modify("External Document No.")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Journal Description"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
    }
}