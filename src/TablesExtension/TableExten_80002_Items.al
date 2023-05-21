tableextension 80002 "ExtenItems" extends Item
{
    fields
    {
        field(80000; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }
    }


    fieldgroups
    {
        addlast(DropDown; Inventory, "Item Category Code") { }
    }

}