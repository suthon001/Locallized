tableextension 80015 "ExtenItem Journal Line" extends "Item Journal Line"
{
    fields
    {

        field(80000; "Status"; Enum "Purchase Document Status")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }

        field(80001; "ID"; GUID)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80002; "Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = SystemMetadata;
        }
        field(80003; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(80004; "Vat Bus. Posting Group"; Code[20])
        {
            Caption = 'Vat Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(80005; "Vendor/Customer Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Vendor/Customer Name';
        }
        field(80006; "Create By"; Code[30])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }


    trigger OnDelete()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RecordId);
    end;

    trigger OnInsert()
    begin
        "Create By" := USERID;
        "Create DateTime" := CurrentDateTime;
    end;

    procedure "AssistEdit"(OldItemJournalLine: Record "Item Journal Line"): Boolean
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        ItemJournalLine.COPY(Rec);
        ItemJournalBatch.GET(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");
        ItemJournalBatch.TESTFIELD("Document No. Series");
        IF NoSeriesMgt.SelectSeries(ItemJournalBatch."Document No. Series", OldItemJournalLine."Document No. Series",
            ItemJournalLine."Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(ItemJournalLine."Document No.");
            Rec := ItemJournalLine;
            EXIT(TRUE);
        END;
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendITemJournalforApproval(var ItemJournal: Record "Item Journal Line");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelITemJournalLineforApproval(var ItemJournal: Record "Item Journal Line");
    begin
    end;

    /// <summary> 
    /// Description for IsItemJournalEnabled.
    /// </summary>
    /// <param name="ItemJournal">Parameter of type Record "Item Journal Line".</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure IsItemJournalEnabled(var ItemJournal: Record "Item Journal Line"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "Workflow";
    begin
        exit(WFMngt.CanExecuteWorkflow(ItemJournal, WFCode.RunWorkflowOnSendItemJournalLineApprovalCode()))
    end;

    /// <summary> 
    /// Description for CheckWorkflowEnabled.
    /// </summary>
    /// <param name="ItemJournal">Parameter of type Record "Item Journal Line".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure CheckWorkflowItemJournalEnabled(var ItemJournal: Record "Item Journal Line"): Boolean
    var
        NoWorkflowEnb: Label 'No workflow Enabled for this Record type';
    begin
        ItemJournal.TestField("Document No.");
        if not IsItemJournalEnabled(ItemJournal) then
            Error(NoWorkflowEnb);
        exit(true);
    end;

    procedure "GetLastLine"(): Integer
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.reset;
        ItemJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        ItemJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if ItemJournalLine.FindLast() then
            exit(ItemJournalLine."Line No." + 10000);
        exit(10000);
    end;

}