report 50017 "Purchase Billing"
{
    Caption = 'Purchase Billing';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50017_PurchaseBilling.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    dataset
    {
        dataitem(BWBillingReceiptHeader; "Billing Receipt Header")
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
            column(BW_Amount__LCY_; "Amount (LCY)") { }
            column(AmtText; AmtText) { }
            column(BW_Due_Date; format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            dataitem("Billing & Receipt Line"; "Billing Receipt Line")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                DataItemLink = "Document Type" = field("Document Type"), "DOcument No." = field("NO.");

                column(BW_Source_Document_Date; format("Source Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(BW_Source_Ext__Document_No_; "Source Ext. Document No.") { }
                column(BW_Source_Posting_Date; format("Source Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(BW_Source_Due_Date; format("Source Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(BW_Source_Description; "Source Description") { }
                column(BW_Source_Amount__LCY_; "Source Amount (LCY)") { }
                column(BW_Source_Document_No_; "Source Document No.") { }

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
                FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", false);
                FunctionCenter."ConvExchRate"("Currency Code", "Currency Factor", ExchangeRate);
                FunctionCenterII."SalesBillingReceiptInformation"(CustVend, "Document Type", "No.");
                NewDate := DT2Date("Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                if not PaymentTerm.GET("Payment Terms Code") then
                    PaymentTerm.init();

                AmtText := FunctionCenter."NumberThaiToText"("Amount (LCY)");
            end;

        }

    }
    var
        ComText: array[10] of Text[250];
        CustVend: array[10] of Text[250];
        FunctionCenter: Codeunit "Function Center";
        FunctionCenterII: Codeunit "Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        SplitDate: Array[3] of Text[20];
        AmtText: Text;
        PaymentTerm: Record "Payment Terms";

}
