page 50027 "Sales Receipt List"
{

    PageType = List;
    SourceTable = "Billing Receipt Header";
    Caption = 'Sales Receipt List';
    ApplicationArea = All;
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    Editable = false;
    CardPageId = "Sales Receipt Card";
    SourceTableView = sorting("Document Type", "No.") where("Document Type" = filter('Sales Receipt'));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
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
                field("Status"; Rec."Status")
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
    }

}
