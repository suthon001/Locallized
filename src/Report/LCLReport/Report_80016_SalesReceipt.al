/// <summary>
/// Report Sales Receipt (ID 80016).
/// </summary>
report 80016 "NCT Sales Receipt"
{
    Caption = 'Sales Receipt';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80016_SalesReceipt.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    dataset
    {
        dataitem(BillingReceiptHeader; "NCT Billing Receipt Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.";
            CalcFields = "Amount (LCY)", "Amount";
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
            column(CustVend_1; CustVend[1]) { }
            column(CustVend_2; CustVend[2]) { }
            column(CustVend_3; CustVend[3]) { }
            column(CustVend_4; CustVend[4]) { }
            column(CustVend_5; CustVend[5]) { }
            column(CustVend_9; CustVend[9]) { }
            column(CustVend_10; CustVend[10]) { }
            column(CreateDocBy; "Create By User") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(Payment_Terms_Code; PaymentTerm.description) { }
            column(Amount__LCY_; "Amount") { }
            column(AmtText; AmtText) { }
            column(CaptionOptionThai; CaptionOptionThai) { }
            column(CaptionOptionEng; CaptionOptionEng) { }
            column(PaymentMethodMark_1; PaymentMethodMark[1]) { }
            column(PaymentMethodMark_2; PaymentMethodMark[2]) { }
            column(PaymentMethodMark_3; PaymentMethodMark[3]) { }
            dataitem(myLoop; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(Number; Number) { }
                column(OriginalCaption; OriginalCaption) { }
                dataitem("Billing & Receipt Line"; "NCT Billing Receipt Line")
                {
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    DataItemLink = "Document Type" = field("Document Type"), "DOcument No." = field("NO.");
                    DataItemLinkReference = BillingReceiptHeader;

                    column(Source_Document_Date; format("Source Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(Source_Ext__Document_No_; "Source Ext. Document No.") { }
                    column(Source_Posting_Date; format("Source Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(Source_Due_Date; format("Source Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(Source_Description; "Source Description") { }
                    column(Source_Amount__LCY_; "Source Amount") { }
                    column(Source_Document_No_; "Source Document No.") { }

                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoOfCopies + 1);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OriginalCaption := 'Original'
                    else
                        OriginalCaption := 'Copy';
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

            begin
                if "Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", true);
                FunctionCenter."ConvExchRate"("Currency Code", "Currency Factor", ExchangeRate);
                FunctionCenter."SalesBillingReceiptInformation"(CustVend, "Document Type", "No.");
                NewDate := DT2Date("Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                if not PaymentTerm.GET("Payment Terms Code") then
                    PaymentTerm.init();

                if "Currency Code" = '' then
                    AmtText := FunctionCenter."NumberThaiToText"("Amount")
                else
                    AmtText := FunctionCenter.NumberEngToText("Amount", "Currency Code");

                CLEAR(PaymentMethodMark);

                if "Payment Method Code" = 'CASH' then
                    PaymentMethodMark[1] := '/';

                if "Payment Method Code" in ['BANK', 'TRANSFER'] then begin
                    PaymentMethodMark[2] := '/';
                    if not BankAcc.GET(BillingReceiptHeader."Account No.") then
                        BankAcc.Init();
                    BankName := BankAcc.Name;
                    BankBranchNo := BankAcc."Bank Branch No.";
                end;

                if "Payment Method Code" in ['CHECK', 'CHEQUE'] then begin
                    PaymentMethodMark[3] := '/';
                    if not BankAcc.GET(BillingReceiptHeader."Account No.") then
                        BankAcc.Init();
                    BankName := BankAcc.Name;
                    BankBranchNo := BankAcc."Bank Branch No.";
                end;
            end;

        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Options")
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = all;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the value of the No. of Copies field.';
                        MinValue = 0;
                    }
                    field(CaptionOptionThai; CaptionOptionThai)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption (Thai)';
                        ToolTip = 'Specifies the value of the Caption field.';
                        trigger OnAssistEdit()
                        var
                            EvenCenter: Codeunit "NCT EventFunction";
                            ltDocumentType: Enum "NCT Document Type Report";
                        begin
                            EvenCenter.SelectCaptionReport(CaptionOptionThai, CaptionOptionEng, ltDocumentType::"Sales Receipt");
                        end;
                    }
                    field(CaptionOptionEng; CaptionOptionEng)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption (Eng)';
                        ToolTip = 'Specifies the value of the Caption field.';
                    }
                }
            }
        }


    }
    var
        BankAcc: Record "Bank Account";
        ComText: array[10] of Text[250];
        CustVend: array[10] of Text[250];
        FunctionCenter: Codeunit "NCT Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        SplitDate: Array[3] of Text[20];
        AmtText, BankName, BankBranchNo : Text;
        PaymentTerm: Record "Payment Terms";
        NoOfCopies: Integer;
        CaptionOptionEng, CaptionOptionThai, OriginalCaption : Text[50];
        PaymentMethodMark: array[3] of text[50];


}
