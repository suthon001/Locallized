/// <summary>
/// PageExtension NCT FixedAssetList (ID 80060) extends Record Fixed Asset List.
/// </summary>
pageextension 80060 "NCT FixedAssetList" extends "Fixed Asset List"
{
    layout
    {
        addlast(Control1)
        {
            field("Quantity"; rec."NCT Quantity")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Quantity field.';
            }
            field("Price per Unit"; rec."NCT Price per Unit")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Price per Unit field.';
            }
            field("Remark Real Location"; rec."NCT Remark Real Location")
            {
                ApplicationArea = all;
                Caption = 'Location Detail';
                ToolTip = 'Specifies the value of the Location Detail field.';
            }
        }
        addafter("Search Description")
        {
            field("Acq. Date"; rec."NCT Acq. Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Acq. Date field.';
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
                ToolTip = 'Executes the Fixed Assed  action.';
                trigger OnAction()
                var
                    fixsset: Record "Fixed Asset";
                begin
                    //  GenQRCode.GenerateQrBarcode(Database::"Fixed Asset", "No.", 0, Description, 200, 200, TRUE, 1);
                    Commit();
                    fixsset.RESET();
                    fixsset.SetRange("No.", rec."No.");
                    Report.Run(Report::"NCT Fixed Asset Card", TRUE, TRUE, fixsset);
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
                ToolTip = 'Executes the Fixed Asset - Book Value 01 action.';
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
                ToolTip = 'Executes the Fixed Asset - Book Value 02 action.';
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
                ToolTip = 'Executes the Fixed Asset Document Nos. action.';
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
                ToolTip = 'Executes the FA Posting Group - Net Change action.';
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
                ToolTip = 'Executes the Fixed Asset Journal - Test action.';
            }
            action("Fixed Asset Purchase")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Purchase';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "NCT Fixed Asset Purchase";
                ToolTip = 'Executes the Fixed Asset Purchase action.';
            }
            action("Fixed Asset Write off")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Write off';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "NCT Fixed Asset Write off";
                ToolTip = 'Executes the Fixed Asset Write off action.';
            }
            action("Fixed Asset Sales")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Sales';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "NCT Fixed Asset Sales";
                ToolTip = 'Executes the Fixed Asset Sales action.';
            }

        }
    }
}