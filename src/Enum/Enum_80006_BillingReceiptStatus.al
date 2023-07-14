/// <summary>
/// Enum NCT Billing Receipt Status (ID 80006).
/// </summary>
enum 80006 "NCT Billing Receipt Status"
{
    Extensible = true;
    value(0; "Open") { Caption = 'Open'; }
    value(1; "Pending Approval") { Caption = 'Pending Approval'; }
    value(2; "Released") { Caption = 'Released'; }
    value(3; "Created to Journal") { Caption = 'Created to Journal'; }
    value(4; "Posted") { Caption = 'Posted'; }

}
