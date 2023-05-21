report 50045 "Phys. Count Fixed Asset"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50045_PhysCountFixedAsset.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Phys. Count Fixed Asset';
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
            column(ImageStorageImage; ImageStorage."Image")
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
                CLEAR(ImageStorage);
                ImageStorage.RESET;
                ImageStorage.SETFILTER("Entry No.", '%1', "Ref. Image Entry No.");
                IF ImageStorage.FIND('-') THEN
                    ImageStorage.CALCFIELDS("Image")
                ELSE
                    CLEAR(ImageStorage);

                vgFADepreciationBookRec.RESET;
                vgFADepreciationBookRec.SETFILTER("FA No.", '%1', "No.");
                vgFADepreciationBookRec.SETFILTER("Depreciation Book Code", '%1', 'COMPANY');
                IF vgFADepreciationBookRec.FIND('-') THEN BEGIN
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
        CompanyInformation.GET;

        vgUserIDText := USERID;
        vgUserIDText := CodeUnitFunction."GetName"(vgUserIDText);

        vgFilterText := "Fixed Asset".GETFILTERS;
    end;

    var
        ImageStorage: Record "Image Storage";
        CodeUnitFunction: Codeunit "Function Center";
        CompanyInformation: Record "Company Information";
        vgUserIDText: Text[50];
        vgFilterText: Text[200];
        vgFADepreciationBookRec: Record "FA Depreciation Book";
}

