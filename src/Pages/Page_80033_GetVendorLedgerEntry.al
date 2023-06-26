/// <summary>
/// Page NCT Get Vendor Ledger Entry (ID 80033).
/// </summary>
page 80033 "NCT Get Vendor Ledger Entry"
{

    PageType = List;
    SourceTable = "Vendor Ledger Entry";
    Caption = 'Get Vendor Ledger Entry';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the due date on the entry.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            CreateLines();

    end;

    /// <summary>
    /// SetDocument.
    /// </summary>
    /// <param name="NewDocumentType">Option "Sales Billing","Sales Receipt","Purchase Billing".</param>
    /// <param name="NewDocumentNo">Code[20].</param>
    procedure SetDocument(NewDocumentType: Enum "NCT Billing Document Type"; NewDocumentNo: Code[20])
    begin
        DocumentType := NewDocumentType;
        DocumentNo := NewDocumentNo;
        BillingHeader.GET(DocumentType, DocumentNo);
    end;

    local procedure CreateLines()
    var
        GetBillingLine: Codeunit "NCT Get Cust/Vend Ledger Entry";
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        GetBillingLine."SetDocument"(BillingHeader);
        GetBillingLine."CreateVendBillingLines"(Rec);
    end;

    var
        DocumentNo: Code[30];
        DocumentType: Enum "NCT Billing Document Type";
        BillingHeader: Record "NCT Billing Receipt Header";
}
