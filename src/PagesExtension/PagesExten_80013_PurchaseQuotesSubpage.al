pageextension 80013 "Purchase Quotes Subpage" extends "Purchase Quote Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")

    }
}