report 50039 "Fixed Asset Card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50039_FixedAssetCard.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Fixed Asset Card';


    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            column(ImageStorageQRCode; ImageStorage."Image")
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
            column(PurchaseOrderNo_FixedAsset; "Fixed Asset"."Purchase Order No.")
            {
            }
            column(PurchaseInvoiceNo_FixedAsset; "Fixed Asset"."Purchase Invoice No.")
            {
            }
            column(TaxInvoiceNo_FixedAsset; "Fixed Asset"."Tax Invoice No.")
            {
            }
            column(AcqDate_FixedAsset; "Fixed Asset"."Acq. Date")
            {
            }
            column(PricebeforeVat_FixedAsset; "Fixed Asset"."Price Exclude Vat")
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
            begin
                // "Fixed Asset".CALCFIELDS(Picture);

                IF NOT Vendor.GET("Vendor No.") THEN
                    Vendor.INIT;

                vgFALocationName := CodeUnitFunction."GetNameFALocation"("FA Location Code");
                vgFAClassName := CodeUnitFunction."GetNameFAClass"("FA Class Code");
                vgFASubClassName := CodeUnitFunction."GetNameFASubClass"("FA Subclass Code");

                IF NOT Employee.GET("Responsible Employee") THEN
                    Employee.init;
                vgEmployeeName := Employee."First Name" + ' ' + Employee."Last Name";

                IF NOT ImageStorage.GET(5600, 1, "No.", 0) then
                    ImageStorage.init;

                ImageStorage.CALCFIELDS("Image");
            end;
        }
    }



    trigger OnPreReport()
    begin
        CompanyInformation.GET;
    end;

    var
        CompanyInformation: Record "Company Information";
        ImageStorage: Record "Image Storage";
        CodeUnitFunction: Codeunit "Function Center";
        vgFALocationName: Text;
        vgFAClassName: Text;
        vgFASubClassName: Text;
        vgVendorName: Text[50];
        Vendor: Record Vendor;
        vgEmployeeName: Text[50];
        Employee: Record Employee;
}

