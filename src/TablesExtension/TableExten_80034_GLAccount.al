/// <summary>
/// TableExtension NCT GLAccount (ID 80034) extends Record G/L Account.
/// </summary>
tableextension 80034 "NCT GLAccount" extends "G/L Account"
{
    fields
    {
        field(80000; "Require Screen Detail"; Option)
        {
            Caption = 'Require Screen Detail';
            OptionMembers = " ",CHEQUE,VAT,WHT;
            OptionCaption = ' ,CHEQUE,VAT,WHT';
            DataClassification = CustomerContent;

        }
    }
}