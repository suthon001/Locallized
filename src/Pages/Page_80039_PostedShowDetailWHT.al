/// <summary>
/// Page NCT PostedShowDetailWHT (ID 80039).
/// </summary>
page 80039 "NCT PostedShowDetailWHT"
{
    Caption = 'Show WHT';
    SourceTable = "Posted Gen. Journal Line";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
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
                field("WHT No."; Rec."NCT WHT Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Document No. field.';
                }
                field("WHT Date"; Rec."NCT WHT Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Date field.';
                }
                field("Customer/Vendor"; Rec."NCT WHT Cust/Vend No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    TableRelation = Customer."No.";
                    ToolTip = 'Specifies the value of the Customer No. field.';

                }
                field("WHT Name"; Rec."NCT WHT Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Name field.';
                }
                field("WHT Name 2"; Rec."NCT WHT Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Name 2 field.';
                }
                field("WHT Address"; Rec."NCT WHT Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Address field.';
                }
                field("WHT Address 2"; Rec."NCT WHT Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Address 2 field.';
                }
                field("WHT City"; Rec."NCT WHT City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT City field.';
                }
                field("WHT County"; Rec."NCT WHT County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT County field.';
                }
                field("WHT Post Code"; Rec."NCT WHT Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Post Code field.';
                }
                field("WHT Registration No."; Rec."NCT WHT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Registration No. field.';
                }
                field("WHT Business Posting Group"; Rec."NCT WHT Business Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                }
                field("WHT Product Posting Group"; Rec."NCT WHT Product Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Posting Group field.';
                }
                field("WHT Base"; Rec."NCT WHT Base")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Base field.';
                }
                field("WHT %"; Rec."NCT WHT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT % field.';
                }
                field("WHT Amount"; Rec."NCT WHT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }

            }
        }
    }
}