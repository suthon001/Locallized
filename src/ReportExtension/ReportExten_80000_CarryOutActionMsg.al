/// <summary>
/// Unknown NCT Carry Out Action Msg (ID 80000) extends Record Carry Out Action Msg. - Req..
/// </summary>
reportextension 80000 "NCT Carry Out Action Msg" extends "Carry Out Action Msg. - Req."
{
    requestpage
    {
        layout
        {
            addafter(PrintOrders)
            {
                field(gvPONoSeries; gvPONoSeries)
                {
                    Caption = 'PO No. Series';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PO No. Series field.';
                    trigger OnAssistEdit()
                    var
                        NoSerieMgt: Codeunit "No. Series";
                        PurchaseSetUp: Record "Purchases & Payables Setup";
                    begin
                        PurchaseSetUp.GET();
                        PurchaseSetUp.TestField("Order Nos.");
                        NoSerieMgt.LookupRelatedNoSeries(PurchaseSetUp."Order Nos.", PurchaseSetUp."Order Nos.", gvPONoSeries);
                        SetPODocumentNo(gvPONoSeries);
                    end;
                }
            }
            modify(PrintOrders)
            {
                Visible = false;
            }
        }
    }
    [IntegrationEvent(false, false)]
    local procedure SetPODocumentNo(PONoSeries: Code[20])
    begin
    end;

    var
        gvPONoSeries: Code[20];
}
