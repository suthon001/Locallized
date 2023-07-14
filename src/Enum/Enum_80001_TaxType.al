/// <summary>
/// Enum NCT Tax Type (ID 80001).
/// </summary>
enum 80001 "NCT Tax Type"
{
    Extensible = true;
    value(0; "Purchase") { Caption = 'Purchase'; }
    value(1; Sale) { Caption = 'Sale'; }
    value(2; WHT03) { Caption = 'WHT03'; }
    value(3; WHT53) { Caption = 'WHT53'; }

}
