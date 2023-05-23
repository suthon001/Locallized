tableextension 80013 "ExtenSales Line" extends "Sales Line"
{
    fields
    {

        field(80000; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }

        field(80002; "Qty. to Cancel"; Decimal)
        {
            Caption = 'Qty. to Cancel';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin
                if not Confirm('Do you want to Cancel Qty. ? ') then
                    exit;
                IF ("Document Type" = "Document Type"::Order) THEN BEGIN
                    IF "Outstanding Quantity" = 0 THEN
                        ERROR('Outstanding Quantity must not be 0');

                    IF "Qty. to Cancel" > (Quantity - "Quantity Shipped") THEN
                        VALIDATE("Qty. to Cancel", Quantity - "Quantity Shipped");

                    "Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("Qty. to Cancel", "Qty. per Unit of Measure");
                    InitOutstanding();

                    VALIDATE("Qty. to Ship", "Outstanding Quantity");
                END ELSE
                    IF ("Document Type" = "Document Type"::"Blanket Order") THEN BEGIN
                        IF "Qty. to Cancel" > Quantity THEN
                            VALIDATE("Qty. to Cancel", Quantity);

                        "Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;
            end;
        }
        field(80003; "Qty. to Cancel (Base)"; Decimal)
        {
            Caption = 'Qty. to Cancel (Base)';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(80004; "Ref. SQ No."; Code[30])
        {
            Editable = false;
            Caption = 'Ref. SQ No.';
            DataClassification = CustomerContent;
        }
        field(80005; "Ref. SQ Line No."; Integer)
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
                    if "No." <> '' then
                        Validate("Gen. Prod. Posting Group", 'GL')
                    else
                        Validate("Gen. Prod. Posting Group", '')

            end;
        }
    }

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