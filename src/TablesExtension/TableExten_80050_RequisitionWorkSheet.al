/// <summary>
/// TableExtension NCT Requisition WorkSheet (ID 80049) extends Record Requisition Line.
/// </summary>
tableextension 80049 "NCT Requisition WorkSheet" extends "Requisition Line"
{
    fields
    {
        field(80000; "NCT Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80003; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "NCT PR No. Series"; Code[20])
        {
            Caption = 'PR No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldReqLines">Parameter of type Record "Requisition Line".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure "AssistEdit"(OldReqLines: Record "Requisition Line"): Boolean
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ReqWhs: Record "Requisition Wksh. Name";
        RequsitionLine: Record "Requisition Line";
    begin
        //  with RequsitionLine do begin
        RequsitionLine.Copy(Rec);
        ReqWhs.GET(RequsitionLine."Worksheet Template Name", RequsitionLine."Journal Batch Name");
        ReqWhs.TestField("NCT Document No. Series");
        IF NoSeriesMgt.SelectSeries(ReqWhs."NCT Document No. Series", OldReqLines."No. Series", RequsitionLine."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(RequsitionLine."NCT Document No.");
            rec := RequsitionLine;
            EXIT(TRUE);
        END;
        // end;
    end;

    trigger OnInsert()
    begin
        TestField("No.");
        "NCT Create By" := COPYSTR(UserId, 1, 50);
        "NCT Create DateTime" := CurrentDateTime();
    end;
}