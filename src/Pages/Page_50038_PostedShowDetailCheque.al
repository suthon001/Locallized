/// <summary>
/// Page Posted ShowDetail Cheque (ID 50038).
/// </summary>
page 50038 "Posted ShowDetail Cheque"
{
    Caption = 'Show Detail Cheque';
    SourceTable = "Posted Gen. Journal Line";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Customer/Vendor No."; Rec."Customer/Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer/Vendor No. field.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Pay Name"; Rec."Pay Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Name field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }

                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Branch No. field.';
                }

                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Code field.';
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