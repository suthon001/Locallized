pageextension 80080 FixedassetCard extends "Fixed Asset Card"
{
    layout
    {
        addbefore("Last Date Modified")
        {
            field("Acq. Date"; rec."Acq. Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Acq. Date field.';
            }
            field(Quantity; rec.Quantity)
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
                    Report.Run(Report::"Fixed Asset Card", TRUE, TRUE, fixsset);
                end;
            }
        }
    }
}