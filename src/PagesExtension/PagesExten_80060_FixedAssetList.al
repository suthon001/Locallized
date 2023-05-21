pageextension 80060 "FixedAssetList" extends "Fixed Asset List"
{
    layout
    {
        addlast(Control1)
        {
            field("Quantity"; rec."Quantity")
            {
                ApplicationArea = all;
            }
            field("Price per Unit"; rec."Price per Unit")
            {
                ApplicationArea = all;
            }
            field("Remark Real Location"; rec."Remark Real Location")
            {
                ApplicationArea = all;
                Caption = 'Location Detail';
            }
        }
        addafter("Search Description")
        {
            field("Acq. Date"; rec."Acq. Date")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("FA Book Value")
        {
            Promoted = true;
            PromotedCategory = Report;
        }
        modify(Register)
        {
            Promoted = true;
            PromotedCategory = Report;
        }
        modify("G/L Analysis")
        {
            Promoted = true;
            PromotedCategory = Report;
        }
        addafter("Projected Value")
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
                    //  GenQRCode.GenerateQrBarcode(Database::"Fixed Asset", "No.", 0, Description, 200, 200, TRUE, 1);
                    Commit();
                    fixsset.RESET;
                    fixsset.SetRange("No.", rec."No.");
                    Report.Run(Report::"Fixed Asset Card", TRUE, TRUE, fixsset);
                end;
            }

            action("Fixed Asset - Book Value 01")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset - Book Value 01';
                Promoted = true;
                PromotedCategory = Report;
                Image = PrintReport;
                RunObject = Report "Fixed Asset - Book Value 01";
            }
            action("Fixed Asset - Book Value 02")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset - Book Value 02';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset - Book Value 02";
            }
            action("Fixed Asset Document Nos.")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Document Nos.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset Document Nos.";
            }
            action("FA Posting Group - Net Change")
            {
                ApplicationArea = All;
                Caption = 'FA Posting Group - Net Change';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "FA Posting Group - Net Change";
            }
            action("Fixed Asset Journal - Test")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Journal - Test';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset Journal - Test";
            }
            action("Fixed Asset Purchase")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Purchase';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset Purchase";
            }
            action("Fixed Asset Write off")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Write off';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset Write off";
            }
            action("Fixed Asset Sales")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Sales';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset Sales";
            }

        }
    }
}