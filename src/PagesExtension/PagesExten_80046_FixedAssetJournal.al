/// <summary>
/// PageExtension NCT FixedJournalLIne (ID 80046) extends Record Fixed Asset Journal.
/// </summary>
pageextension 80046 "NCT FixedJournalLIne" extends "Fixed Asset Journal"
{
    layout
    {

        addlast(Control1)
        {
            field("NCT Qty. Calculated"; rec."NCT Qty. Calculated")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Qty. Calculated field.';
            }
            field("NCT Qty. Phys. Inventory"; rec."NCT Qty. Phys. Inventory")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Qty. Phys. Inventory field.';
            }
            field("NCT Phys. Count Status"; rec."NCT Phys. Count Status")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Phys. Count Status field.';
            }
        }
        modify("Document No.")
        {
            trigger OnAssistEdit()
            begin

                if Rec."AssistEdit"(xRec) then
                    CurrPage.Update();

            end;
        }
        addafter("Document No.")
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
        }
    }
    actions
    {
        addafter("&Test Report")
        {
            action("NCT Test Report")
            {
                ApplicationArea = FixedAssets;
                Caption = '&Test Report';
                Ellipsis = true;
                Image = TestReport;
                ToolTip = 'Preview the resulting fixed asset entries to see the consequences before you perform the actual posting.';

                trigger OnAction()
                var
                    FAJnlLine: Record "FA Journal Line";
                begin
                    FAJnlLine.Copy(rec);
                    FAJnlLine.SetRange("Journal Template Name", FAJnlLine."Journal Template Name");
                    FAJnlLine.SetRange("Journal Batch Name", FAJnlLine."Journal Batch Name");
                    REPORT.Run(Report::"NCT Fixed Asset Journal - Test", true, false, FAJnlLine);
                end;
            }
        }
        modify("&Test Report")
        {
            Visible = false;
        }
    }
}