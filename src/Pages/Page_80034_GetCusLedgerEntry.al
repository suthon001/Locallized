/// <summary>
/// Page NCT Get Cus. Ledger Entry (ID 80034).
/// </summary>
page 80034 "NCT Get Cus. Ledger Entry"
{
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    Caption = 'Get Cus. Ledger Entry';
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
                    ToolTip = 'Specifies the customer entry''s posting date.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type that the customer entry belongs to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry''s document number.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the customer entry.';
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
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry has been completely applied.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the salesperson whom the entry is linked to.';
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
        GetBillingLine."CreateCustBillingLines"(Rec);
    end;

    var
        DocumentNo: Code[30];
        DocumentType: Enum "NCT Billing Document Type";
        BillingHeader: Record "NCT Billing Receipt Header";

}
