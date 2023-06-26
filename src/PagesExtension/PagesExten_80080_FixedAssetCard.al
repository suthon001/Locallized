/// <summary>
/// PageExtension FixedassetCard (ID 80080) extends Record Fixed Asset Card.
/// </summary>
pageextension 80080 "NCT FixedassetCard" extends "Fixed Asset Card"
{
    layout
    {
        addbefore("Last Date Modified")
        {
            field("Acq. Date"; rec."NCT Acq. Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Acq. Date field.';
            }
            field(Quantity; rec."NCT Quantity")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Quantity field.';
            }
        }
    }

    actions
    {
        addlast(Reporting)
        {

            action("Fixedsset Card")
            {
                ApplicationArea = All;
                Caption = 'Fixed Assed ';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Fixed Assed  action.';
                trigger OnAction()
                var
                    fixsset: Record "Fixed Asset";
                begin
                    //GenQRCode.GenerateQrBarcode(Database::"Fixed Asset", "No.", 0, Description, 200, 200, TRUE, 1);
                    //   Commit();
                    fixsset.RESET();
                    fixsset.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Fixed Asset Card", TRUE, TRUE, fixsset);
                end;
            }
        }
    }
}