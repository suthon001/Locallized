pageextension 80009 "Item Journal Line" extends "Item Journal"
{
    PromotedActionCategories = 'New,Process,Print,Page,Post/Print,Line,Item,Request to Approval,Approval';
    layout
    {
        modify("Document No.")
        {
            trigger OnAssistEdit()
            begin
                if Rec."AssistEdit"(xRec) then
                    CurrPage.Update();
            end;
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description 2 field.';
            }
        }
        addbefore("Document No.")
        {
            field("Status"; Rec."Status")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Bin Code")
        {
            Visible = true;
        }
        moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "Bin Code")

    }
    actions
    {
        addlast(Reporting)
        {
            action("Item Journal")
            {
                Caption = 'Item Journal';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Item Journal action.';
                trigger OnAction()
                var

                    ItemJournalLine: Record "Item Journal Line";
                begin
                    ItemJournalLine.reset();
                    ItemJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    ItemJournalLine.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"ItemJournal", true, true, ItemJournalLine);
                end;
            }
        }

        addfirst(processing)
        {
            group("Approval")
            {
                Caption = 'Approval';
                action("Approve")
                {
                    Caption = 'Approve';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Approve action.';
                    trigger OnAction()
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
            }
            group("Request to Approval")
            {
                Caption = 'Request to Approval';
                action("Send A&pproval Requst")
                {
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequstApprovelForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    ApplicationArea = all;
                    Caption = 'Send A&pproval Requst';
                    ToolTip = 'Executes the Send A&pproval Requst action.';
                    trigger OnAction()
                    begin
                        if Rec.CheckWorkflowItemJournalEnabled(Rec) then
                            Rec.OnSendItemJournalForApproval(rec);
                    end;


                }
                action("Cancel Approval Request")
                {
                    Enabled = (CancancelApprovalForrecord OR CanRequstApprovelForFlow) AND (OpenApprovalEntriesExist);
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ApplicationArea = all;
                    PromotedOnly = true;
                    Caption = 'Cancel Approval Request';
                    ToolTip = 'Executes the Cancel Approval Request action.';
                    trigger OnAction()
                    begin

                        Rec.OnCancelITemJournalLineforApproval(rec);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CancancelApprovalForrecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        workflowWebhoolMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequstApprovelForFlow, CancancelApprovalForrecord);

    end;

    trigger OnAfterGetCurrRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CancancelApprovalForrecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        workflowWebhoolMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequstApprovelForFlow, CancancelApprovalForrecord);
    end;

    var
        OpenApprovalEntriesExistForCurrUser, CancancelApprovalForrecord, OpenApprovalEntriesExist, CanRequstApprovelForFlow : Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        workflowWebhoolMgt: Codeunit 1543;
}