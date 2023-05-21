report 50049 "GL Journal Report"
{
    Caption = 'G/L Journal Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    RDLCLayout = './LayoutReport/LCLReport/Report_50049_GlJournalReport.rdl';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = SORTING("G/L Account No.", "Document No.", "Posting Date") ORDER(Ascending);
            RequestFilterFields = "Document No.", "Posting Date";
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Posting_Date; format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Document_No_; "Document No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Debit_Amount; "Debit Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Description; Description) { }
            column(BW_Journal_Description; "Journal Description") { }
            column(G_L_Account_Name; "G/L Account Name") { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(USERID; USERID) { }
            column(CurrentDateTime; CurrentDateTime) { }
            column(FilterDescription; FilterDescription) { }
            column(CompanyInfor_Name; CompanyInfor.Name + ' ' + CompanyInfor."Name 2") { }
            trigger OnPreDataItem()
            begin
                CompanyInfor.GET;
                FilterDescription := GetFilters();
            end;

        }

    }
    var
        CompanyInfor: Record "Company Information";
        FilterDescription: Text[1024];

}
