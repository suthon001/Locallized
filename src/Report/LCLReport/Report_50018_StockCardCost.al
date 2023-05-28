report 50018 "Report Stock Card Cost"
{
    Permissions = TableData "Item Ledger Entry" = rimd;
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50018_StockCardCost.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report Stock Card Cost';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem(Item; item)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Location Filter";
            column(Var_USERID; _USERID)
            {
            }
            column(Name_CompanyInfo; CompanyInfo.Name + ' ' + CompanyInfo."Name 2")
            {
            }
            column(Address_CompanyInfo; CompanyInfo.Address)
            {
            }
            column(Address2_CompanyInfo; CompanyInfo."Address 2")
            {
            }
            column(City_CompanyInfo; CompanyInfo.City)
            {
            }
            column(PostCode_CompanyInfo; CompanyInfo."Post Code")
            {
            }
            column(VATRegistration_CompanyInfo; CompanyInfo."VAT Registration No.")
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(var_Description; var_Description)
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
            column(var_Amount; var_Amount)
            {
            }
            column(var_UnitCost; var_UnitCost)
            {
            }
            column(var_Amount2; var_Amount2)
            {
            }
            column(var_UnitCost2; var_UnitCost2)
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
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Item No.", "Variant Code", "Posting Date")
                                    ORDER(Ascending);
                RequestFilterFields = "Location Code", "Entry Type", "Document No.";
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
                column(InvoiceNo_ItemLedgerEntry; "Item Ledger Entry"."Document Invoice No.")
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
                column(OrderNo_ItemLedgerEntry; "Item Ledger Entry"."Order No.")
                {
                }
                column(var_Neg; var_Neg)
                {
                }
                column(var_UnitCostNeg; var_UnitCostNeg)
                {
                }
                column(var_AmountNeg; var_AmountNeg)
                {
                }
                column(var_Pos; var_Pos)
                {
                }
                column(var_UnitCostPos; var_UnitCostPos)
                {
                }
                column(var_AmountPos; var_AmountPos)
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
                column(var_flightno; var_flightno)
                {
                }
                column(var_ShowSummary; var_ShowSummary)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    var_Pos := 0;
                    var_AmountPos := 0;
                    var_UnitCostPos := 0;

                    var_Neg := 0;
                    var_AmountNeg := 0;
                    var_UnitCostNeg := 0;
                    CalcFields("Document Invoice No.");

                    IF "Item Ledger Entry".Quantity > 0 THEN BEGIN
                        var_Pos := "Item Ledger Entry".Quantity;
                        "Item Ledger Entry".CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Actual Cal.)");
                        var_AmountPos := "Item Ledger Entry"."Cost Amount (Actual Cal.)";
                        IF var_Pos <> 0 THEN
                            var_UnitCostPos := var_AmountPos / var_Pos;

                    END
                    ELSE BEGIN
                        var_Neg := "Item Ledger Entry".Quantity;
                        "Item Ledger Entry".CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Actual Cal.)");
                        var_AmountNeg := "Item Ledger Entry"."Cost Amount (Actual Cal.)";
                        IF var_Neg <> 0 THEN
                            var_UnitCostNeg := var_AmountNeg / var_Neg;
                    END;

                    var_OpeningBalance := var_OpeningBalance + "Item Ledger Entry".Quantity;
                    "Item Ledger Entry".CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Actual Cal.)");
                    var_Amount := var_Amount + "Item Ledger Entry"."Cost Amount (Actual Cal.)";

                    var_UnitCost := 0;
                    IF var_OpeningBalance <> 0 THEN
                        var_UnitCost := (var_Amount / var_OpeningBalance);



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
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
            begin

                var_Description := Description + ' ' + "Description 2" + ' Base Unit of Measure ' + "Base Unit of Measure";


                var_TotalQuantity := 0;
                var_TotalPos := 0;
                var_TotalNeg := 0;
                var_OpeningBalance := 0;
                var_Amount := 0;
                var_UnitCost := 0;
                var_OpeningBalance2 := 0;
                var_Amount2 := 0;
                var_UnitCost2 := 0;


                IF var_ItemDateFilter <> '' THEN
                    IF GETRANGEMIN("Date Filter") > 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        SETFILTER("Location Filter", GETFILTER("Location Filter"));

                        CALCFIELDS("Net Change");
                        var_OpeningBalance2 := "Net Change";


                        SETFILTER("Date Filter", var_ItemDateFilter);
                    END;

                IF var_ItemDateFilter <> '' THEN begin
                    Evaluate(StartingDate, '01010000D');
                    IF GETRANGEMIN("Date Filter") > StartingDate THEN BEGIN
                        ItemLedgerEntry.RESET();
                        ItemLedgerEntry.SETFILTER("Item No.", '%1', "No.");
                        ItemLedgerEntry.SETRANGE("Posting Date", StartingDate, GETRANGEMIN("Date Filter") - 1);
                        ItemLedgerEntry.SETRANGE("Date Filter", StartingDate, GETRANGEMIN("Date Filter") - 1);
                        ItemLedgerEntry.SETFILTER("Location Code", GETFILTER("Location Filter"));
                        IF ItemLedgerEntry.FIND('-') THEN
                            REPEAT
                                ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Actual Cal.)");
                                var_Amount2 += ItemLedgerEntry."Cost Amount (Actual Cal.)";
                            UNTIL ItemLedgerEntry.NEXT() = 0;
                    END;
                end;


                IF (var_Amount2 <> 0) AND (var_OpeningBalance2 <> 0) THEN
                    var_UnitCost2 := var_Amount2 / var_OpeningBalance2;

                var_OpeningBalance := var_OpeningBalance2;
                var_Amount := var_Amount2;
                var_UnitCost := var_UnitCost2;
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

                group(Summary)
                {
                    Caption = 'Summary';
                    field(var_ShowSummary; var_ShowSummary)
                    {
                        Caption = 'Show Summary';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Show Summary field.';
                    }

                }

            }
        }


    }


    trigger OnPreReport()

    begin
        CompanyInfo.GET();
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
        FunctionCenter: Codeunit "Function Center";
        var_Description: Text;
        var_Pos: Decimal;
        var_Neg: Decimal;
        var_UnitCostPos: Decimal;
        var_UnitCostNeg: Decimal;
        var_AmountPos: Decimal;
        var_AmountNeg: Decimal;
        var_OpeningBalance: Decimal;
        var_OpeningBalance2: Decimal;
        var_TotalQuantity: Decimal;
        var_TotalPos: Decimal;
        var_TotalNeg: Decimal;
        var_ItemDateFilter: Text;
        var_flightno: Text[30];

        CompanyInfo: Record 79;
        var_ItemNo: Text;
        var_ItemLocationFilter: Text;
        var_ItemProductGroupCode: Text;
        var_ItemLedDocumentNo: Text;
        var_ItemLedLocationCode: Text;
        var_ItemLedEntryType: Text;
        _USERID: Text[100];
        var_Amount2: Decimal;
        var_UnitCost2: Decimal;
        var_Amount: Decimal;
        var_UnitCost: Decimal;
        var_ShowSummary: Boolean;
        ItemFilter: Text;
        StartingDate: Date;
}

