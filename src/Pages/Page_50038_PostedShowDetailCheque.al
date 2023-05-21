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
                }
                field("Customer/Vendor No."; Rec."Customer/Vendor No.")
                {
                    ApplicationArea = all;


                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                }
                field("Pay Name"; Rec."Pay Name")
                {
                    ApplicationArea = all;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                }

                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = all;
                }

                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = all;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = all;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }



}