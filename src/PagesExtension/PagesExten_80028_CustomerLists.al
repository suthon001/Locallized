/// <summary>
/// PageExtension NCT ExtenCustomerLists (ID 80028) extends Record Customer List.
/// </summary>
pageextension 80028 "NCT ExtenCustomerLists" extends "Customer List"
{

    layout
    {
        moveafter("Payments (LCY)"; "Credit Limit (LCY)")
        addafter("Credit Limit (LCY)")
        {
            field(AvalibleCreditAmt; AvalibleCreditAmt)
            {
                Caption = 'Available Credit (LCY)';
                Editable = false;
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Available Credit (LCY) field.';
            }
        }
        modify("Credit Limit (LCY)")
        {
            Visible = true;
        }
        modify("Payments (LCY)")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        modify("Name 2")
        {
            Visible = true;
        }
        moveafter("No."; Name, "Name 2", "Customer Posting Group", "Gen. Bus. Posting Group", "VAT Bus. Posting Group", "Phone No.", "Payment Terms Code", "Location Code", "Responsibility Center",
         "Credit Limit (LCY)", "Balance (LCY)", "Balance Due (LCY)", "Sales (LCY)")

        addafter("Name 2")
        {

            field(Address; Rec.Address)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the street and number.';
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies additional address information.';
            }


        }

        addafter("Phone No.")
        {
            field("Fax No."; Rec."Fax No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s fax number.';
            }
        }
        addafter("Payment Terms Code")
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies which shipment method to use when you ship items to the customer.';
            }
        }
        addlast(Control1)
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
            }
            field("Branch Code"; rec."NCT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Branch Code field.';
            }
            field("Head Office"; rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AvalibleCreditAmt := 0;
        IF Rec."Credit Limit (LCY)" <> 0 then
            AvalibleCreditAmt := Rec."Credit Limit (LCY)" - Rec.GetTotalAmountLCY();
    end;

    Var
        AvalibleCreditAmt: Decimal;
}