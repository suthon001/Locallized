/// <summary>
/// Page Make PR to PO (ID 50022).
/// </summary>
page 50022 "Make PR to PO"
{
    Caption = 'Make Pr to PO';
    SourceTable = "Purchase Line";
    SourceTableView = sorting("Document Type", "Document No.", "Line No.") where("Outstanding Quantity" = filter(<> 0), Status = filter(Released), "Document Type" = filter(Quote));
    PageType = Worksheet;
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = all;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater("Lines")
            {
                ShowCaption = false;
                field(Select; rec.Select)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field("Select By"; rec."Select By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Select By field.';
                }
                field("Select Vendor No."; rec."Select Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Select Vendor No. field.';
                }
                field(PostingDate; PurchaseHeader."Posting Date")
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                }
                field(CustomerNO; PurchaseHeader."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                    Caption = 'Vendor No.';
                    Editable = false;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(CustomerName; PurchaseHeader."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                    Caption = 'Vendor Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                }
                field("Make to PO Qty."; rec."Make to PO Qty.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Make to PO Qty. field.';
                }
                field("Outstanding Quantity"; rec."Outstanding Quantity")
                {
                    ApplicationArea = all;
                    Caption = 'Remaining Qty.';
                    Editable = false;
                    ToolTip = 'Specifies how many units on the order line have not yet been received.';
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Direct Unit Cost"; rec."Direct Unit Cost")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Line Discount %"; rec."Line Discount %")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                }
                field("Line Amount"; rec."Line Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(MaketoPO)
            {
                Caption = 'Make to PO';
                Image = MakeOrder;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Make to PO action.';
                trigger OnAction()
                begin
                    MakePRtoPO();
                end;
            }
            action(Card)
            {
                Caption = 'Card';
                Image = Card;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Card action.';
                trigger OnAction()
                var
                    PurchaseQuotes: Page "Purchase Quote";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    CLEAR(PurchaseQuotes);
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."Document No.");
                    PurchaseQuotes.SetTableView(PurchaseHeader);
                    PurchaseQuotes.Editable := false;
                    PurchaseQuotes.RunModal();
                    CLEAR(PurchaseQuotes);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        PurchaseHeader.GET(rec."Document Type", rec."Document No.");
    end;

    local procedure MakePRtoPO()
    var
        NoSeriesMGT: Codeunit NoSeriesManagement;
        PurchaseSetup: Record "Purchases & Payables Setup";
        TempDocNo: Code[20];
        NewNoseries: code[20];
        PurchaseLine, PurchaseOrderLine : Record "Purchase Line";
        UserName: Code[50];
        ltPurchaseHeader: Record "Purchase Header";
        GroupPurchaseQuotes: Query GroupPurchaseQuotes;
        CopyCommentDescription: Page "Get Purchase Lines";
        PurchCommentLine: Record "Purch. Comment Line";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
    begin
        if not confirm('Do you want make pr to po ?') then
            exit;

        PurchaseSetup.get();
        PurchaseSetup.TestField("Order Nos.");
        if NoSeriesMGT.SelectSeries(PurchaseSetup."Order Nos.", '', NewNoseries) then begin
            CLEAR(GroupPurchaseQuotes);
            UserName := COPYSTR(UserId, 1, 50);
            OnsetFilterSelectBy(UserName);
            GroupPurchaseQuotes.SetRange(DOcument_Type, GroupPurchaseQuotes.Document_Type::Quote);
            GroupPurchaseQuotes.SetRange(status, GroupPurchaseQuotes.Status::Released);
            GroupPurchaseQuotes.SetRange(select_by, UserName);
            GroupPurchaseQuotes.Open();
            while GroupPurchaseQuotes.Read() do begin
                TempDocNo := NoSeriesMGT.GetNextNo(PurchaseSetup."Order Nos.", WorkDate(), true);
                PurchaseLine.reset();
                PurchaseLine.SetRange("Document Type", rec."Document Type"::Quote);
                PurchaseLine.SetRange(Status, GroupPurchaseQuotes.Status);
                PurchaseLine.SetRange("Select Vendor No.", GroupPurchaseQuotes.Select_Vendor_No_);
                PurchaseLine.SetRange("Select By", UserName);
                if PurchaseLine.FindFirst() then begin
                    ltPurchaseHeader.init();
                    ltPurchaseHeader."Document Type" := ltPurchaseHeader."Document Type"::Order;
                    ltPurchaseHeader."No." := TempDocNo;
                    ltPurchaseHeader.Validate("Buy-from Vendor No.", PurchaseLine."Select By");
                    ltPurchaseHeader.Validate("Location Code", PurchaseLine."Location Code");
                    ltPurchaseHeader.Validate("Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 1 Code");
                    ltPurchaseHeader.Validate("Shortcut Dimension 2 Code", PurchaseLine."Shortcut Dimension 2 Code");
                    OnbeforInsertPurchaseOrderHeader(ltPurchaseHeader);
                    ltPurchaseHeader.Insert();
                    PurchCommentLine.CopyLineComments(0, 1, PurchaseLine."Document No.", ltPurchaseHeader."No.", 0, 0);
                    repeat

                        PurchaseOrderLine.Init();
                        PurchaseOrderLine.TransferFields(PurchaseLine, false);
                        PurchaseOrderLine."Document Type" := PurchaseOrderLine."Document Type"::Order;
                        PurchaseOrderLine."Document No." := TempDocNo;
                        PurchaseOrderLine."Line No." := PurchaseOrderLine.GetLastLine();
                        PurchaseOrderLine."Make Order By" := UserName;
                        PurchaseOrderLine."Make Order DateTime" := CurrentDateTime;
                        PurchaseOrderLine."Ref. PQ Line No." := PurchaseLine."Line No.";
                        PurchaseOrderLine."Ref. PQ No." := PurchaseLine."Document No.";
                        PurchaseOrderLine.Insert();



                        PurchaseLine.Select := false;
                        PurchaseLine."Select By" := '';
                        PurchaseLine."Select Vendor No." := '';
                        PurchaseLine."Outstanding Quantity" := PurchaseLine."Outstanding Quantity" - PurchaseLine."Make to PO Qty.";
                        PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine."Outstanding Qty. (Base)" - PurchaseLine."Make to PO Qty. (Base)";
                        OnbeforInsertPurchaseOrderLine(PurchaseOrderLine, PurchaseLine);
                        PurchaseLine.Modify();

                        PurchLineReserve.TransferPurchLineToPurchLine(
                                PurchaseOrderLine, PurchaseOrderLine, PurchaseOrderLine."Outstanding Qty. (Base)");
                        PurchLineReserve.VerifyQuantity(PurchaseOrderLine, PurchaseLine);

                        PurchCommentLine.CopyLineComments(0, 1, PurchaseLine."Document No.", PurchaseOrderLine."Document No.", PurchaseLine."Line No.", PurchaseOrderLine."Line No.");
                        CopyCommentDescription.CopyCommentDescription(PurchaseLine."Document Type", PurchaseOrderLine."Document Type", PurchaseLine."Document No.", PurchaseOrderLine."Document No.",
                        PurchaseLine."Line No.");

                    until PurchaseLine.next() = 0;
                    MESSAGE('Create to Document No. ' + TempDocNo);
                end;
            end;
            CLEAR(GroupPurchaseQuotes);
        end;
        CurrPage.Update();
    end;

    /// <summary>
    /// OnsetFilterSelectBy.
    /// </summary>
    /// <param name="pUserName">VAR Code[50].</param>
    [IntegrationEvent(false, false)]
    procedure OnsetFilterSelectBy(var pUserName: Code[50])
    begin
    end;

    /// <summary>
    /// OnbeforInsertPurchaseOrderHeader.
    /// </summary>
    /// <param name="pPurchaseOrderHeader">VAR Record "Purchase Header".</param>
    [IntegrationEvent(false, false)]
    procedure OnbeforInsertPurchaseOrderHeader(var pPurchaseOrderHeader: Record "Purchase Header")
    begin
    end;

    /// <summary>
    /// OnbeforInsertPurchaseOrderLine.
    /// </summary>
    /// <param name="pPurchaseOrderLine">VAR Record "Purchase Line".</param>
    /// <param name="pPurchaseQuotesLine">VAR Record "Purchase Line".</param>
    [IntegrationEvent(false, false)]
    procedure OnbeforInsertPurchaseOrderLine(var pPurchaseOrderLine: Record "Purchase Line"; var pPurchaseQuotesLine: Record "Purchase Line")
    begin
    end;

    var
        PurchaseHeader: Record "Purchase Header";

}