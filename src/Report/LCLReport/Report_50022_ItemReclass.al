Report 50022 "ItemReclass"
{
    RDLCLayout = './LayoutReport/LCLReport/Report_50022_ItemReclass.rdl';
    DefaultLayout = RDLC;
    Caption = 'Item Reclass';
    PdfFontEmbedding = yes;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(Journal_Template_Name; "Journal Template Name") { }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(Document_Date; format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Document_No_; "Document No.") { }
            column(Item_No_; "Item No.") { }
            column(Description; Description + ' ' + "Description 2") { }
            column(Location_Code; "Location Code") { }
            column(New_Location_Code; "New Location Code") { }
            column(Bin_Code; "Bin Code") { }
            column(New_Bin_Code; "New Bin Code") { }
            column(Document_Type; "Document Type") { }
            column(Entry_Type; "Entry Type") { }
            column(Quantity; Quantity) { }
            column(Unit_Cost; "Unit Cost") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(CompanyInfor_picture; CompanyInfor.Picture) { }
            column(Line_No_; "Line No.") { }
            column(LineNo; LineNo) { }
            column(CreateDocBy; "Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(ItemJournalBatch_description; ItemJournalBatch.Description) { }
            dataitem("Reservation Entry"; "Reservation Entry")
            {
                DataItemTableView = sorting("Entry No.", Positive);
                DataItemLink = "Source ID" = field("Journal Template Name"), "Source Batch Name" = field("Journal Batch Name"), "Source Ref. No." = field("Line No.");

                column(LotAndSeries; LotAndSeries) { }
                column(Reservetion_Quantity; Quantity) { }
                column(Reservetion_Expiration_Date; "Expiration Date") { }


                column(LotSeriesCaption; LotSeriesCaption) { }
                trigger OnAfterGetRecord()
                begin
                    LotAndSeries := '';
                    LineLotSeries += 1;
                    if "Lot No." <> '' then begin
                        LotAndSeries := "Lot No.";
                        LotSeriesCaption := 'Lot No. :';
                    end else begin
                        LotAndSeries := "Serial No.";
                        LotSeriesCaption := 'Series No. :';
                    end;
                    if LineLotSeries > 1 then
                        LotSeriesCaption := '';


                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInfor.GET();
                CompanyInfor.CalcFields(Picture);
                FunctionCenter."CompanyInformation"(ComText, false);
                FilterDescription := GetFilters;
            end;

            trigger OnAfterGetRecord()
            var
                NewDate: Date;
            begin
                if "Item No." <> '' then
                    LineNo += 1;
                if SplitDate[1] = '' then begin
                    NewDate := DT2Date("Create DateTime");
                    SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                    SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                    SplitDate[3] := Format(NewDate, 0, '<Year4>');
                end;
                ItemJournalBatch.GET("Journal Template Name", "Journal Batch Name");
            end;

        }
    }
    var
        LotSeriesCaption: Text[50];
        LineLotSeries: Integer;
        LotAndSeries: Code[30];
        LineNo: Integer;
        ComText: array[10] of Text[250];
        CompanyInfor: Record "Company Information";
        FunctionCenter: Codeunit "Function Center";
        FilterDescription: Text[1024];
        SplitDate: array[3] of Text[50];
        ItemJournalBatch: Record "Item Journal Batch";


}