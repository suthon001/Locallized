codeunit 50006 "Workflow"
{


    var
        WFMngt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        SendItemJournalReq: Label 'Approval Request for Item Journal Line is requested';
        CancelReqItemJournal: Label 'Approval of a Item Journal Line is canceled';
        ItemJournalLineTypeCondTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Item Journal Line">%1</DataItem></DataItems></ReportParameters>';


    procedure RunWorkflowOnSendItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendItemJournalLineApproval'))
    end;



    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnSendITemJournalforApproval', '', false, false)]
    procedure RunWorkflowOnSendItemJournalApproval(var ItemJournal: Record "Item Journal Line")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendItemJournalLineApprovalCode(), ItemJournal);
    end;



    procedure RunWorkflowOnCancelItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelItemJournalLineApproval'))
    end;



    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnCancelITemJournalLineforApproval', '', false, false)]
    procedure OnCancelITemJournalLineforApproval(var ItemJournal: Record "Item Journal Line")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelItemJournalLineApprovalCode(), ItemJournal);
    end;




    procedure RunWorkflowOnApproveItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveItemJournalLineApproval'))
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    procedure RunWorkflowOnApproveItemJournalApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"Item Journal Line" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveItemJournalLineApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;




    procedure RunWorkflowOnRejectItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectItemJournalLineApproval'))
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    procedure RunWorkflowOnRejectApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"Item Journal Line" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectItemJournalLineApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    procedure RunWorkflowOnDelegateItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateItemJournalLineApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    procedure RunWorkflowOnDelegateApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"Item Journal Line" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateItemJournalLineApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure "OnSetStatusToPendingApproval"(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean);
    var
        ItemJournalLines, ItemJournalLines2 : Record "Item Journal Line";

    begin
        case RecRef.Number of
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournalLines);
                    ItemJournalLines2.reset();
                    ItemJournalLines2.SetRange("Journal Template Name", ItemJournalLines."Journal Template Name");
                    ItemJournalLines2.SetRange("Journal Batch Name", ItemJournalLines."Journal Batch Name");
                    ItemJournalLines2.SetRange("Document No.", ItemJournalLines."Document No.");
                    if ItemJournalLines2.FindSet() then
                        ItemJournalLines2.ModifyAll("Status", ItemJournalLines2."Status"::"Pending Approval");

                    IsHandled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure "OnReleaseDocument"(RecRef: RecordRef; var Handled: Boolean);
    var
        ItemJournalLines, ItemJournalLines2 : Record "Item Journal Line";

    begin
        case RecRef.Number of
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournalLines);
                    ItemJournalLines2.reset();
                    ItemJournalLines2.SetRange("Journal Template Name", ItemJournalLines."Journal Template Name");
                    ItemJournalLines2.SetRange("Journal Batch Name", ItemJournalLines."Journal Batch Name");
                    ItemJournalLines2.SetRange("Document No.", ItemJournalLines."Document No.");
                    if ItemJournalLines2.FindSet() then
                        ItemJournalLines2.ModifyAll("Status", ItemJournalLines2."Status"::Released);

                end;
        end;
        Handled := true;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean);
    var
        ItemJournalLines, ItemJournalLines2 : Record "Item Journal Line";

    begin
        case RecRef.Number of
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournalLines);
                    ItemJournalLines2.reset();
                    ItemJournalLines2.SetRange("Journal Template Name", ItemJournalLines."Journal Template Name");
                    ItemJournalLines2.SetRange("Journal Batch Name", ItemJournalLines."Journal Batch Name");
                    ItemJournalLines2.SetRange("Document No.", ItemJournalLines."Document No.");
                    if ItemJournalLines2.FindSet() then
                        ItemJournalLines2.ModifyAll("Status", ItemJournalLines2."Status"::Open);

                    Handled := true;
                END;
        end;
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure "AddItemJournalEventToLibrary"()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendItemJournalLineApprovalCode(), Database::"Item Journal Line", SendItemJournalReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelItemJournalLineApprovalCode(), Database::"Item Journal Line", CancelReqItemJournal, 0, false);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]

    local procedure "OnPopulateApprovalEntryArgument"(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance");
    var
        ItemJournal: Record "Item Journal Line";
    begin
        case RecRef.Number OF
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournal);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Item Journal";
                    ApprovalEntryArgument."Document No." := ItemJournal."Document No.";
                    ApprovalEntryArgument.Amount := ItemJournal.Amount;
                    ApprovalEntryArgument."Journal Template Name" := ItemJournal."Journal Template Name";
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', false, false)]
    local procedure "OnAfterGetPageID"(RecordRef: RecordRef; var PageID: Integer)

    begin
        if (PageID = 0) and (RecordRef.Number = Database::"Item journal Line") then
            PageID := Page::"Item Journal Lines";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure "OnGetDocumentTypeAndNumber"(var RecRef: RecordRef; var IsHandled: Boolean; var DocumentNo: Text; var DocumentType: Text);
    var
        FieldRef: FieldRef;
    begin
        IF RecRef.Number = DATABASE::"Item Journal Line" then begin
            DocumentType := RecRef.Caption;
            FieldRef := RecRef.Field(1);
            DocumentNo := Format(FieldRef.Value);
            FieldRef := RecRef.Field(41);
            DocumentNo += ',' + Format(FieldRef.Value);
            FieldRef := RecRef.Field(2);
            DocumentNo += ',' + Format(FieldRef.Value);
            IsHandled := true;
        end;


    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure "OnAddWorkflowCategoriesToLibrary"();
    var
        workflowSetup: Codeunit "Workflow Setup";
    begin
        workflowSetup.InsertWorkflowCategory('ITEMJOURNAL', 'Item Journal Workflow');

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInitWorkflowTemplates', '', false, false)]
    local procedure "OnAfterInitWorkflowTemplates"()
    var
        Workflow: Record Workflow;
    begin
        Workflow.SetRange(Category, 'ITEMJOURNAL');
        Workflow.SetRange(Template, true);
        if Workflow.IsEmpty then
            "InsertWorkflowItemJournalLineTemplate"();

    end;

    local procedure "InsertWorkflowItemJournalLineTemplate"()
    var
        ApprovalEntry: Record "Approval Entry";
        Workflow: Record 1501;
        workflowSetup: Codeunit "Workflow Setup";
        workflowwebhook: Record "Workflow Webhook Entry";
    begin
        workflowSetup.InsertTableRelation(Database::"Item Journal Line", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        workflowSetup.InsertTableRelation(Database::"Item Journal Line", 80005, Database::"Workflow Webhook Entry", workflowwebhook.FieldNo("Data ID"));

        workflowSetup.InsertWorkflowTemplate(Workflow, 'ITEMJOURNAL', 'Item Journal Workflow', 'ITEMJOURNAL');
        "InsertItemJournalDetailWOrkflow"(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure "InsertItemJournalDetailWOrkflow"(var workflow: Record 1501)
    var
        WorkflowSetpArgument: Record 1523;
        blankDateFormula: DateFormula;
        ItemJournalLine: Record "Item Journal Line";
        WorkflowSetup: Codeunit "Workflow Setup";

    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      "BuildItemJournalLineCondiftion"(ItemJournalLine."Status"::Open),
      RunWorkflowOnSendItemJournalLineApprovalCode(),
       "BuildItemJournalLineCondiftion"(ItemJournalLine."Status"::"Pending Approval"),
       RunWorkflowOnCancelItemJournalLineApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowEventPredecessorsToLibrary"(EventFunctionName: Code[128]);
    var
        WorkflowEventHadning: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            RunWorkflowOnCancelItemJournalLineApprovalCode():


                WorkflowEventHadning.AddEventPredecessor(RunWorkflowOnCancelItemJournalLineApprovalCode(), RunWorkflowOnSendItemJournalLineApprovalCode());
            WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode():


                WorkflowEventHadning.AddEventPredecessor(WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendItemJournalLineApprovalCode());

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowResponsePredecessorsToLibrary"(ResponseFunctionName: Code[128]);
    var
        WorkflowResponseHanding: Codeunit 1521;
    begin
        case ResponseFunctionName of

            WorkflowResponseHanding.SetStatusToPendingApprovalCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SetStatusToPendingApprovalCode(),
                RunWorkflowOnSendItemJournalLineApprovalCode());
            WorkflowResponseHanding.SendApprovalRequestForApprovalCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SendApprovalRequestForApprovalCode(),
                RunWorkflowOnSendItemJournalLineApprovalCode());
            WorkflowResponseHanding.RejectAllApprovalRequestsCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.RejectAllApprovalRequestsCode(),
                RunWorkflowOnRejectItemJournalLineApprovalCode());
            WorkflowResponseHanding.CancelAllApprovalRequestsCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.CancelAllApprovalRequestsCode(),
                RunWorkflowOnCancelItemJournalLineApprovalCode());
            WorkflowResponseHanding.OpenDocumentCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.OpenDocumentCode(),
                RunWorkflowOnCancelItemJournalLineApprovalCode());
        end;

    end;

    local procedure "BuildItemJournalLineCondiftion"(Status: Enum "Sales Document Status"):
                                Text
    var
        ItemJournalLine: Record "Item Journal Line";
        workflowSetup:
                Codeunit "Workflow Setup";
    begin
        ItemJournalLine.SetRange("Status", Status);
        EXIT(StrSubstNo(ItemJournalLineTypeCondTxt, workflowSetup.Encode(ItemJournalLine.GetView(false))));
    end;

}