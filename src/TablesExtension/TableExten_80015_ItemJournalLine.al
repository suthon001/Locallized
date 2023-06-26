/// <summary>
/// TableExtension NCT ExtenItem Journal Line (ID 80015) extends Record Item Journal Line.
/// </summary>
tableextension 80015 "NCT ExtenItem Journal Line" extends "Item Journal Line"
{
    fields
    {

        field(80000; "NCT Status"; Enum "Purchase Document Status")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }

        field(80001; "NCT ID"; GUID)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80002; "NCT Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = SystemMetadata;
        }
        field(80003; "NCT Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT Vat Bus. Posting Group"; Code[20])
        {
            Caption = 'Vat Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(80005; "NCT Vendor/Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Vendor/Customer Name';
        }
        field(80006; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }



    trigger OnInsert()
    begin
        "NCT Create By" := COPYSTR(USERID, 1, 50);
        "NCT Create DateTime" := CurrentDateTime;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldItemJournalLine">Record "Item Journal Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldItemJournalLine: Record "Item Journal Line"): Boolean
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        ItemJournalLine.COPY(Rec);
        ItemJournalBatch.GET(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");
        ItemJournalBatch.TESTFIELD("NCT Document No. Series");
        IF NoSeriesMgt.SelectSeries(ItemJournalBatch."NCT Document No. Series", OldItemJournalLine."NCT Document No. Series",
            ItemJournalLine."NCT Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(ItemJournalLine."Document No.");
            Rec := ItemJournalLine;
            EXIT(TRUE);
        END;
    end;

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.reset();
        ItemJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        ItemJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if ItemJournalLine.FindLast() then
            exit(ItemJournalLine."Line No." + 10000);
        exit(10000);
    end;

}