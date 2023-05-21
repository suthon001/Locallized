pageextension 80080 FixedassetCard extends "Fixed Asset Card"
{
    layout
    {
        addbefore("Last Date Modified")
        {
            field("Acq. Date"; rec."Acq. Date")
            {
                ApplicationArea = all;
            }
            field(Quantity; rec.Quantity)
            {
                ApplicationArea = all;
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
                trigger OnAction()
                var
                    fixsset: Record "Fixed Asset";
                    GenQRCode: Codeunit "Function Center";
                begin
                    //GenQRCode.GenerateQrBarcode(Database::"Fixed Asset", "No.", 0, Description, 200, 200, TRUE, 1);
                    //   Commit();
                    fixsset.RESET;
                    fixsset.SetRange("No.", rec."No.");
                    Report.Run(Report::"Fixed Asset Card", TRUE, TRUE, fixsset);
                end;
            }
        }
    }
}