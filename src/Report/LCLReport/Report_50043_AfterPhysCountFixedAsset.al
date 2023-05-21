report 50043 "After Phys.Count FA"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50043_AfterPhysCountFixedAsset.rdl';
    PreviewMode = PrintLayout;
    Caption = 'After Phys. Count Fixed Asset';
    dataset
    {
        dataitem("FA Journal Line"; "FA Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.")
                                ORDER(Ascending);
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(QtyCalculated_FAJournalLine; "FA Journal Line"."Qty. Calculated")
            {
            }
            column(QtyPhysInventory_FAJournalLine; "FA Journal Line"."Qty. Phys. Inventory")
            {
            }
            column(PhysCountStatus_FAJournalLine; "FA Journal Line"."Phys. Count Status")
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

            trigger OnAfterGetRecord()
            begin
                IF "FA Journal Line"."Qty. Phys. Inventory" = 0 THEN
                    vgTextWriteoff := '** ค้นหาไม่เจอ รอตัดจำหน่าย **';
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

        vgFilterText := "FA Journal Line".GETFILTERS;
    end;

    var
        ImageStorage: Record "Image Storage";
        CodeUnitFunction: Codeunit "Function Center";
        CompanyInformation: Record "Company Information";
        vgUserIDText: Text[50];
        vgFilterText: Text[200];
        vgFADepreciationBookRec: Record "FA Depreciation Book";
        vgTextWriteoff: Text[50];
}

