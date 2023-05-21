page 50004 "ShowDetail Vat"
{
    Caption = 'Show Detail Vat';
    SourceTable = "Gen. Journal Line";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
    InsertAllowed = false;
    DeleteAllowed = false;
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
                    Caption = 'Tax Invoice Date';
                }
                field("Tax Vendor No."; Rec."Tax Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Tax Invoice No."; Rec."Tax Invoice No.")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice No.';
                }
                field("Tax Invoice Name"; Rec."Tax Invoice Name")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Name';
                }
                field("Tax Invoice Base"; Rec."Tax Invoice Base")
                {
                    Caption = 'Tax Invoice Base';
                    ApplicationArea = all;
                }
                field("Tax Invoice Amount"; Rec."Tax Invoice Amount")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Amount';
                }
                field("Tax Invoice Address"; Rec."Tax Invoice Address")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Address';
                }
                field("Tax Invoice City"; Rec."Tax Invoice City")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice City';
                }
                field("Tax Invoice Post Code"; Rec."Tax Invoice Post Code")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Post Code';
                }

                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                    Caption = 'Head Office';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = all;
                    Caption = 'Branch Code';
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