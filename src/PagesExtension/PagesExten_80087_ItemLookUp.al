pageextension 80087 "ItemsLookup" extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field(Inventory; rec.Inventory)
            {
                ApplicationArea = all;
            }
        }
        modify("Item Category Code")
        {
            Visible = true;
        }
        moveafter(Inventory; "Item Category Code")
    }
}