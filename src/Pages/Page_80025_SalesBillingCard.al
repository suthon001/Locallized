/// <summary>
/// Page NCT Sales Billing Card (ID 80025).
/// </summary>
page 80025 "NCT Sales Billing Card"
{
    PageType = Document;
    SourceTable = "NCT Billing Receipt Header";
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Request Approval,Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    Caption = 'Sales Billing Card';
    SourceTableView = where("Document Type" = filter('Sales Billing'));
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
                    Visible = false;
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
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
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("SalesBillingLine"; "NCT Sales Billing Subform")
            {
                ApplicationArea = all;
                SubPageView = sorting("Document Type", "Document No.", "Line No.");
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                UpdatePropagation = Both;
                Editable = rec.Status = rec.Status::Open;
            }
        }


    }
    actions
    {
        area(Reporting)
        {
            action("Sales Billing")
            {
                Caption = 'Sales Billing';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Sales Billing action.';
                trigger OnAction()
                var

                    BillingReceiptHeader: Record "NCT Billing Receipt Header";
                begin
                    BillingReceiptHeader.reset();
                    BillingReceiptHeader.SetRange("Document Type", rec."Document Type");
                    BillingReceiptHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"NCT Sales Billing", true, true, BillingReceiptHeader);
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
                        CurrPage.Update();
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
                        ReleaseBillDoc."ReopenBilling"(Rec);
                        CurrPage.Update();
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
                        CurrPage.Update();
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
                        CurrPage.Update();
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
                        CurrPage.Update();
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
