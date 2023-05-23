/// <summary>
/// TableExtension ExtenPurchase Line (ID 80011) extends Record Purchase Line.
/// </summary>
tableextension 80011 "ExtenPurchase Line" extends "Purchase Line"
{
    fields
    {
        field(80000; "Qty. to Cancel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Cancel';
            trigger OnValidate()
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin
                if not Confirm('Do you want to Cancel Qty. ? ') then
                    exit;
                IF ("Document Type" = "Document Type"::Order) THEN BEGIN
                    IF "Outstanding Quantity" = 0 THEN
                        ERROR('Outstanding Quantity must not be 0');

                    IF "Qty. to Cancel" > (Quantity - "Quantity Received") THEN
                        VALIDATE("Qty. to Cancel", Quantity - "Quantity Received");

                    "Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("Qty. to Cancel", "Qty. per Unit of Measure");
                    InitOutstanding();

                    VALIDATE("Qty. to Receive", "Outstanding Quantity");
                END ELSE begin

                    IF ("Document Type" = "Document Type"::"Blanket Order") THEN BEGIN
                        IF "Qty. to Cancel" > Quantity THEN
                            VALIDATE("Qty. to Cancel", Quantity);

                        "Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;
                    IF ("Document Type" = "Document Type"::Quote) THEN BEGIN

                        "Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;

                end;
            end;
        }
        field(80001; "Qty. to Cancel (Base)"; Decimal)
        {
            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Qty. to Cancel (Base)';
        }
        field(80002; "Make Order By"; Code[50])
        {
            Caption = 'Make Order By';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80003; "Make Order DateTime"; DateTime)
        {
            Caption = 'Make Order DateTime';
            Editable = false;
            DataClassification = SystemMetadata;
        }

        field(80004; "Ref. PQ No."; Code[30])
        {
            Caption = 'Ref. PR No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "Ref. PQ Line No."; Integer)
        {
            Caption = 'Ref. PR Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80007; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80008; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80009; "Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Tax Invoice Amount" := ROUND("Tax Invoice Base" * "VAT %" / 100, 0.01);
            end;

        }
        field(80010; "Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80011; "Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if not Vend.GET("Tax Vendor No.") then
                    Vend.init();
                "Tax Invoice Name" := Vend.Name;
                "Tax Invoice Name 2" := Vend."Name 2";
                "Vat Registration No." := Vend."VAT Registration No.";
                "Head Office" := Vend."Head Office";
                "Branch Code" := Vend."Branch Code";
                if (NOT "Head Office") AND ("Branch Code" = '') then
                    "Head Office" := true;
            end;
        }
        field(80012; "Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80013; "Head Office"; Boolean)
        {
            Caption = 'Tax Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "Branch Code" := '';
            end;
        }
        field(80014; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "Branch Code" <> '' then begin
                    if StrLen("Branch Code") < 5 then
                        Error('Branch Code must be 5 characters');
                    "Head Office" := false;

                end;
                if "Branch Code" = '00000' then begin
                    "Head Office" := TRUE;
                    "Branch Code" := '';

                end;
            end;

        }
        field(80015; "Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(80016; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80017; "Status"; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(80018; "Select"; Boolean)
        {
            Caption = 'Select';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Select Vendor No.");
                TestField("Make to PO Qty.");
                Validate("Select By", UserId);
            end;
        }
        field(80019; "Select Vendor No."; Code[20])
        {
            Caption = 'Select Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(80020; "Select By"; Code[30])
        {
            Caption = 'Select By';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                OnAfterValidateSelectBy("Select By");
            end;
        }
        field(80021; "Make to PO Qty."; Decimal)
        {
            Caption = 'Make to PO Qty.';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "Make to PO Qty." > "Outstanding Quantity" then
                    FieldError("Make to PO Qty.", StrSubstNo(PoQtyErr, "Outstanding Quantity"));
                Validate("Make to PO Qty. (Base)", "Make to PO Qty.");
            end;

        }
        field(80022; "Make to PO Qty. (Base)"; Decimal)
        {
            Caption = 'Make to PO Qty. (Base)';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(80023; "Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Type = Type::Item then begin
                    if not Item.Get("No.") then
                        Item.init();
                    "WHT Product Posting Group" := Item."WHT Product Posting Group";
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CheckQtyPR();
            end;
        }

    }
    /// <summary>
    /// GetPurchaseQuotesLine.
    /// </summary>
    procedure GetPurchaseQuotesLine()
    var
        PurchaseQuotesLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        GetPurchaseLine: Page "Get Purchase Lines";
    begin
        CLEAR(GetPurchaseLine);
        PurchaseHeader.GET("Document Type", "Document No.");
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
        PurchaseQuotesLine.reset();
        PurchaseQuotesLine.SetRange("Document Type", PurchaseQuotesLine."Document Type"::Quote);
        PurchaseQuotesLine.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchaseQuotesLine.SetRange(Status, PurchaseQuotesLine.Status::Released);
        PurchaseQuotesLine.SetFilter("Outstanding Quantity", '<>%1', 0);
        GetPurchaseLine.SetTableView(PurchaseQuotesLine);
        GetPurchaseLine."Set PurchaseHeader"("Document Type", "Document No.");
        GetPurchaseLine.LookupMode := true;
        GetPurchaseLine.RunModal();
        clear(GetPurchaseLine);


    end;

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.reset();
        PurchaseLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        PurchaseLine.SetRange("Document Type", "Document Type");
        PurchaseLine.SetRange("Document No.", "Document No.");
        if PurchaseLine.FindLast() then
            EXIT(PurchaseLine."Line No." + 10000);
        exit(10000);
    end;

    local procedure CheckQtyPR()

    var
        POLine: Record "Purchase Line";
        PRLine: Record "Purchase Line";
        TempQty, TempQtyBase : Decimal;

    begin
        TempQty := 0;
        TempQtyBase := 0;
        if ("Document Type" = "Document Type"::Order) AND
            ("Ref. PQ No." <> '') then begin

            POLine.reset();
            POLine.SetRange("Document Type", "Document Type");
            POLine.SetFilter("Document No.", '<>%1', "Document No.");
            POLine.SetRange("Ref. PQ No.", "Ref. PQ No.");
            POLine.SetRange("Ref. PQ Line No.", "Ref. PQ Line No.");
            if POLine.FindFirst() then begin
                POLine.CalcSums(Quantity, "Quantity (Base)");
                TempQty := POLine.Quantity;
                TempQtyBase := POLine."Quantity (Base)";
            end;
            POLine.reset();
            POLine.SetRange("Document Type", "Document Type");
            POLine.SetFilter("Document No.", '%1', "Document No.");
            POLine.SetFilter("Line No.", '<>%1', "Line No.");
            POLine.SetRange("Ref. PQ No.", "Ref. PQ No.");
            POLine.SetRange("Ref. PQ Line No.", "Ref. PQ Line No.");
            if POLine.FindFirst() then begin
                POLine.CalcSums(Quantity, "Quantity (Base)");
                TempQty := TempQty + POLine.Quantity;
                TempQtyBase := TempQtyBase + POLine."Quantity (Base)";
            end;
            PRLine.GET(PRLine."Document Type"::Quote, "Ref. PQ No.", "Ref. PQ Line No.");
            if (TempQty + Quantity) > PRLine.Quantity then
                FieldError(Quantity, StrSubstNo(PrRemainingErr, "Ref. PQ No.", PRLine.Quantity - TempQty));
            PRLine."Outstanding Quantity" := PRLine.Quantity - (TempQty + Quantity);
            PRLine."Outstanding Qty. (Base)" := PRLine."Quantity (Base)" - (TempQtyBase + "Quantity (Base)");
            PRLine."Completely Received" := PRLine."Outstanding Quantity" = 0;
            Validate("Make to PO Qty.", PRLine."Outstanding Quantity");
            PRLine.Modify();
        end;
        if ("Document Type" = "Document Type"::Quote) AND ("No." <> '') then
            Validate("Make to PO Qty.", PRLine.Quantity);


    end;

    /// <summary>
    /// OnAfterValidateSelectBy.
    /// </summary>
    /// <param name="UserName">VAR Code[30].</param>
    [IntegrationEvent(false, false)]
    procedure OnAfterValidateSelectBy(var UserName: Code[30])
    begin
    end;

    var
        PrRemainingErr: Label 'PR No. %1 ,Remaining Quantity is %2', Locked = true;
        PoQtyErr: label 'not more than %1', Locked = true;
}