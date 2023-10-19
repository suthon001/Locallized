/// <summary>
/// Report Fixed Asset Write off (ID 80042).
/// </summary>
report 80042 "NCT Fixed Asset Write off"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80042_FixedAssetWriteoff.rdl';
    Caption = 'รายงานการตัดจำหน่ายทรัพย์สิน (Write-Off)';
    PreviewMode = PrintLayout;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Location Code", "FA Class Code";
            column(CompanyInformationName; CompanyInformation.Name)
            {
            }
            column(vgGetFilters; vgGetFilters)
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
            column(vgDcoumentNo; vgDcoumentNo)
            {
            }
            column(No_FixedAsset; "Fixed Asset"."No.")
            {
            }
            column(Description_FixedAsset; "Fixed Asset".Description)
            {
            }
            column(vgAcqDate; vgAcqDate)
            {
            }
            column(vgWriteOffDate; vgWriteOffDate)
            {
            }
            column(vgAcqCost; vgAcqCost)
            {
            }
            column(vgAccDepre; vgAccDepre)
            {
            }
            column(vgBookValue; vgBookValue)
            {
            }

            trigger OnAfterGetRecord()
            begin
                vgAcqCost := 0;
                vgAcqDate := 0D;

                IF NOT FADeprBook.GET("No.", DeprBookCode) THEN
                    CurrReport.SKIP()
                ELSE
                    IF (FADeprBook."Disposal Date" = 0D) OR ((FADeprBook."Disposal Date" < vgStartDateFilter) OR (FADeprBook."Disposal Date" > vgEndDateFilter)) THEN
                        CurrReport.SKIP()
                    ELSE
                        vgWriteOffDate := FADeprBook."Disposal Date";

                FALedgerEntry.RESET();
                FALedgerEntry.SETFILTER("FA No.", '%1', "No.");
                FALedgerEntry.SETFILTER("Depreciation Book Code", '%1', FADeprBook."Depreciation Book Code");
                FALedgerEntry.SETFILTER("Document Type", '%1', FALedgerEntry."Document Type"::Invoice);
                IF FALedgerEntry.FINDFIRST() THEN
                    CurrReport.SKIP();

                FALedgerEntry.RESET();
                FALedgerEntry.SETFILTER("FA No.", '%1', "No.");
                FALedgerEntry.SETFILTER("Depreciation Book Code", '%1', FADeprBook."Depreciation Book Code");
                FALedgerEntry.SETFILTER("FA Posting Type", '%1', FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                FALedgerEntry.SETFILTER("FA Posting Category", '%1', FALedgerEntry."FA Posting Category"::" ");
                IF FALedgerEntry.FINDFIRST() THEN BEGIN
                    vgAcqDate := FALedgerEntry."Posting Date";
                    FALedgerEntry.CalcSums(Amount);
                    vgAcqCost := FALedgerEntry.Amount;

                END;

                IF NOT FAPostingGroup.GET(FADeprBook."FA Posting Group") THEN
                    FAPostingGroup.INIT();


                vgFALocationName := CodeUnitFunction."GetNameFALocation"("FA Location Code");
                vgFAClassName := CodeUnitFunction."GetNameFAClass"("FA Class Code");
                vgFASubClassName := CodeUnitFunction."GetNameFASubClass"("FA Subclass Code");

                FALedgerEntry.RESET();
                FALedgerEntry.SETFILTER("FA No.", '%1', "No.");
                FALedgerEntry.SETFILTER("Depreciation Book Code", '%1', FADeprBook."Depreciation Book Code");
                FALedgerEntry.SETFILTER("Part of Book Value", '%1', TRUE);
                FALedgerEntry.SETFILTER("FA Posting Category", '%1', FALedgerEntry."FA Posting Category"::" ");
                IF FALedgerEntry.FIND('-') THEN BEGIN

                    FALedgerEntry.CalcSums(Amount);
                    vgBookValue := FALedgerEntry.Amount;

                END;

                FALedgerEntry.RESET();
                FALedgerEntry.SETFILTER("FA No.", '%1', "No.");
                FALedgerEntry.SETFILTER("Depreciation Book Code", '%1', FADeprBook."Depreciation Book Code");
                FALedgerEntry.SETFILTER("Part of Book Value", '%1', TRUE);
                FALedgerEntry.SETFILTER("FA Posting Category", '%1', FALedgerEntry."FA Posting Category"::" ");
                FALedgerEntry.SETFILTER("FA Posting Type", '%1', FALedgerEntry."FA Posting Type"::Depreciation);
                IF FALedgerEntry.FIND('-') THEN BEGIN
                    FALedgerEntry.CalcSums(Amount);
                    vgAccDepre := FALedgerEntry.Amount;

                END;
            end;

            trigger OnPreDataItem()
            begin
                IF DeprBookCode = '' THEN
                    ERROR('Please Select Depreciation Book Code!!');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(DeprBookCode; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies the code for the depreciation book to be included in the report or batch job.';
                    }
                    field(vgStartDateFilter; vgStartDateFilter)
                    {
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the value of the Start Date field.';
                        ApplicationArea = All;
                    }
                    field(vgEndDateFilter; vgEndDateFilter)
                    {
                        Caption = 'End Date';
                        ToolTip = 'Specifies the value of the End Date field.';
                        ApplicationArea = All;
                    }
                }
            }
        }


    }



    trigger OnPreReport()
    begin
        CompanyInformation.GET();
        vgGetFilters := "Fixed Asset".GETFILTERS;
    end;

    var
        FALedgerEntry: Record "FA Ledger Entry";
        vgAcqDate: Date;
        vgAcqCost: Decimal;
        FADeprBook: Record "FA Depreciation Book";
        DeprBookCode: Code[10];
        vgDcoumentNo: Code[30];
        FAPostingGroup: Record "FA Posting Group";
        CodeUnitFunction: Codeunit "NCT Function Center";
        vgFALocationName: Text;
        vgFAClassName: Text;
        vgFASubClassName: Text;
        CompanyInformation: Record "Company Information";
        vgGetFilters: Text;
        vgBookValue: Decimal;
        vgStartDateFilter: Date;
        vgEndDateFilter: Date;
        vgAccDepre: Decimal;
        vgWriteOffDate: Date;
}

