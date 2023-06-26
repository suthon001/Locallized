/// <summary>
/// Report Fixed Asset Card (ID 80039).
/// </summary>
report 80039 "NCT Fixed Asset Card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80039_FixedAssetCard.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Fixed Asset Card';
    UsageCategory = None;


    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            column(ImageStorageQRCode; barcode)
            {
            }
            column(CompanyInformationName; CompanyInformation.Name)
            {
            }
            column(No_FixedAsset; "Fixed Asset"."No.")
            {
            }
            column(Description_FixedAsset; "Fixed Asset".Description)
            {
            }
            column(PurchaseOrderNo_FixedAsset; "Fixed Asset"."NCT Purchase Order No.")
            {
            }
            column(PurchaseInvoiceNo_FixedAsset; "Fixed Asset"."NCT Purchase Invoice No.")
            {
            }
            column(TaxInvoiceNo_FixedAsset; "Fixed Asset"."NCT Tax Invoice No.")
            {
            }
            column(AcqDate_FixedAsset; "Fixed Asset"."NCT Acq. Date")
            {
            }
            column(PricebeforeVat_FixedAsset; "Fixed Asset"."NCT Price Exclude Vat")
            {
            }
            column(FALocationCode_FixedAsset; "Fixed Asset"."FA Location Code")
            {
            }
            column(vgFALocationName; vgFALocationName)
            {
            }
            column(FAClassCode_FixedAsset; "Fixed Asset"."FA Class Code")
            {
            }
            column(vgFAClassName; vgFAClassName)
            {
            }
            column(FASubclassCode_FixedAsset; "Fixed Asset"."FA Subclass Code")
            {
            }
            column(vgFASubClassName; vgFASubClassName)
            {
            }
            column(vgVendorName; vgVendorName)
            {
            }
            column(ResponsibleEmployee_FixedAsset; "Fixed Asset"."Responsible Employee")
            {
            }
            column(vgEmployeeName; vgEmployeeName)
            {
            }

            trigger OnAfterGetRecord()
            var
                BarcodeSymbology: Enum "Barcode Symbology";
            begin

                IF NOT Vendor.GET("Vendor No.") THEN
                    Vendor.INIT();

                vgFALocationName := FunctionCenter."GetNameFALocation"("FA Location Code");
                vgFAClassName := FunctionCenter."GetNameFAClass"("FA Class Code");
                vgFASubClassName := FunctionCenter."GetNameFASubClass"("FA Subclass Code");

                IF NOT Employee.GET("Responsible Employee") THEN
                    Employee.init();
                vgEmployeeName := Employee."First Name" + ' ' + Employee."Last Name";
                barcode := FunctionCenter.Generatebarcode(BarcodeSymbology::Code39, "No.");
            end;
        }
    }



    trigger OnPreReport()
    begin
        CompanyInformation.GET();
    end;

    var
        CompanyInformation: Record "Company Information";

        vgFALocationName: Text;
        vgFAClassName: Text;
        vgFASubClassName: Text;
        vgVendorName: Text[100];
        Vendor: Record Vendor;
        vgEmployeeName: Text[100];
        Employee: Record Employee;
        FunctionCenter: Codeunit "NCT Function Center";
        barcode: Text;
}

