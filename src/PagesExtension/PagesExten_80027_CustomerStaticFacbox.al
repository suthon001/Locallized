pageextension 80027 "CustomerStaticFacbox" extends "Customer Statistics FactBox"
{

    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field(AvalibleCreditAmt; AvalibleCreditAmt)
            {
                Caption = 'Available Credit (LCY)';
                Editable = false;
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