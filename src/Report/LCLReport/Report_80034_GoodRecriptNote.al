/// <summary>
/// Report Good Receipt Note (ID 80034).
/// </summary>
report 80034 "NCT Good Receipt Note"
{
    Caption = 'Good Receipt Note';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80034_GoodReceiptNote.rdl';
    UsageCategory = None;
    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(PostingDate; format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentDate; format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; "No.") { }
            column(ExchangeRate; ExchangeRate) { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(VendText_1; VendText[1]) { }
            column(VendText_2; VendText[2]) { }
            column(VendText_3; VendText[3]) { }
            column(VendText_4; VendText[4]) { }
            column(VendText_5; VendText[5]) { }
            column(VendText_9; VendText[9]) { }
            column(VendText_10; VendText[10]) { }
            column(CreateDocBy; "NCT Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }


            column(Payment_Terms_Code; PaymentTerm.Description) { }
            column(Expected_Receipt_Date; format("Expected Receipt Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(CommentText_1; CommentText[1]) { }
            column(CommentText_2; CommentText[2]) { }
            column(CommentText_3; CommentText[3]) { }
            column(CommentText_4; CommentText[4]) { }
            column(TotalQuantity; TotalQuantity) { }
            column(Order_No_; "Order No.") { }

            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = "Purch. Rcpt. Header";
                DataItemLink = "Document No." = field("No.");
                column(LineNo; LineNo) { }
                column(Line_No_; "Line No.") { }
                column(No_; "No.") { }
                column(Description; Description + ' ' + "Description 2") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Location_Code; "Location Code") { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(Line_Discount__; "Line Discount %") { }

                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemTableView = sorting("Entry No.");
                    DataItemLinkReference = "Purch. Rcpt. Line";
                    DataItemLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");
                    column(LotSeriesNo; LotSeriesNo) { }
                    column(Ledger_Entry_Quantity; Quantity) { }
                    column(Ledger_Entry_Location; "Location Code") { }
                    column(Ledger_Entry_Expiration_Date; format("Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(LotSeriesCaption; LotSeriesCaption) { }
                    trigger OnAfterGetRecord()
                    begin
                        LotSeriesNo := '';
                        LineLotSeries += 1;
                        if "Lot No." <> '' then begin
                            LotSeriesNo := "Lot No.";
                            LotSeriesCaption := 'Lot No. :';
                        end else begin
                            LotSeriesNo := "Serial No.";
                            LotSeriesCaption := 'Series No. :';
                        end;
                        if LineLotSeries > 1 then
                            LotSeriesCaption := '';
                    end;

                }
                trigger OnAfterGetRecord()
                begin
                    if "No." <> '' then
                        LineNo += 1;
                end;

            }

            trigger OnPreDataItem()
            begin
                companyInfor.get();
                companyInfor.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            var
                NewDate: Date;
                PurchaserecriptLine: Record "Purch. Rcpt. Line";
            begin

                if "Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", true);
                FunctionCenter."PurchasePostedVendorInformation"(0, "No.", VendText, 0);
                FunctionCenter."ConvExchRate"("Currency Code", "Currency Factor", ExchangeRate);
                FunctionCenter."GetPurchaseComment"(PurchaseType::Receipt, "No.", 0, CommentText);
                NewDate := DT2Date("NCT Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                PurchaserecriptLine.reset();
                PurchaserecriptLine.SetRange("Document No.", "No.");
                PurchaserecriptLine.CalcSums(Quantity);
                TotalQuantity := PurchaserecriptLine.Quantity;
                if not PaymentTerm.GET("Payment Terms Code") then
                    PaymentTerm.init();
            end;
        }
    }
    var
        LotSeriesCaption: Text[50];
        LineLotSeries: Integer;
        FunctionCenter: Codeunit "NCT Function Center";

        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        VendText: array[10] Of Text[250];
        SplitDate: Array[3] of Text[20];
        CommentText: Array[100] of Text[250];
        LineNo: Integer;
        LotSeriesNo: Code[50];
        TotalQuantity: Decimal;
        PaymentTerm: Record "Payment Terms";
        PurchaseType: Enum "Purchase Comment Document Type";
}
