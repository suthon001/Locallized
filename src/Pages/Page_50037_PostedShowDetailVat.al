/// <summary>
/// Page Posted ShowDetail Vat (ID 50037).
/// </summary>
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
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on this journal line.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the VAT business posting group code that will be used when you post the entry on the journal line.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
                }
                field("Tax Invoice Date"; Rec."Tax Invoice Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice Date field.';
                }
                field("Tax Vendor No."; Rec."Tax Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Vendor/Cutomer No. field.';
                }
                field("Tax Invoice No."; Rec."Tax Invoice No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice No. field.';
                }
                field("Tax Invoice Name"; Rec."Tax Invoice Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice Name field.';
                }
                field("Tax Invoice Base"; Rec."Tax Invoice Base")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice Base field.';
                }
                field("Tax Invoice Amount"; Rec."Tax Invoice Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice Amount field.';
                }
                field("Tax Invoice Address"; Rec."Tax Invoice Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice Address field.';
                }
                field("Tax Invoice City"; Rec."Tax Invoice City")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice City field.';
                }
                field("Tax Invoice Post Code"; Rec."Tax Invoice Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Invoice Post Code field.';
                }

                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Branch Code field.';
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