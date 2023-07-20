/// <summary>
/// Page NCT Purchase Billing Card (ID 80031).
/// </summary>
page 80031 "NCT Purchase Billing Card"
{

    PageType = Document;
    SourceTable = "NCT Billing Receipt Header";
    Caption = 'Purchase Billing Card';
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Request Approval,Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTableView = where("Document Type" = filter('Purchase Billing'));
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
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
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
            }
            part("SalesBillingLine"; "NCT Purchase Billing Subform")
            {
                SubPageView = sorting("Document Type", "Document No.", "Line No.");
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = all;
                Editable = rec.Status = rec.Status::Open;
            }
            group(ReceiveInfor)
            {
                Caption = 'Receive Information';
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Caption = 'Payment Account Type';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Caption = 'Payment Account No.';
                }
                field("Journal Date"; Rec."Journal Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Date field.';
                    Caption = 'Payment Date';
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
                        PaymentJournal: Page "Payment Journal";
                    begin
                        rec.TestField("Journal Document No.");
                        rec.TestField("Status", rec."Status"::"Created to Journal");
                        CLEAR(PaymentJournal);
                        GenJournalLine.reset();
                        GenJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                        GenJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                        PaymentJournal.SetRecord(GenJournalLine);
                        PaymentJournal.SetDocumnet(rec."Journal Document No.");
                        PaymentJournal.Run();
                        CLEAR(PaymentJournal);
                    end;
                }
            }
        }


    }


    actions
    {
        area(Reporting)
        {
            action("Purchase Receipt")
            {
                Caption = 'Purchase Billing';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Purchase Billing action.';
                trigger OnAction()
                var

                    BillingReceiptHeader: Record "NCT Billing Receipt Header";
                begin
                    BillingReceiptHeader.reset();
                    BillingReceiptHeader.SetRange("Document Type", rec."Document Type");
                    BillingReceiptHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"NCT Purchase Billing", true, true, BillingReceiptHeader);
                end;
            }
        }
        area(Processing)
        {
            action(CreatePaymentJournal)
            {
                Caption = 'Create Payment Journal';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Create Payment Journal action.';
                Image = GetEntries;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    rec.TestField("Status", rec."Status"::Released);
                    if rec."Create to Journal" then begin
                        message('This record already create payment journal');
                        exit;
                    end;

                    if not Confirm('Do you want Create to Payment Journal ?') then
                        exit;

                    rec.CreateToPayment();

                end;
            }
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

