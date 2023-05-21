page 50033 "Get Vendor Ledger Entry"
{

    PageType = List;
    SourceTable = "Vendor Ledger Entry";
    Caption = 'Get Vendor Ledger Entry';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            "CreateLines"();

    end;

    procedure "SetDocument"(NewDocumentType: Option "Sales Billing","Sales Receipt","Purchase Billing"; NewDocumentNo: Code[20])
    begin
        DocumentType := NewDocumentType;
        DocumentNo := NewDocumentNo;
        BillingHeader.GET(DocumentType, DocumentNo);
    end;

    local procedure "CreateLines"()
    var
        GetBillingLine: Codeunit "Get Cust/Vend Ledger Entry";
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        GetBillingLine."SetDocument"(BillingHeader);
        GetBillingLine."CreateVendBillingLines"(Rec);
    end;

    var
        DocumentNo: Code[30];
        DocumentType: Option "Sales Billing","Sales Receipt","Purchase Billing";
        BillingHeader: Record "Billing Receipt Header";
}
