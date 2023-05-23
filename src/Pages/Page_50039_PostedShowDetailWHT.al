/// <summary>
/// Page PostedShowDetailWHT (ID 50039).
/// </summary>
page 50039 "PostedShowDetailWHT"
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
                field("WHT No."; Rec."WHT Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Document No. field.';
                }
                field("WHT Date"; Rec."WHT Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Date field.';
                }
                field("Customer/Vendor"; Rec."WHT Cust/Vend No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    TableRelation = Customer."No.";
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    trigger OnValidate()
                    var
                        Cust: Record Customer;
                    begin
                        if not Cust.get(Rec."WHT Cust/Vend No.") then
                            Cust.init();
                        Rec."WHT Name" := Cust.Name;
                        Rec."WHT Name 2" := Cust."Name 2";
                        Rec."WHT Address" := Cust.Address;
                        Rec."WHT Address 2" := Cust."Address 2";
                        Rec."WHT Registration No." := Cust."VAT Registration No.";
                        Rec."WHT Post Code" := Cust."Post Code";
                        Rec."WHT City" := Cust.City;
                        Rec."WHT County" := Cust.County;
                        Rec.Modify();
                    end;
                }
                field("WHT Name"; Rec."WHT Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Name field.';
                }
                field("WHT Name 2"; Rec."WHT Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Name 2 field.';
                }
                field("WHT Address"; Rec."WHT Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Address field.';
                }
                field("WHT Address 2"; Rec."WHT Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Address 2 field.';
                }
                field("WHT City"; Rec."WHT City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT City field.';
                }
                field("WHT County"; Rec."WHT County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT County field.';
                }
                field("WHT Post Code"; Rec."WHT Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Post Code field.';
                }
                field("WHT Registration No."; Rec."WHT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Registration No. field.';
                }
                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                }
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Posting Group field.';
                }
                field("WHT Base"; Rec."WHT Base")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Base field.';
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT % field.';
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }

            }
        }
    }
}