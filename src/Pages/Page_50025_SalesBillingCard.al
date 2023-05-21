page 50025 "Sales Billing Card"
{

    PageType = Document;
    SourceTable = "Billing Receipt Header";
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    Caption = 'Sales Billing Card';
    SourceTableView = where("Document Type" = filter('Sales Billing'));
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
                    Visible = false;
                }
                field("Bill/Pay-to City"; Rec."Bill/Pay-to City")
                {
                    ApplicationArea = All;
                }
                field("Bill/Pay-to Post Code"; Rec."Bill/Pay-to Post Code")
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
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
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {

                    ApplicationArea = all;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }
            }
            part("SalesBillingLine"; "Sales Billing Subform")
            {
                ApplicationArea = all;
                SubPageView = sorting("Document Type", "Document No.", "Line No.");
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                UpdatePropagation = Both;
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
                trigger OnAction()
                var

                    BillingReceiptHeader: Record "Billing Receipt Header";
                begin
                    BillingReceiptHeader.reset;
                    BillingReceiptHeader.SetRange("Document Type", rec."Document Type");
                    BillingReceiptHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"Sales Billing", true, true, BillingReceiptHeader);
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
                        ReleaseBillDoc."ReopenBilling"(Rec);
                    end;
                }
            }
        }
    }


}
