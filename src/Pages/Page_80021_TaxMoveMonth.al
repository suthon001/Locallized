/// <summary>
/// Page Tax Move Month (ID 80021).
/// </summary>
page 80021 "NCT Tax Move Month"
{
    SourceTable = "NCT Tax Report Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;
    PageType = List;
    Caption = 'Tax - Move Month';
    SourceTableTemporary = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("Year-Month"; Rec."Year-Month")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Year-Month field.';
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Month Name field.';
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Year No field.';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            MoveLine();
    end;

    /// <summary> 
    /// Description for MoveLine.
    /// </summary>
    local procedure MoveLine()
    var
        TaxReportLine: Record "NCT Tax Report Line";
    begin


        if TaxLine.FindFirst() then
            repeat
                TaxReportLine.Init();
                TaxReportLine.TransferFields(TaxLine, false);
                TaxReportLine."Tax Type" := TaxLine."Tax Type";
                TaxReportLine."Document No." := Rec."Document No.";
                TaxReportLine."Entry No." := TaxReportLine."GetLastLineNo"();
                TaxReportLine.Insert();

                TaxLine.Delete();

            until TaxLine.next() = 0;

    end;

    /// <summary> 
    /// Description for SetData.
    /// </summary>
    /// <param name="EntryType">Parameter of type Option Purchase,Sale,WHT.</param>
    /// <param name="EndOfWork">Parameter of type Date.</param>
    /// <param name="OldTaxLine">Parameter of type Record "Tax Report Line".</param>
    procedure "SetData"(EntryType: Enum "NCT Tax Type"; EndOfWork: Date; var OldTaxLine: Record "NCT Tax Report Line")
    var
        TaxHeader: Record "NCT Tax Report Header";

    begin

        TaxLine.Copy(OldTaxLine);

        TaxHeader.reset();
        TaxHeader.SetRange("Tax Type", EntryType);
        TaxHeader.SetFilter("End date of Month", '<>%1', EndOfWork);
        if TaxHeader.FindFirst() then
            repeat
                Rec.Init();
                Rec.TransferFields(TaxHeader);
                Rec.Insert();
            until TaxHeader.Next() = 0;
        Rec.reset();
        Rec.SetCurrentKey("Tax Type", "Document No.");
    end;

    var

        TaxLine: Record "NCT Tax Report Line";
}