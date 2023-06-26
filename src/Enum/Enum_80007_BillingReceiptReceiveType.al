/// <summary>
/// Enum NCT Billing Receipt Receive Type (ID 80007).
/// </summary>
enum 80007 "NCT Billing Receipt Type"
{
    Extensible = true;
    value(0; "Bank Account") { Caption = 'Bank Account'; }
    value(1; "G/L Account") { Caption = 'G/L Account'; }
}
