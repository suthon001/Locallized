page 50042 "Get Purchase Lines"
{
    SourceTable = "Purchase Line";
    SourceTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = filter(> 0));
    Caption = 'Get Purchase Lines';
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    PageType = List;
    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Caption = 'Lines';
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; rec."Description 2")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Outstanding Quantity"; rec."Outstanding Quantity")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Direct Unit Cost"; rec."Direct Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; rec."Line Amount")
                {
                    ApplicationArea = all;
                }
                field("Line Discount %"; rec."Line Discount %")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            CreateLine();
    end;

    procedure "Set PurchaseHeader"(pDocumentType: Enum "Purchase Document Type"; pDocumentNo: code[30])
    begin
        PurchaseHeader.GET(pDocumentType, pDocumentNo);
    end;

    procedure CreateLine()
    var
        PurchaseOrderLine, PurchaseQuotesLine2, PurchaseQuotesLine : Record "Purchase Line";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        PurchCommentLine: Record "Purch. Comment Line";
    begin
        PurchaseQuotesLine.Copy(rec);
        CurrPage.SetSelectionFilter(PurchaseQuotesLine);
        if PurchaseQuotesLine.FindFirst() then
            repeat
                PurchaseOrderLine.init;
                PurchaseOrderLine.TransferFields(PurchaseQuotesLine, false);
                PurchaseOrderLine."Document Type" := PurchaseHeader."Document Type";
                PurchaseOrderLine."Document No." := PurchaseHeader."No.";
                PurchaseOrderLine."Line No." := PurchaseOrderLine.GetLastLine();
                PurchaseOrderLine.Insert();
                PurchaseOrderLine."Ref. PQ No." := PurchaseQuotesLine."Document No.";
                PurchaseOrderLine."Ref. PQ Line No." := PurchaseQuotesLine."Line No.";
                PurchaseOrderLine."Make Order By" := UserId;
                PurchaseOrderLine."Make Order DateTime" := CurrentDateTime;
                PurchaseOrderLine.Validate(Quantity, PurchaseQuotesLine."Outstanding Quantity");
                PurchaseOrderLine.Validate("Direct Unit Cost", PurchaseQuotesLine."Direct Unit Cost");
                PurchaseOrderLine.Modify();

                if PurchaseQuotesLine2.GET(PurchaseQuotesLine."Document Type", PurchaseQuotesLine."Document No.", PurchaseQuotesLine."Line No.") then begin
                    PurchaseQuotesLine2."Outstanding Quantity" := 0;
                    PurchaseQuotesLine2."Outstanding Qty. (Base)" := 0;
                    PurchaseQuotesLine2."Qty. Rcd. Not Invoiced" := 0;
                    PurchaseQuotesLine2."Qty. Rcd. Not Invoiced (Base)" := 0;
                    PurchaseQuotesLine2."Completely Received" := True;
                    PurchaseQuotesLine2."Make to PO Qty." := 0;
                    PurchaseQuotesLine2."Make to PO Qty. (Base)" := 0;
                    PurchaseQuotesLine2.Modify();
                end;

                PurchLineReserve.TransferPurchLineToPurchLine(
                                 PurchaseOrderLine, PurchaseOrderLine, PurchaseOrderLine."Outstanding Qty. (Base)");
                PurchLineReserve.VerifyQuantity(PurchaseOrderLine, PurchaseQuotesLine);



                PurchCommentLine.CopyLineComments(0, 1, PurchaseQuotesLine."Document No.", PurchaseOrderLine."Document No.", PurchaseQuotesLine."Line No.", PurchaseOrderLine."Line No.");
                CopyCommentDescription(PurchaseQuotesLine."Document Type", PurchaseOrderLine."Document Type", PurchaseQuotesLine."Document No.", PurchaseOrderLine."Document No.", PurchaseQuotesLine."Line No.");
            until PurchaseQuotesLine.next = 0;
    end;

    procedure CopyCommentDescription(FromDOcumentType: Enum "Purchase Document Type"; ToDocumentType: Enum "Purchase Document Type"; FromNo: Code[20]; ToNo: Code[20]; FromLineNo: Integer)
    var
        ReqisitionLine: Record "Purchase Line";
        ReqisitionLine2: Record "Purchase Line";
        PurchaseLine: Record "Purchase Line";
    begin
        ReqisitionLine.reset;
        ReqisitionLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        ReqisitionLine.SetRange("Document Type", FromDOcumentType);
        ReqisitionLine.SetRange("DOcument No.", FromNo);
        ReqisitionLine.SetFilter("Line No.", '>%1', FromLineNo);
        ReqisitionLine.SetFilter("No.", '<>%1', '');
        if ReqisitionLine.FindFirst() then begin
            ReqisitionLine2.reset;
            ReqisitionLine2.SetCurrentKey("Document Type", "Document No.", "Line No.");
            ReqisitionLine2.SetRange("Document Type", FromDOcumentType);
            ReqisitionLine2.SetRange("DOcument No.", FromNo);
            ReqisitionLine2.SetFilter("Line No.", '<%1', ReqisitionLine."Line No.");
            ReqisitionLine2.SetRange("No.", '');
            ReqisitionLine2.SetFilter(Description, '<>%1', '');
            if ReqisitionLine2.FindFirst() then begin
                repeat
                    PurchaseLine.Init();
                    PurchaseLine."Document Type" := ToDocumentType;
                    PurchaseLine."DOcument No." := ToNo;
                    PurchaseLine."Line No." := PurchaseLine.GetLastLine();
                    PurchaseLine.Type := PurchaseLine.Type::" ";
                    PurchaseLine.Description := ReqisitionLine2.Description;
                    PurchaseLine."Description 2" := ReqisitionLine2."Description 2";
                    PurchaseLine.Insert(True);
                until ReqisitionLine2.Next() = 0;
            end;
        end else begin
            ReqisitionLine.reset;
            ReqisitionLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
            ReqisitionLine.SetRange("Document Type", FromDOcumentType);
            ReqisitionLine.SetRange("DOcument No.", FromNo);
            ReqisitionLine.SetFilter("Line No.", '>%1', FromLineNo);
            ReqisitionLine.SetFilter("No.", '%1', '');
            ReqisitionLine.SetFilter(Description, '<>%1', '');
            if ReqisitionLine.FindFirst() then begin
                repeat
                    PurchaseLine.Init();
                    PurchaseLine."Document Type" := ToDocumentType;
                    PurchaseLine."DOcument No." := ToNo;
                    PurchaseLine."Line No." := PurchaseLine.GetLastLine();
                    PurchaseLine.Type := PurchaseLine.Type::" ";
                    PurchaseLine.Description := ReqisitionLine.Description;
                    PurchaseLine."Description 2" := ReqisitionLine."Description 2";
                    PurchaseLine.Insert(True);
                until ReqisitionLine.Next() = 0;
            end;
        end;
    end;

    var
        PurchaseHeader: Record "Purchase Header";
}