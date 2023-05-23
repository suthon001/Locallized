pageextension 80038 "PostedReceiptLines" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        modify("Qty. Rcd. Not Invoiced")
        {
            Visible = true;
        }
        modify("Planned Receipt Date")
        {
            Visible = true;
        }
        modify("Order Date")
        {
            Visible = true;
        }
        modify("Expected Receipt Date")
        {
            Visible = true;
        }
        moveafter(Type; "No.", Description, "Location Code", Quantity, "Unit of Measure Code", "Quantity Invoiced", "Qty. Rcd. Not Invoiced", "Planned Receipt Date",
        "Expected Receipt Date", "Order Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")

        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")
        addafter("Description 2")
        {

            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }

        }


    }
}