page 50006 "ShowDetailWHT"
{
    Caption = 'Show Detail WHT';
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
                field("WHT Document No."; Rec."WHT Document No.")
                {
                    ApplicationArea = All;
                }
                field("WHT Date"; Rec."WHT Date")
                {
                    ApplicationArea = All;
                }
                field("Customer/Vendor"; Rec."WHT Cust/Vend No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    TableRelation = Customer."No.";
                    trigger OnValidate()
                    var
                        Cust: Record Customer;
                    begin
                        if not Cust.get(Rec."WHT Cust/Vend No.") then
                            Cust.init;
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
                }
                field("WHT Name 2"; Rec."WHT Name 2")
                {
                    ApplicationArea = All;
                }
                field("WHT Address"; Rec."WHT Address")
                {
                    ApplicationArea = All;
                }
                field("WHT Address 2"; Rec."WHT Address 2")
                {
                    ApplicationArea = All;
                }
                field("WHT City"; Rec."WHT City")
                {
                    ApplicationArea = All;
                }
                field("WHT County"; Rec."WHT County")
                {
                    ApplicationArea = All;
                }
                field("WHT Post Code"; Rec."WHT Post Code")
                {
                    ApplicationArea = All;
                }
                field("WHT Registration No."; Rec."WHT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = All;
                }
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = All;
                }
                field("WHT Base"; Rec."WHT Base")
                {
                    ApplicationArea = All;
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = All;
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}