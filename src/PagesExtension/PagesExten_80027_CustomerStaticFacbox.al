/// <summary>
/// PageExtension CustomerStaticFacbox (ID 80027) extends Record Customer Statistics FactBox.
/// </summary>
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
                ToolTip = 'Specifies the value of the Available Credit (LCY) field.';
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