pageextension 80032 "itemLists" extends "Item List"

{
    layout
    {
        modify("Item Tracking Code")
        {
            Visible = true;
        }
        modify(Type)
        {
            Visible = true;
        }
        modify("Costing Method")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Sales Unit of Measure")
        {
            Visible = true;
        }
        modify("Purch. Unit of Measure")
        {
            Visible = true;
        }
        moveafter("No."; Description, "Base Unit of Measure", "Unit Cost", Type, "Item Tracking Code", "Inventory Posting Group", "Gen. Prod. Posting Group", "VAT Prod. Posting Group"
        , "Costing Method", "Assembly BOM", "Replenishment System", "Production BOM No.", "Routing No.", "Unit Price", "Sales Unit of Measure", "Purch. Unit of Measure", "Vendor No.", "Search Description")




    }
}