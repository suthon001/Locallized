/// <summary>
/// Page NCT Purchase Billing List (ID 80030).
/// </summary>
page 80030 "NCT Purchase Billing List"
{

    PageType = List;
    SourceTable = "NCT Billing Receipt Header";
    Caption = 'Purchase Billing List';
    ApplicationArea = All;
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    Editable = false;
    CardPageId = "NCT Purchase Billing Card";
    SourceTableView = sorting("Document Type", "No.") where("Document Type" = filter('Purchase Billing'));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
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
    }

}
