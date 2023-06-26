/// <summary>
/// Report Stock Movement (ID 80019).
/// </summary>
report 80019 "NCT Stock Movement"
{
    Permissions = TableData "Item Ledger Entry" = rimd;
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80019_StockMovement.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report Stock Movement';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Location Filter";
            column(Var_USERID; _USERID)
            {
            }
            column(CompanyNameEng; CompanyInfo."Name 2")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(Description2_Item; Item."Description 2")
            {
            }
            column(var_ItemNo; var_ItemNo)
            {
            }
            column(var_ItemDateFilter; var_ItemDateFilter)
            {
            }
            column(var_ItemLocationFilter; var_ItemLocationFilter)
            {
            }
            column(var_ItemProductGroupCode; var_ItemProductGroupCode)
            {
            }
            column(var_ItemLedDocumentNo; var_ItemLedDocumentNo)
            {
            }
            column(var_ItemLedLocationCode; var_ItemLedLocationCode)
            {
            }
            column(var_ItemLedEntryType; var_ItemLedEntryType)
            {
            }
            column(var_OpeningBalance; var_OpeningBalance)
            {
            }
            column(var_OpeningBalance2; var_OpeningBalance2)
            {
            }
            column(BaseUnitofMeasure_Item; Item."Base Unit of Measure")
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name + ' ' + CompanyInfo."Name 2")
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Item No.", "Posting Date")
                                    ORDER(Ascending);
                RequestFilterFields = "Location Code", "Entry Type", "Document No.", "Lot No.";
                column(GlobalDimension1Code_ItemLedgerEntry; "Item Ledger Entry"."Global Dimension 1 Code")
                {
                }
                column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
                {
                }
                column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
                {
                }
                column(ExtDocumentNo_ItemLedgerEntry; "Item Ledger Entry"."External Document No.")
                {
                }
                column(LocationCode_ItemLedgerEntry; "Item Ledger Entry"."Location Code")
                {
                }
                column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
                {
                }
                column(EntryType_ItemLedgerEntry; "Item Ledger Entry"."Entry Type")
                {
                }
                column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
                {
                }
                column(OrderNo_ItemLedgerEntry; "Item Ledger Entry"."Order No.")
                {
                }
                column(ExpirationDate_ItemLedgerEntry; FORMAT("Item Ledger Entry"."Expiration Date"))
                {
                }
                column(var_Neg; var_Neg)
                {
                }
                column(var_Pos; var_Pos)
                {
                }
                column(var_TotalQuantity; var_TotalQuantity)
                {
                }
                column(var_TotalPos; var_TotalPos)
                {
                }
                column(var_TotalNeg; var_TotalNeg)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    var_Pos := 0;
                    var_Neg := 0;

                    IF "Item Ledger Entry".Quantity > 0 THEN
                        var_Pos := "Item Ledger Entry".Quantity
                    ELSE
                        var_Neg := "Item Ledger Entry".Quantity;

                    var_OpeningBalance := var_OpeningBalance + "Item Ledger Entry".Quantity;

                    var_TotalPos := var_TotalPos + var_Pos;
                    var_TotalNeg := var_TotalNeg + var_Neg;
                    var_TotalQuantity := var_TotalQuantity + "Item Ledger Entry".Quantity;


                end;

                trigger OnPreDataItem()
                begin
                    "Item Ledger Entry".SETCURRENTKEY("Posting Date");
                    "Item Ledger Entry".ASCENDING(TRUE);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                var_TotalQuantity := 0;
                var_TotalPos := 0;
                var_TotalNeg := 0;
                var_OpeningBalance := 0;



                IF var_ItemDateFilter <> '' THEN
                    IF GETRANGEMIN("Date Filter") > 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        SETFILTER("Location Filter", GETFILTER("Location Filter"));

                        CALCFIELDS("Net Change");
                        var_OpeningBalance2 := "Net Change";
                        var_OpeningBalance := "Net Change";
                        SETFILTER("Date Filter", var_ItemDateFilter);
                    END;
            end;


        }
    }


    trigger OnPreReport()

    begin
        CompanyInfo.GET();
        CompanyInfo.CALCFIELDS(Picture);
        var_OpeningBalance2 := 0;

        var_ItemDateFilter := Item.GETFILTER(Item."Date Filter");
        var_ItemNo := Item.GETFILTER(Item."No.");
        var_ItemLocationFilter := Item.GETFILTER(Item."Location Filter");
        //  var_ItemProductGroupCode := Item.GETFILTER(Item."Product Group Code");
        var_ItemLedDocumentNo := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Document No.");
        var_ItemLedLocationCode := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");
        var_ItemLedEntryType := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Entry Type");

        ItemFilter := Item.GETFILTERS();


        _USERID := FunctionCenter.GetName(COPYSTR(USERID, 1, 50));
    end;

    var
        FunctionCenter: Codeunit "NCT Function Center";
        var_Pos: Decimal;
        var_Neg: Decimal;
        var_OpeningBalance: Decimal;
        var_OpeningBalance2: Decimal;
        var_TotalQuantity: Decimal;
        var_TotalPos: Decimal;
        var_TotalNeg: Decimal;
        var_ItemDateFilter: Text;

        CompanyInfo: Record "Company Information";
        var_ItemNo: text;
        var_ItemLocationFilter: text;
        var_ItemProductGroupCode: text;
        var_ItemLedDocumentNo: text;
        var_ItemLedLocationCode: text;
        var_ItemLedEntryType: Text;
        _USERID: Text[100];
        ItemFilter: Text;
}

