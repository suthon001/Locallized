/// <summary>
/// TableExtension NCT ExtenItems (ID 80002) extends Record Item.
/// </summary>
tableextension 80002 "NCT ExtenItems" extends Item
{
    fields
    {
        field(80000; "NCT WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "NCT WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }
    }


    fieldgroups
    {
        addlast(DropDown; Inventory, "Item Category Code") { }
    }

}