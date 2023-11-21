/// <summary>
/// Report Fa Card Detail (ID 80036).
/// </summary>
report 80036 "NCT Fa Card Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80036_FaCardDetail.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Fixed Asset History';
    UsageCategory = None;
    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            column(ComInfo_Name; ComInfo.Name + ComInfo."Name 2") { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Description_2; "Description 2") { }
            column(Purchase_Order_No_; "NCT Purchase Order No.") { }
            column(Purchase_Invoice_No_; "NCT Purchase Invoice No.") { }
            column(Tax_Invoice_No_; "NCT Tax Invoice No.") { }
            column(Price_Exclude_Vat; "NCT Price Exclude Vat") { }
            column(FA_Class_Code; "FA Class Code") { }
            column(FA_Subclass_Code; "FA Subclass Code") { }
            column(FA_Location_Code; "FA Location Code") { }
            column(Image; Image) { }
            column(QRCode; barcode) { }
            trigger OnAfterGetRecord();
            var
                BarcodeSymbology: Enum "Barcode Symbology";
            begin
                barcode := FunctionCenter.Generatebarcode(BarcodeSymbology::Code39, "No.");
            end;
        }
    }
    trigger OnPreReport();
    begin
        ComInfo.get();
    end;

    var
        ComInfo: Record "Company Information";
        FunctionCenter: Codeunit "NCT Function Center";
        barcode: Text;
}