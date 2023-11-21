/// <summary>
/// Report Compare Phys. Count FA (ID 80044).
/// </summary>
report 80044 "NCT Compare Phys. Count FA"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80044_ComparePhysCountFA.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Fixed Asset - Property Comparison';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("FA Journal Line"; "FA Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.") ORDER(Ascending);
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(QtyCalculated_FAJournalLine; "FA Journal Line"."NCT Qty. Calculated")
            {
            }
            column(QtyPhysInventory_FAJournalLine; "FA Journal Line"."NCT Qty. Phys. Inventory")
            {
            }
            column(PhysCountStatus_FAJournalLine; "FA Journal Line"."NCT Phys. Count Status")
            {
            }
            column(FAPhysLocationCode_FAJournalLine; "FA Journal Line"."NCT FA Phys. Location Code")
            {
            }
            column(vgTextWriteoff; vgTextWriteoff)
            {
            }
            dataitem("Fixed Asset"; "Fixed Asset")
            {
                DataItemLink = "No." = FIELD("FA No.");
                column(CompanyInformationName; CompanyInformation.Name)
                {
                }
                column(vgFilterText; vgFilterText)
                {
                }
                column(vgUserIDText; vgUserIDText)
                {
                }
                column(No_FixedAsset; "Fixed Asset"."No.")
                {
                }
                column(Description_FixedAsset; "Fixed Asset".Description)
                {
                }
                column(FALocationCode_FixedAsset; "Fixed Asset"."FA Location Code")
                {
                }
                column(ResponsibleEmployee_FixedAsset; "Fixed Asset"."Responsible Employee")
                {
                }
                column(ImageStorageImage; TenantMedia.Content)
                {
                }
                column(FADepreciationBookAcqCost; vgFADepreciationBookRec."Acquisition Cost")
                {
                }
                column(FADepreciationBookBookValue; vgFADepreciationBookRec."Book Value")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(TenantMedia);
                    if TenantMedia.GET(Image.MediaId) then
                        TenantMedia.CalcFields(Content);
                    vgFADepreciationBookRec.RESET();
                    vgFADepreciationBookRec.SetRange("FA No.", "No.");
                    IF vgFADepreciationBookRec.FindFirst() THEN BEGIN
                        vgFADepreciationBookRec.CALCFIELDS("Acquisition Cost");
                        vgFADepreciationBookRec.CALCFIELDS("Book Value");
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF "NCT FA Location Code" = "NCT FA Phys. Location Code" THEN
                    CurrReport.SKIP();

                IF "FA Journal Line"."NCT Qty. Phys. Inventory" = 0 THEN
                    vgTextWriteoff := '** ค้นหาไม่เจอ รอตัดจำหน่าย **';
            end;
        }
    }



    trigger OnPreReport()
    begin
        CompanyInformation.GET();

        vgUserIDText := COPYSTR(USERID, 1, 50);
        vgUserIDText := CodeUnitFunction."GetName"(vgUserIDText);

        vgFilterText := "FA Journal Line".GETFILTERS;
    end;

    var

        CodeUnitFunction: Codeunit "NCT Function Center";
        CompanyInformation: Record "Company Information";
        vgUserIDText: Text[50];
        vgFilterText: Text;
        vgFADepreciationBookRec: Record "FA Depreciation Book";
        vgTextWriteoff: Text[50];
        TenantMedia: Record "Tenant Media";
}

