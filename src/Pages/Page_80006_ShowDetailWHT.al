/// <summary>
/// Page NCT ShowDetailWHT (ID 80006).
/// </summary>
page 80006 "NCT ShowDetailWHT"
{
    Caption = 'Show WHT';
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
                field("WHT Document No."; Rec."NCT WHT Document No.")
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
                    trigger OnValidate()
                    var
                        Cust: Record Customer;
                    begin
                        if not Cust.get(Rec."NCT WHT Cust/Vend No.") then
                            Cust.init();
                        Rec."NCT WHT Name" := Cust.Name;
                        Rec."NCT WHT Name 2" := Cust."Name 2";
                        Rec."NCT WHT Address" := Cust.Address;
                        Rec."NCT WHT Address 2" := Cust."Address 2";
                        Rec."NCT WHT Registration No." := Cust."VAT Registration No.";
                        Rec."NCT WHT Post Code" := Cust."Post Code";
                        Rec."NCT WHT City" := Cust.City;
                        Rec."NCT WHT County" := Cust.County;
                        Rec.Modify();
                    end;
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