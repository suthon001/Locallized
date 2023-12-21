/// <summary>
/// TableExtension NCT ExtenSalesShipment Line (ID 80018) extends Record Sales Shipment Line.
/// </summary>
tableextension 80018 "NCT ExtenSalesShipment Line" extends "Sales Shipment Line"
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
        field(95000; "NCT Get to Invoice"; Boolean)
        {
            Caption = 'Get to Invoice';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}