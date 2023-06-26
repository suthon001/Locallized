/// <summary>
/// TableExtension NCT FAJournalLine (ID 80043) extends Record FA Journal Line.
/// </summary>
tableextension 80043 "NCT FAJournalLine" extends "FA Journal Line"
{
    fields
    {
        field(80000; "NCT Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(80001; "NCT Qty. Calculated"; Integer)
        {
            Caption = 'Qty. Calculated';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Qty. Phys. Inventory"; Integer)
        {
            Caption = 'Qty. Phys. Inventory';
            DataClassification = CustomerContent;
        }
        field(80003; "NCT Posted"; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80004; "NCT FA Phys. Location Code"; Code[20])
        {

            Caption = 'FA Phys. Location Code';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT FA Location Code"; Code[20])
        {

            Caption = 'FA Location Code';
            DataClassification = CustomerContent;
        }
        field(80006; "NCT Phys. Count Status"; Enum "NCT Phys. Count Status")
        {

            Caption = 'Phys. Count Status';
            DataClassification = CustomerContent;
        }





    }
    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldFaJournalLine">Parameter of type Record "FA Journal Line".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure "AssistEdit"(OldFaJournalLine: Record "FA Journal Line"): Boolean
    var
        FAJournalLine: Record "FA Journal Line";
        FaJournalBatch: Record "FA Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // WITH FAJournalLine DO BEGIN
        FAJournalLine.COPY(Rec);
        FaJournalBatch.GET(FAJournalLine."Journal Template Name", FAJournalLine."Journal Batch Name");
        FaJournalBatch.TESTFIELD("NCT Document No. Series");
        IF NoSeriesMgt.SelectSeries(FaJournalBatch."NCT Document No. Series", OldFaJournalLine."NCT Document No. Series",
            FAJournalLine."NCT Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(FAJournalLine."Document No.");
            Rec := FAJournalLine;
            EXIT(TRUE);
        END;
        //END;
    end;

}