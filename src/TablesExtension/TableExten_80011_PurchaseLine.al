/// <summary>
/// TableExtension NCT ExtenPurchase Line (ID 80011) extends Record Purchase Line.
/// </summary>
tableextension 80011 "NCT ExtenPurchase Line" extends "Purchase Line"
{
    fields
    {
        field(80000; "NCT Qty. to Cancel"; Decimal)
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

                    IF "NCT Qty. to Cancel" > (Quantity - "Quantity Received") THEN
                        VALIDATE("NCT Qty. to Cancel", Quantity - "Quantity Received");

                    "NCT Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("NCT Qty. to Cancel", "Qty. per Unit of Measure");
                    InitOutstanding();

                    VALIDATE("Qty. to Receive", "Outstanding Quantity");
                END ELSE begin

                    IF ("Document Type" = "Document Type"::"Blanket Order") THEN BEGIN
                        IF "NCT Qty. to Cancel" > Quantity THEN
                            VALIDATE("NCT Qty. to Cancel", Quantity);

                        "NCT Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("NCT Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;
                    IF ("Document Type" = "Document Type"::Quote) THEN BEGIN

                        "NCT Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("NCT Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;

                end;
            end;
        }
        field(80001; "NCT Qty. to Cancel (Base)"; Decimal)
        {
            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Qty. to Cancel (Base)';
        }
        field(80002; "NCT Make Order By"; Code[50])
        {
            Caption = 'Make Order By';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80003; "NCT Make Order DateTime"; DateTime)
        {
            Caption = 'Make Order DateTime';
            Editable = false;
            DataClassification = SystemMetadata;
        }

        field(80004; "NCT Ref. PQ No."; Code[30])
        {
            Caption = 'Ref. PR No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "NCT Ref. PQ Line No."; Integer)
        {
            Caption = 'Ref. PR Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;

        }
        field(80007; "NCT Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80008; "NCT Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80009; "NCT Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "NCT Tax Invoice Amount" := ROUND("NCT Tax Invoice Base" * "VAT %" / 100, 0.01);
            end;

        }
        field(80010; "NCT Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80011; "NCT Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if not Vend.GET("NCT Tax Vendor No.") then
                    Vend.init();
                "NCT Tax Invoice Name" := Vend.Name;
                "NCT Tax Invoice Name 2" := Vend."Name 2";
                "NCT Vat Registration No." := Vend."VAT Registration No.";
                "NCT Head Office" := Vend."NCT Head Office";
                "NCT Branch Code" := Vend."NCT Branch Code";
                if (NOT "NCT Head Office") AND ("NCT Branch Code" = '') then
                    "NCT Head Office" := true;
            end;
        }
        field(80012; "NCT Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80013; "NCT Head Office"; Boolean)
        {
            Caption = 'Tax Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "NCT Head Office" then
                    "NCT Branch Code" := '';
            end;
        }
        field(80014; "NCT Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "NCT Branch Code" <> '' then begin
                    if StrLen("NCT Branch Code") < 5 then
                        Error('Branch Code must be 5 characters');
                    "NCT Head Office" := false;

                end;
                if "NCT Branch Code" = '00000' then begin
                    "NCT Head Office" := TRUE;
                    "NCT Branch Code" := '';

                end;
            end;

        }
        field(80015; "NCT Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(80016; "NCT WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "NCT WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;

        }
        field(80017; "NCT Status"; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }


        field(80018; "NCT Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80019; "NCT WHT %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT %';

        }
        field(80020; "NCT WHT Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Base';


        }
        field(80021; "NCT WHT Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Amount';
        }
        field(80022; "NCT WHT Option"; Enum "NCT WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80023; "NCT Original Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if rec."Document Type" = rec."Document Type"::Order then
                    rec.Validate(Quantity, rec."NCT Original Quantity");
            end;
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
                    "NCT WHT Product Posting Group" := Item."NCT WHT Product Posting Group";
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CheckQtyPR();
                CalWhtAmount();
                if rec."Document Type" <> rec."Document Type"::Order then
                    rec.Validate("NCT Original Quantity", rec.Quantity)
                else
                    if rec."Over-Receipt Code" = '' then
                        rec."NCT Original Quantity" := rec.Quantity;
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                CalWhtAmount();
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
        GetPurchaseLine: Page "NCT Get Purchase Lines";
    begin
        CLEAR(GetPurchaseLine);
        PurchaseHeader.GET("Document Type", "Document No.");
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
        PurchaseQuotesLine.reset();
        PurchaseQuotesLine.SetRange("Document Type", PurchaseQuotesLine."Document Type"::Quote);
        PurchaseQuotesLine.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchaseQuotesLine.SetRange("NCT Status", PurchaseQuotesLine."NCT Status"::Released);
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
            ("NCT Ref. PQ No." <> '') then begin

            POLine.reset();
            POLine.SetRange("Document Type", "Document Type");
            POLine.SetFilter("Document No.", '<>%1', "Document No.");
            POLine.SetRange("NCT Ref. PQ No.", "NCT Ref. PQ No.");
            POLine.SetRange("NCT Ref. PQ Line No.", "NCT Ref. PQ Line No.");
            if POLine.FindFirst() then begin
                POLine.CalcSums(Quantity, "Quantity (Base)");
                TempQty := POLine.Quantity;
                TempQtyBase := POLine."Quantity (Base)";
            end;
            POLine.reset();
            POLine.SetRange("Document Type", "Document Type");
            POLine.SetFilter("Document No.", '%1', "Document No.");
            POLine.SetFilter("Line No.", '<>%1', "Line No.");
            POLine.SetRange("NCT Ref. PQ No.", "NCT Ref. PQ No.");
            POLine.SetRange("NCT Ref. PQ Line No.", "NCT Ref. PQ Line No.");
            if POLine.FindFirst() then begin
                POLine.CalcSums(Quantity, "Quantity (Base)");
                TempQty := TempQty + POLine.Quantity;
                TempQtyBase := TempQtyBase + POLine."Quantity (Base)";
            end;
            PRLine.GET(PRLine."Document Type"::Quote, "NCT Ref. PQ No.", "NCT Ref. PQ Line No.");
            if (TempQty + Quantity) > PRLine.Quantity then
                FieldError(Quantity, StrSubstNo(PrRemainingErr, "NCT Ref. PQ No.", PRLine.Quantity - TempQty));

            PRLine."Outstanding Quantity" := PRLine.Quantity - (TempQty + Quantity);
            PRLine."Outstanding Qty. (Base)" := PRLine."Quantity (Base)" - (TempQtyBase + "Quantity (Base)");
            PRLine."Completely Received" := PRLine."Outstanding Quantity" = 0;
            PRLine.Modify();
        end;



    end;



    /// <summary>
    /// OnAfterValidateSelectBy.
    /// </summary>
    /// <param name="UserName">VAR Code[30].</param>
    [IntegrationEvent(false, false)]
    procedure OnAfterValidateSelectBy(var UserName: Code[30])
    begin
    end;


    local procedure CalWhtAmount()
    var
        WHTPostingSetup: Record "NCT WHT Posting Setup";
    begin
        IF WHTPostingSetup.GET(rec."NCT WHT Business Posting Group", rec."NCT WHT Product Posting Group") THEN BEGIN
            "NCT WHT Base" := rec."Line Amount";
            "NCT WHT %" := WHTPostingSetup."WHT %";
            "NCT WHT Amount" := ROUND(("NCT WHT Base") * (WHTPostingSetup."WHT %" / 100), 0.01);
        END
        ELSE BEGIN
            "NCT WHT Base" := 0;
            "NCT WHT %" := 0;
            "NCT WHT Amount" := 0;
        END;
    end;

    var
        PrRemainingErr: Label 'PR No. %1 ,Remaining Quantity is %2', Locked = true;

}