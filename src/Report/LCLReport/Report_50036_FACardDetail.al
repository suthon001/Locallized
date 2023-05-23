report 50036 "Fa Card Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50036_FaCardDetail.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Fixed Asset History';
    ApplicationArea = All;
    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            column(ComInfo_Name; ComInfo.Name + ComInfo."Name 2") { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Description_2; "Description 2") { }
            column(BW_Purchase_Order_No_; "Purchase Order No.") { }
            column(BW_Purchase_Invoice_No_; "Purchase Invoice No.") { }
            column(BW_Tax_Invoice_No_; "Tax Invoice No.") { }
            column(BW_Price_Exclude_Vat; "Price Exclude Vat") { }
            column(FA_Class_Code; "FA Class Code") { }
            column(FA_Subclass_Code; "FA Subclass Code") { }
            column(FA_Location_Code; "FA Location Code") { }
            column(Image; Image) { }
            column(QRCode; ImageStorage."Image") { }
            trigger OnAfterGetRecord();
            begin
                IF NOT ImageStorage.GET(5600, 1, "No.", 0) then
                    ImageStorage.init;

                ImageStorage.CALCFIELDS("Image");
            end;
        }
    }
    trigger OnPreReport();
    begin
        ComInfo.get();
    end;

    var
        ComInfo: Record "Company Information";
        ImageStorage: Record "Image Storage";
}