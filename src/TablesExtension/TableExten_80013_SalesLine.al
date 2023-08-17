/// <summary>
/// TableExtension NCT ExtenSales Line (ID 80013) extends Record Sales Line.
/// </summary>
tableextension 80013 "NCT ExtenSales Line" extends "Sales Line"
{
    fields
    {

        field(80000; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "NCT WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "NCT WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }

        field(80002; "NCT Qty. to Cancel"; Decimal)
        {
            Caption = 'Qty. to Cancel';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin
                if not Confirm('Do you want to Cancel Qty. ? ') then begin
                    rec."NCT Qty. to Cancel" := xRec."NCT Qty. to Cancel";
                    exit;
                end;
                IF ("Document Type" = "Document Type"::Order) THEN BEGIN
                    IF "Outstanding Quantity" = 0 THEN
                        ERROR('Outstanding Quantity must not be 0');

                    IF "NCT Qty. to Cancel" > (Quantity - "Quantity Shipped") THEN
                        VALIDATE("NCT Qty. to Cancel", Quantity - "Quantity Shipped");

                    "NCT Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("NCT Qty. to Cancel", "Qty. per Unit of Measure");
                    InitOutstanding();

                    VALIDATE("Qty. to Ship", "Outstanding Quantity");
                END ELSE
                    IF ("Document Type" = "Document Type"::"Blanket Order") THEN BEGIN
                        IF "NCT Qty. to Cancel" > Quantity THEN
                            VALIDATE("NCT Qty. to Cancel", Quantity);

                        "NCT Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("NCT Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;
            end;
        }
        field(80003; "NCT Qty. to Cancel (Base)"; Decimal)
        {
            Caption = 'Qty. to Cancel (Base)';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(80004; "NCT Ref. SQ No."; Code[30])
        {
            Editable = false;
            Caption = 'Ref. SQ No.';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT Ref. SQ Line No."; Integer)
        {
            Editable = false;
            Caption = 'Ref. SQ Line No.';
            DataClassification = CustomerContent;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if type = Type::"G/L Account" then
                    if "No." = '' then
                        Validate("Gen. Prod. Posting Group", '')


            end;
        }
    }

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        salesLine: Record "Sales Line";
    begin
        salesLine.reset();
        salesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        salesLine.SetRange("Document Type", "Document Type");
        salesLine.SetRange("Document No.", "Document No.");
        if salesLine.FindLast() then
            EXIT(salesLine."Line No." + 10000);
        exit(10000);
    end;

}