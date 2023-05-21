pageextension 80028 "ExtenCustomerLists" extends "Customer List"
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
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }


        }

        addafter("Phone No.")
        {
            field("Fax No."; Rec."Fax No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
            field("Branch Code"; rec."Branch Code")
            {
                ApplicationArea = all;
            }
            field("Head Office"; rec."Head Office")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AvalibleCreditAmt := 0;
        IF Rec."Credit Limit (LCY)" <> 0 then begin
            AvalibleCreditAmt := Rec."Credit Limit (LCY)" - Rec.GetTotalAmountLCY;
        end;
    end;

    Var
        AvalibleCreditAmt: Decimal;
}