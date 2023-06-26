/// <summary>
/// PageExtension NCT ItemsLookup (ID 80087) extends Record Item Lookup.
/// </summary>
pageextension 80087 "NCT ItemsLookup" extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field(Inventory; rec.Inventory)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
            }
        }
        modify("Item Category Code")
        {
            Visible = true;
        }
        moveafter(Inventory; "Item Category Code")
    }
}