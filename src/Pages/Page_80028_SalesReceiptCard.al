/// <summary>
/// Page NCT Sales Receipt Card (ID 80028).
/// </summary>
page 80028 "NCT Sales Receipt Card"
{

    PageType = Document;
    SourceTable = "NCT Billing Receipt Header";
    Caption = 'Sales Receipt Card';
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Request Approval,Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTableView = where("Document Type" = filter('Sales Receipt'));
    UsageCategory = None;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = rec.Status = rec.Status::Open;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec."AssistEdit"(Xrec) then
                            CurrPage.Update();
                    end;
                }

                field("Bill/Pay-to Cust/Vend No."; Rec."Bill/Pay-to Cust/Vend No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to Cust/Vend No. field.';
                }
                field("Bill/Pay-to Cust/Vend Name"; Rec."Bill/Pay-to Cust/Vend Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to Cust/Vend Name field.';
                }

                field("Bill/Pay-to Contact"; Rec."Bill/Pay-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to Contact field.';
                }
                field("Bill/Pay-to Address"; Rec."Bill/Pay-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to Cust/Vend Address field.';
                }
                field("Bill/Pay-to Address 2"; Rec."Bill/Pay-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to Cust/Vend Address 2 field.';
                }
                field("Bill/Pay-to Cus/Vend Name 2"; Rec."Bill/Pay-to Cus/Vend Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to Cus/Vend Name2 field.';
                }
                field("Bill/Pay-to City"; Rec."Bill/Pay-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to City field.';
                }
                field("Bill/Pay-to Post Code"; Rec."Bill/Pay-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill/Pay-to Post Code field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Method Code field.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Description field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                }

                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("Vat Registration No."; Rec."Vat Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vat Registration No. field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("SalesBillingLine"; "NCT Sales Receipt Subform")
            {
                SubPageView = sorting("Document Type", "Document No.", "Line No.");
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = all;
                Editable = rec.Status = rec.Status::Open;
            }
            group(ReceiveInfor)
            {
                Caption = 'Receipt Information';
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receipt Type field.';
                    Caption = 'Receipt Account Type';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receipt Account No. field.';
                    Caption = 'Receipt Account No.';
                }
                field("Journal Date"; Rec."Journal Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receipt Date field.';
                    Caption = 'Receipt Date';
                }
                field("Journal Template Name"; rec."Journal Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Template Name field.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Batch Name field.';
                }
                field("Journal No. Series"; Rec."Journal No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the RV No. Series field.';
                }

                field("Journal Document No."; Rec."Journal Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Document No. field.';
                    trigger OnAssistEdit()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        CashReceiptJournal: Page "Cash Receipt Journal";
                    begin
                        rec.TestField("Journal Document No.");
                        rec.TestField("Status", rec."Status"::"Created to Journal");
                        CLEAR(CashReceiptJournal);
                        GenJournalLine.reset();
                        GenJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                        GenJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                        CashReceiptJournal.SetRecord(GenJournalLine);
                        CashReceiptJournal.SetDocumnet(rec."Journal Document No.");
                        CashReceiptJournal.Run();
                        CLEAR(CashReceiptJournal);
                    end;
                }
            }
            group("Information")
            {
                Caption = 'Information';
                Editable = rec.Status = rec.Status::Open;
                group("Bank")
                {
                    Caption = 'Bank';

                    field("Cheque Date"; Rec."Cheque Date")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Cheque Date field.';
                    }
                    field("Cheque No."; Rec."Cheque No.")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Cheque No. field.';
                    }
                }
                group("Prepaid WHT")
                {
                    Caption = 'Prepaid WHT';
                    Editable = rec.Status = rec.Status::Open;
                    field("Prepaid WHT Date"; Rec."Prepaid WHT Date")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Prepaid WHT Date field.';
                    }
                    field("Prepaid WHT No."; Rec."Prepaid WHT No.")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Prepaid WHT No. field.';
                    }
                    field("Prepaid WHT Amount (LCY)"; Rec."Prepaid WHT Amount (LCY)")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Prepaid WHT Amount (LCY) field.';
                    }
                }
                field("Receive & Payment Amount"; rec."Receive & Payment Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receive Amount field.';
                    Caption = 'Receive Amount';
                }
                field("Bank Fee Amount (LCY)"; Rec."Bank Fee Amount (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Fee Amount (LCY) field.';
                }
                field("Diff Amount (LCY)"; Rec."Diff Amount (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Diff Amount (LCY) field.';
                }
            }
        }


    }


    actions
    {
        area(Reporting)
        {
            action("Sales Receipt")
            {
                Caption = 'Sales Receipt';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Sales Receipt action.';
                trigger OnAction()
                var

                    BillingReceiptHeader: Record "NCT Billing Receipt Header";
                begin
                    BillingReceiptHeader.reset();
                    BillingReceiptHeader.SetRange("Document Type", rec."Document Type");
                    BillingReceiptHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"NCT Sales Receipt", true, true, BillingReceiptHeader);
                end;
            }
        }
        area(Processing)
        {
            group("GetLines")
            {
                Caption = 'GetLine';
                action("Get Posted Document")
                {
                    Caption = 'Get Posted Document';
                    Image = GetEntries;
                    Promoted = true;
                    ApplicationArea = all;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Get Posted Document action.';
                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(Codeunit::"NCT Get Cust/Vend Ledger Entry", Rec);

                    end;
                }
            }
            group("ReleaseReOpen")
            {
                Caption = 'Release&ReOpen';
                action("Release")
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Release action.';
                    trigger OnAction()
                    var
                        ReleaseBillDoc: Codeunit "NCT Function Center";
                    begin
                        ReleaseBillDoc.RereleaseBilling(Rec);
                    end;
                }
                action("Open")
                {
                    Caption = 'Open';
                    Image = ReOpen;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Open action.';
                    trigger OnAction()
                    var
                        ReleaseBillDoc: Codeunit "NCT Function Center";
                    begin
                        ReleaseBillDoc.ReopenBilling(Rec);
                    end;
                }
            }
            group("Create CashReceipt")
            {
                Caption = 'Create CashReceipt';
                action("Create Cash Receipt Line")
                {
                    Image = CashReceiptJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    Caption = 'Create Cash Receipt Line';
                    ToolTip = 'Executes the Create Cash Receipt Line action.';
                    trigger OnAction()
                    begin
                        Rec.TestField("Status", Rec."Status"::Released);
                        CurrPage.SETSELECTIONFILTER(Rec);
                        Report.Run(Report::"NCT Recript to CashReceipt", true, true, Rec);
                    end;
                }
            }

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
                        if Rec.CheckWorkflowBillingReceiptEnabled(Rec) then
                            Rec.OnSendBillingReceiptforApproval(rec);
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

                        Rec.OnCancelBillingReceiptforApproval(rec);
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

