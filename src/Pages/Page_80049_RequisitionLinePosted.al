/// <summary>
/// Page NCT Requisition Line Posted (ID 80049).
/// </summary>
page 80049 "NCT Requisition Line Posted"
{
    ApplicationArea = All;
    Caption = 'Requisition Line Posted';
    PageType = List;
    SourceTable = "NCT Requisition Line Posted";
    UsageCategory = History;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Worksheet Template Name"; Rec."Worksheet Template Name")
                {
                    ToolTip = 'Specifies the value of the Worksheet Template Name field.';
                    ApplicationArea = all;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = all;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = all;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.';
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                    ApplicationArea = all;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Direct Unit Cost field.';
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                    ApplicationArea = all;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.';
                    ApplicationArea = all;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date field.';
                    ApplicationArea = all;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = all;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ToolTip = 'Specifies the value of the Purchaser Code field.';
                    ApplicationArea = all;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Item No. field.';
                    ApplicationArea = all;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field.';
                    ApplicationArea = all;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order Line No. field.';
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                    ApplicationArea = all;
                }
                field("Ref. PO No."; rec."Ref. PO No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ref. PO No. field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("ShowPO")
            {
                Image = Purchase;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Show PO';
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Show PO action.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseOrder: Page "Purchase Order";
                begin
                    rec.TestField("Ref. PO No.");
                    CLEAR(PurchaseOrder);
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.SetRange("No.", rec."Ref. PO No.");
                    PurchaseOrder.SetRecord(PurchaseHeader);
                    PurchaseOrder.RunModal();
                    CLEAR(PurchaseOrder);

                end;
            }
        }
    }

}
