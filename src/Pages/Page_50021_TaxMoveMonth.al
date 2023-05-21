page 50021 "Tax Move Month"
{
    SourceTable = "Tax Report Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;
    PageType = List;
    Caption = 'Tax - Move Month';
    SourceTableTemporary = true;
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
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = all;
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            "MoveLine"();
    end;

    /// <summary> 
    /// Description for MoveLine.
    /// </summary>
    local procedure "MoveLine"()
    var
        TaxReportLine: Record "Tax Report Line";
        TaxReportLineOld: Record "Tax Report Line";
        NewEntryNo: Integer;
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

            until TaxLine.next = 0;

    end;

    /// <summary> 
    /// Description for SetData.
    /// </summary>
    /// <param name="EntryType">Parameter of type Option Purchase,Sale,WHT.</param>
    /// <param name="EndOfWork">Parameter of type Date.</param>
    /// <param name="OldTaxLine">Parameter of type Record "Tax Report Line".</param>
    procedure "SetData"(EntryType: Option Purchase,Sale,WHT; EndOfWork: Date; var OldTaxLine: Record "Tax Report Line")
    var
        TaxHeader: Record "Tax Report Header";

    begin

        TaxLine.Copy(OldTaxLine);

        TaxHeader.reset;
        TaxHeader.SetRange("Tax Type", EntryType);
        TaxHeader.SetFilter("End date of Month", '<>%1', EndOfWork);
        if TaxHeader.FindFirst() then
            repeat
                Rec.Init();
                Rec.TransferFields(TaxHeader);
                Rec.Insert();
            until TaxHeader.Next() = 0;
        Rec.reset;
        Rec.SetCurrentKey("Tax Type", "Document No.");
    end;

    var

        TaxLine: Record "Tax Report Line";
}