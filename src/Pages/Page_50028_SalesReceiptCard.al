page 50028 "Sales Receipt Card"
{

    PageType = Document;
    SourceTable = "Billing Receipt Header";
    Caption = 'Sales Receipt Card';
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTableView = where("Document Type" = filter('Sales Receipt'));
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        if Rec."AssistEdit"(Xrec) then
                            CurrPage.Update();
                    end;
                }

                field("Bill/Pay-to Cust/Vend No."; Rec."Bill/Pay-to Cust/Vend No.")
                {
                    ApplicationArea = All;
                }
                field("Bill/Pay-to Cust/Vend Name"; Rec."Bill/Pay-to Cust/Vend Name")
                {
                    ApplicationArea = All;
                }

                field("Bill/Pay-to Contact"; Rec."Bill/Pay-to Contact")
                {
                    ApplicationArea = All;
                }
                field("Bill/Pay-to Address"; Rec."Bill/Pay-to Address")
                {
                    ApplicationArea = All;
                }
                field("Bill/Pay-to Address 2"; Rec."Bill/Pay-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Bill/Pay-to Cus/Vend Name 2"; Rec."Bill/Pay-to Cus/Vend Name2")
                {
                    ApplicationArea = All;
                }
                field("Bill/Pay-to City"; Rec."Bill/Pay-to City")
                {
                    ApplicationArea = All;
                }
                field("Bill/Pay-to Post Code"; Rec."Bill/Pay-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Vat Registration No."; Rec."Vat Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Receive Type"; Rec."Receive Type") { ApplicationArea = all; }
                field("Receive Account No."; Rec."Receive Account No.") { ApplicationArea = all; }
                field("Receive Date"; Rec."Receive Date") { ApplicationArea = all; }
                field("Template Name"; Rec."Template Name") { ApplicationArea = all; }
                field("Batch Name"; Rec."Batch Name") { ApplicationArea = all; }
                field("RV No. Series"; Rec."RV No. Series") { ApplicationArea = all; }
                field("Receive Status"; Rec."Receive Status") { ApplicationArea = all; }

                field("Journal Document No."; Rec."Journal Document No.") { ApplicationArea = all; }
                field("Posted Document No."; Rec."Posted Document No.") { ApplicationArea = all; }
                field("Status"; Rec."Status") { ApplicationArea = all; }
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
                    field("Cheque Date"; Rec."Cheque Date") { ApplicationArea = all; }
                    field("Cheque No."; Rec."Cheque No.") { ApplicationArea = all; }
                }
                group("Prepaid WHT")
                {
                    Caption = 'Prepaid WHT';
                    field("Prepaid WHT Date"; Rec."Prepaid WHT Date") { ApplicationArea = all; }
                    field("Prepaid WHT No."; Rec."Prepaid WHT No.") { ApplicationArea = all; }
                    field("Prepaid WHT Amount (LCY)"; Rec."Prepaid WHT Amount (LCY)") { ApplicationArea = all; }
                }
                field("Receive Amount"; Rec."Receive Amount") { ApplicationArea = all; }
                field("Bank Fee Amount (LCY)"; Rec."Bank Fee Amount (LCY)") { ApplicationArea = all; }
                field("Diff Amount (LCY)"; Rec."Diff Amount (LCY)") { ApplicationArea = all; }
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
                trigger OnAction()
                var

                    BillingReceiptHeader: Record "Billing Receipt Header";
                begin
                    BillingReceiptHeader.reset;
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
                    PromotedCategory = Process;
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
                    PromotedCategory = Process;
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
                    trigger OnAction()
                    begin
                        Rec.TestField("Status", Rec."Status"::Released);
                        CurrPage.SETSELECTIONFILTER(Rec);
                        Report.Run(Report::"Recript to CashReceipt", true, true, Rec);
                    end;
                }
            }
        }
    }


}

