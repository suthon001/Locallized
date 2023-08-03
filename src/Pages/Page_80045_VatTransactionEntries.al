/// <summary>
/// Page NCT Vat Transaction Entries (ID 80045).
/// </summary>
page 80045 "NCT Vat Transaction Entries"
{
    ApplicationArea = All;
    Caption = 'Vat Transaction Entries';
    PageType = List;
    SourceTable = "NCT VAT Transections";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Calculation Type field.';
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }


                field("Unrealized VAT Type"; Rec."Unrealized VAT Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unrealized VAT Type field.';
                }
                field("Unrealized Amount"; Rec."Unrealized Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unrealized Amount field.';
                }
                field("Unrealized Base"; Rec."Unrealized Base")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unrealized Base field.';
                }
                field("Remaining Unrealized Amt."; Rec."Remaining Unrealized Amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remaining Unrealized Amount field.';
                }
                field("Remaining Unrealized Base"; Rec."Remaining Unrealized Base")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remaining Unrealized Base field.';
                }

                field("Tax Invoice No."; Rec."Tax Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice No. field.';
                }
                field("Tax Invoice Date"; Rec."Tax Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice Date field.';
                }
                field("Tax Invoice Base"; Rec."Tax Invoice Base")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice Base field.';
                }
                field("Tax Invoice Amount"; Rec."Tax Invoice Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice Amount field.';
                }
                field("Tax Vendor No."; Rec."Tax Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Vendor No. field.';
                }
                field("Tax Invoice Name"; Rec."Tax Invoice Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice Name field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
            }
        }
    }
}
