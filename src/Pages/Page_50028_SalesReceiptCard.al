/// <summary>
/// Page Sales Receipt Card (ID 50028).
/// </summary>
page 50028 "Sales Receipt Card"
{

    PageType = Document;
    SourceTable = "Billing Receipt Header";
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
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Code field.';
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
                field("Receive Type"; Rec."Receive Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receive Type field.';
                }
                field("Receive Account No."; Rec."Receive Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receive Account No. field.';
                }
                field("Receive Date"; Rec."Receive Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receive Date field.';
                }
                field("Template Name"; Rec."Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Template Name field.';
                }
                field("Batch Name"; Rec."Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Batch Name field.';
                }
                field("RV No. Series"; Rec."RV No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the RV No. Series field.';
                }
                field("Receive Status"; Rec."Receive Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receive Status field.';
                }

                field("Journal Document No."; Rec."Journal Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Document No. field.';
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted Document No. field.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("SalesBillingLine"; "Sales Receipt Subform")
            {
                SubPageView = sorting("Document Type", "Document No.", "Line No.");
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = all;
            }
            group("Information")
            {
                Caption = 'Information';
                group("Bank")
                {
                    Caption = 'Bank';

                    //   field("Bank Code"; "Bank Code") { ApplicationArea = all; }
                    //  field("Bank Name"; "Bank Name") { ApplicationArea = all; }
                    //  field("Bank Branch Code"; "Bank Branch Code") { ApplicationArea = all; }
                    //                    field("Bank Branch Name"; "Bank Branch Name") { ApplicationArea = all; }
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
                field("Receive Amount"; Rec."Receive Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receive Amount field.';
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

                    BillingReceiptHeader: Record "Billing Receipt Header";
                begin
                    BillingReceiptHeader.reset();
                    BillingReceiptHeader.SetRange("Document Type", rec."Document Type");
                    BillingReceiptHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"Sales Receipt", true, true, BillingReceiptHeader);
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
                        CODEUNIT.RUN(Codeunit::"Get Cust/Vend Ledger Entry", Rec);

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
                        ReleaseBillDoc: Codeunit "Function Center";
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
                        ReleaseBillDoc: Codeunit "Function Center";
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
                        Report.Run(Report::"Recript to CashReceipt", true, true, Rec);
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

