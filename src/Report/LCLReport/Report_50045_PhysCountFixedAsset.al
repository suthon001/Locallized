report 50045 "Phys. Count Fixed Asset"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50045_PhysCountFixedAsset.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Phys. Count Fixed Asset';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "FA Location Code";
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
                vgFADepreciationBookRec.SETFILTER("FA No.", '%1', "No.");
                vgFADepreciationBookRec.SETFILTER("Depreciation Book Code", '%1', 'COMPANY');
                IF vgFADepreciationBookRec.FindFirst() THEN BEGIN
                    vgFADepreciationBookRec.CALCFIELDS("Acquisition Cost");
                    vgFADepreciationBookRec.CALCFIELDS("Book Value");
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.GET();

        vgUserIDText := COPYSTR(USERID(), 1, 50);
        vgUserIDText := CodeUnitFunction."GetName"(vgUserIDText);

        vgFilterText := "Fixed Asset".GETFILTERS();
    end;

    var
        TenantMedia: Record "Tenant Media";
        CodeUnitFunction: Codeunit "Function Center";
        CompanyInformation: Record "Company Information";
        vgUserIDText: Text[50];
        vgFilterText: Text;
        vgFADepreciationBookRec: Record "FA Depreciation Book";
}

