/// <summary>
/// Report Stock On Hand (ID 80020).
/// </summary>
report 80020 "NCT Stock On Hand"
{
    Permissions = TableData "Item Ledger Entry" = rimd;
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80020_StockOnHand.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Report Stock On Hand';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Location Code");
            RequestFilterFields = "Item No.", "Location Code", "Expiration Date";
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
            {
            }
            column(LocationCode_ItemLedgerEntry; "Item Ledger Entry"."Location Code")
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
            {
            }
            column(ExpirationDate_ItemLedgerEntry; "Item Ledger Entry"."Expiration Date")
            {
            }
            column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
            {
            }
            column(Description_ItemMo; ItemMo.Description)
            {
            }
            column(Description2_ItemMo; ItemMo."Description 2")
            {
            }
            column(SafetyStockQuantity_ItemMo; ItemMo."Safety Stock Quantity")
            {
            }
            column(BaseUnitofMeasure_ItemMo; ItemMo."Base Unit of Measure")
            {
            }
            column(NetChange_Item_Mo; "Item Mo"."Net Change")
            {
            }
            column(ItemLedgerEntryDateFilter; ItemLedgerEntryDateFilter)
            {
            }
            column(NameCompanyInformation; CompanyInformation.Name)
            {
            }
            column(USERID; _USERID)
            {
            }
            column(ShowItems; var_ShowItems)
            {
            }

            trigger OnAfterGetRecord()
            begin


                ItemMo.RESET();
                ItemMo.SETFILTER("No.", '%1', "Item No.");
                IF NOT ItemMo.FIND('-') THEN
                    CLEAR(ItemMo);


                "Item Mo".RESET();
                "Item Mo".SETFILTER("No.", "Item No.");
                IF "Item Ledger Entry".GETFILTER("Location Code") <> '' THEN
                    "Item Mo".SETFILTER("Location Filter", "Item Ledger Entry".GETFILTER("Location Code"));
                "Item Mo".SETRANGE("Date Filter", 0D, GETRANGEMAX("Posting Date"));
                IF "Item Mo".FIND('-') THEN
                    "Item Mo".CALCFIELDS("Net Change");

                var_ShowItems := FALSE;
                IF "Item Mo"."Net Change" <> 0 THEN
                    var_ShowItems := TRUE;

                IF var_ZeroStock = TRUE THEN
                    var_ShowItems := TRUE;
            end;

            trigger OnPreDataItem()
            begin
                "Item Ledger Entry".SETRANGE("Posting Date", 0D, EndingDate);
                IF NOT "Item Ledger Entry".FIND('-') THEN
                    CLEAR("Item Ledger Entry");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Ending Date"; EndingDate)
                {
                    Caption = 'Ending Date';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field("Print Zero Stock"; var_ZeroStock)
                {
                    Caption = 'Print Zero Stock';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Print Zero Stock field.';
                }
            }
        }


        trigger OnOpenPage()
        begin
            EndingDate := TODAY;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        CompanyInformation.GET();
        //CompanyInformation.CALCFIELDS(Picture);

        ItemLedgerEntryDateFilter := "Item Ledger Entry".GETFILTERS;

        Usersetup.reset();
        Usersetup.SetRange("User Name", USERID);
        _USERID := Usersetup."Full Name";
    end;

    var
        CompanyInformation: Record "Company Information";
        ItemMo: Record Item;
        "Item Mo": Record Item;

        var_ShowItems: Boolean;
        EndingDate: Date;
        var_ZeroStock: Boolean;
        ItemLedgerEntryDateFilter: Text;
        _USERID: Text[250];
        Usersetup: Record user;
}

