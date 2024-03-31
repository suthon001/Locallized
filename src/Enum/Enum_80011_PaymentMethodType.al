/// <summary>
/// Enum NCT Payment Method Type (ID 80011).
/// </summary>
enum 80011 "NCT Payment Method Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Cash)
    {
        Caption = 'Cash';
    }
    value(2; Bank)
    {
        Caption = 'Bank';
    }
    value(3; Check)
    {
        Caption = 'Check';
    }
}
