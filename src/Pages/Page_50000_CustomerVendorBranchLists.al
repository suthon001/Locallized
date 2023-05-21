page 50000 "Cust. & Vendor BranchLists"
{

    PageType = List;
    SourceTable = "Customer & Vendor Branch";
    Caption = 'Customer & Vendor Branch Lists';

    layout
    {
        area(content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    Caption = 'Source No.';
                }
                field("Title Name"; Rec."Title Name")
                {
                    ApplicationArea = All;
                    Caption = 'คำนำหน้า';
                }

                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                }
                field("Building"; Rec."Building")
                {
                    ApplicationArea = All;
                    Caption = 'ชื่ออาคาร/หมู่บ้าน';
                }
                field("House No."; Rec."House No.")
                {
                    ApplicationArea = All;
                    Caption = 'เลขที่บ้าน';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'เลขที่';
                }
                field("Floor"; Rec."Floor")
                {
                    ApplicationArea = All;
                    Caption = 'ชั้น';
                }
                field("Village No."; Rec."Village No.")
                {
                    ApplicationArea = All;
                    Caption = 'หมู่ที่';
                }
                field("Street"; Rec."Street")
                {
                    ApplicationArea = All;
                    Caption = 'ถนน';
                }
                field("Alley/Lane"; Rec."Alley/Lane")
                {
                    ApplicationArea = All;
                    Caption = 'ตรอก/ซอย';
                }
                field("Sub-district"; Rec."Sub-district")
                {
                    ApplicationArea = All;
                    Caption = 'ตำบล/แขวง';
                }
                field("District"; Rec."District")
                {
                    ApplicationArea = All;
                    Caption = 'อำเภอ/เขต';
                }

                field("Province"; Rec."Province")
                {
                    ApplicationArea = All;
                    Caption = 'จังหวัด';
                }
                field("post Code"; Rec."post Code")
                {
                    ApplicationArea = All;
                    Caption = 'รหัสไปษณีย์';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = All;
                    Caption = 'Fax No.';
                }
                field("Contact"; Rec."Contact")
                {
                    ApplicationArea = all;
                    Caption = 'Contact';
                }


                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    Caption = 'Head Office';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch Code';
                }
                field("Vat Registration No."; Rec."Vat Registration No.")
                {
                    ApplicationArea = all;
                    Caption = 'เลขประจำตัวผู้เสียภาษี';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin

    end;

}
