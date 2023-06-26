/// <summary>
/// Page NCT Posted ShowDetail Cheque (ID 80038).
/// </summary>
page 80038 "NCT Posted ShowDetail Cheque"
{
    Caption = 'Show Cheque';
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
                field("Customer/Vendor No."; Rec."NCT Customer/Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer/Vendor No. field.';
                }
                field("Bank Account No."; Rec."NCT Bank Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Pay Name"; Rec."NCT Pay Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Name field.';
                }
                field("Bank Name"; Rec."NCT Bank Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }

                field("Bank Branch No."; Rec."NCT Bank Branch No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Branch No. field.';
                }

                field("Bank Code"; Rec."NCT Bank Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Cheque No."; Rec."NCT Cheque No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field("Cheque Date"; Rec."NCT Cheque Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque Date field.';
                }
            }
        }
    }



}