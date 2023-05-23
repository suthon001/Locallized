/// <summary>
/// Page ShowDetail Cheque (ID 50005).
/// </summary>
page 50005 "ShowDetail Cheque"
{
    Caption = 'Show Cheque';
    SourceTable = "Gen. Journal Line";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                group("Pay Information")
                {
                    ShowCaption = false;
                    field("Document No."; Rec."Document No.")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        ToolTip = 'Specifies a document number for the journal line.';
                    }
                    field("Bank Code"; Rec."Bank Code")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_PayBankCode;
                        ToolTip = 'Specifies the value of the Bank Code field.';
                        trigger OnValidate()
                        begin
                            "SetBankBranch"();
                        end;
                    }
                    field("Bank Account No."; Rec."Bank Account No.")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_PayBankAccount;
                        ToolTip = 'Specifies the value of the Bank Account No. field.';
                    }
                    field("Bank Name"; Rec."Bank Name")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_PayBankName;
                        ToolTip = 'Specifies the value of the Bank Name field.';
                    }
                    field(BankAccBranch; BankAccBranch)
                    {
                        CaptionClass = Caption_PayBankBranch;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BankAccBranch field.';
                    }


                }
                group("Cheque Information")
                {
                    field("Customer/Vendor No."; Rec."Customer/Vendor No.")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_CustVendNo;
                        ToolTip = 'Specifies the value of the Customer/Vendor No. field.';
                    }

                    field("Pay Name"; Rec."Pay Name")
                    {
                        ApplicationArea = all;
                        CaptionClass = Cpation_CustVendName;
                        ToolTip = 'Specifies the value of the Pay Name field.';
                    }

                    field("Bank Branch No."; Rec."Bank Branch No.")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Bank Branch No. field.';
                    }

                    field("Cheque No."; Rec."Cheque No.")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Cheque No. field.';
                    }
                    field("Cheque Date"; Rec."Cheque Date")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Cheque Date field.';
                    }
                }
            }
        }
    }
    trigger OnAfterGetRecord();
    var
        RecGenJnlLine: Record "Gen. Journal Line";
    begin
        "SetBankBranch"();
        if Rec."Account Type" = Rec."Account Type"::Customer Then begin
            Caption_CustVendNo := 'Customer No.';
            Cpation_CustVendName := 'Customer Name';
            Caption_PayBankCode := 'Pay-in Bank Code';
            Caption_PayBankAccount := 'Pay-in Bank Account No.';
            Caption_PayBankName := 'Pay-in Bank Name';
            Caption_PayBankBranch := 'Pay-in Bank Branch No.';
            RecGenJnlLine.RESET();
            RecGenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            RecGenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            RecGenJnlLine.SetRange("Document No.", Rec."Document No.");
            RecGenJnlLine.SetRange("Account Type", Rec."Account Type"::Customer);
            RecGenJnlLine.SetFilter("Account No.", '<>%1', 'Z-PDC');
            if RecGenJnlLine.FindFirst() Then begin

                Rec.Validate("Customer/Vendor No.", RecGenJnlLine."Account No.");
                Rec.Modify(true);
            end;
        end else
            if Rec."Account Type" = Rec."Account Type"::Vendor then begin
                Caption_CustVendNo := 'Vendor No.';
                Cpation_CustVendName := 'Vendor Name';
                Caption_PayBankCode := 'Pay-from Bank Code';
                Caption_PayBankAccount := 'Pay-from Bank Account No.';
                Caption_PayBankName := 'Pay-from Bank Name';
                Caption_PayBankBranch := 'Pay-from Bank Branch No.';
                RecGenJnlLine.RESET();
                RecGenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                RecGenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                RecGenJnlLine.SetRange("Document No.", Rec."Document No.");
                RecGenJnlLine.SetRange("Account Type", Rec."Account Type"::Vendor);
                RecGenJnlLine.SetFilter("Account No.", '<>%1', 'Z-PDC');
                if RecGenJnlLine.FindFirst() Then begin
                    Rec.Validate("Customer/Vendor No.", RecGenJnlLine."Account No.");
                    Rec.Modify(true);
                end;
            end;

    end;

    /// <summary> 
    /// Description for SetBankBranch.
    /// </summary>
    procedure "SetBankBranch"()
    var
        BankAcc: Record "Bank Account";
    begin
        if not BankAcc.get(Rec."Bank Code") then
            BankAcc.init();
        BankAccBranch := BankAcc."Bank Branch No.";
    end;

    var
        Caption_CustVendNo: Text[100];
        Cpation_CustVendName: Text[100];
        Caption_PayBankCode: Text[100];
        Caption_PayBankAccount: Text[100];
        Caption_PayBankName: Text[100];
        Caption_PayBankBranch: Text[100];
        BankAccBranch: Text[20];

}