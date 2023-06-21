/// <summary>
/// PageExtension Accounting Periods (ID 80092) extends Record Accounting Periods.
/// </summary>
pageextension 80092 "Accounting Periods" extends "Accounting Periods"
{
    actions
    {
        addafter("&Create Year")
        {
            action(ClearYears)
            {
                Caption = 'Clear Close Year';
                Image = CloseYear;
                ToolTip = 'Executes the Clear Close Year action.';
                ApplicationArea = Basic, Suite;
                trigger OnAction()
                begin
                    rec.Closed := false;
                    rec."Date Locked" := false;
                    rec.Modify();
                end;
            }
        }
    }
}
