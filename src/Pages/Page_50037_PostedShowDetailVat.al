page 50037 "Posted ShowDetail Vat"
{
    Caption = 'ShowDetail Vat';
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
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice Date"; Rec."Tax Invoice Date")
                {
                    ApplicationArea = all;
                }
                field("Tax Vendor No."; Rec."Tax Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice No."; Rec."Tax Invoice No.")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice Name"; Rec."Tax Invoice Name")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice Base"; Rec."Tax Invoice Base")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice Amount"; Rec."Tax Invoice Amount")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice Address"; Rec."Tax Invoice Address")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice City"; Rec."Tax Invoice City")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice Post Code"; Rec."Tax Invoice Post Code")
                {
                    ApplicationArea = all;
                }

                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = all;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                    ApplicationArea = all;
                }

            }

        }

    }
}