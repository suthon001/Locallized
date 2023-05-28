report 50046 "Bank Acc. Reconciliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50046_BankAccountReconciliation.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Report Bank Account Reconciliation';
    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", "Bank Acc. Posting Group", "Date Filter";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(No_BankAccount; "Bank Account"."No.")
            {
            }
            column(Name_BankAccount; "Bank Account".Name)
            {
            }
            column(BalanceatDate_BankAccount; "Bank Account"."Balance at Date")
            {
            }
            column(var_ShowFilter; var_ShowFilter)
            {
            }
            dataitem("Bank Account Ledger Entry 1"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Bank Account No.", "Document No.", "Posting Date", Open)
                                    WHERE(Open = CONST(true));
                column(PostingDate_BankAccountLedgerEntry1; "Bank Account Ledger Entry 1"."Posting Date")
                {
                }
                column(DocumentNo_BankAccountLedgerEntry1; "Bank Account Ledger Entry 1"."Document No.")
                {
                }
                column(Description_BankAccountLedgerEntry1; "Bank Account Ledger Entry 1".Description)
                {
                }
                column(Amount_BankAccountLedgerEntry1; "Bank Account Ledger Entry 1".Amount)
                {
                }
                column(ExternalDocumentNo_BankAccountLedgerEntry1; "Bank Account Ledger Entry 1"."External Document No.")
                {
                }
                column(DocumentDate_BankAccountLedgerEntry1; "Bank Account Ledger Entry 1"."Document Date")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    BankStatementBlance += ("Bank Account Ledger Entry 1".Amount * -1);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                BankStatementBlance += "Bank Account"."Balance at Date";
            end;

            trigger OnPreDataItem()
            begin
                var_ShowFilter := "Bank Account".GETFILTERS;
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) WHERE(Number = FILTER(1));
            column(BankStatementBlance; BankStatementBlance)
            {
            }
        }
    }




    var
        BankStatementBlance: Decimal;
        var_ShowFilter: Text;
}

