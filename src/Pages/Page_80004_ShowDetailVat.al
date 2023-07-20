/// <summary>
/// Page NCT ShowDetail Vat (ID 80004).
/// </summary>
page 80004 "NCT ShowDetail Vat"
{
    Caption = 'Show Vat';
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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the type of transaction.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Tax Invoice Date"; Rec."NCT Tax Invoice Date")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Date';
                    ToolTip = 'Specifies the value of the Tax Invoice Date field.';
                }
                field("Tax Vendor No."; Rec."NCT Tax Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Vendor/Cutomer No. field.';
                }
                field("Tax Invoice No."; Rec."NCT Tax Invoice No.")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice No.';
                    ToolTip = 'Specifies the value of the Tax Invoice No. field.';
                }
                field("Tax Invoice Name"; Rec."NCT Tax Invoice Name")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Name';
                    ToolTip = 'Specifies the value of the Tax Invoice Name field.';
                }
                field("Tax Invoice Base"; Rec."NCT Tax Invoice Base")
                {
                    Caption = 'Tax Invoice Base';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice Base field.';
                }
                field("Tax Invoice Amount"; Rec."NCT Tax Invoice Amount")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Amount';
                    ToolTip = 'Specifies the value of the Tax Invoice Amount field.';
                }
                field("Tax Invoice Address"; Rec."NCT Tax Invoice Address")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Address';
                    ToolTip = 'Specifies the value of the Tax Invoice Address field.';
                }
                field("Tax Invoice City"; Rec."NCT Tax Invoice City")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice City';
                    ToolTip = 'Specifies the value of the Tax Invoice City field.';
                }
                field("Tax Invoice Post Code"; Rec."NCT Tax Invoice Post Code")
                {
                    ApplicationArea = all;
                    Caption = 'Tax Invoice Post Code';
                    ToolTip = 'Specifies the value of the Tax Invoice Post Code field.';
                }

                field("Head Office"; Rec."NCT Head Office")
                {
                    ApplicationArea = all;
                    Caption = 'Head Office';
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."NCT VAT Branch Code")
                {
                    ApplicationArea = all;
                    Caption = 'VAT Branch Code';
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }

            }

        }

    }
}