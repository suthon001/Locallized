/// <summary>
/// Page NCT Cust. Vendor BranchLists (ID 80000).
/// </summary>
page 80000 "NCT Cust. & Vendor BranchLists"
{

    PageType = List;
    SourceTable = "NCT Customer & Vendor Branch";
    Caption = 'Customer & Vendor Branch Lists';
    UsageCategory = Lists;
    ApplicationArea = all;

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
                    ToolTip = 'Specifies the value of the Source No. field.';
                }
                field("Title Name"; Rec."Title Name")
                {
                    ApplicationArea = All;
                    Caption = 'คำนำหน้า';
                    ToolTip = 'Specifies the value of the คำนำหน้า field.';
                }

                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Building"; Rec."Building")
                {
                    ApplicationArea = All;
                    Caption = 'ชื่ออาคาร/หมู่บ้าน';
                    ToolTip = 'Specifies the value of the ชื่ออาคาร/หมู่บ้าน field.';
                }
                field("House No."; Rec."House No.")
                {
                    ApplicationArea = All;
                    Caption = 'เลขที่บ้าน';
                    ToolTip = 'Specifies the value of the เลขที่บ้าน field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'เลขที่';
                    ToolTip = 'Specifies the value of the เลขที่ field.';
                }
                field("Floor"; Rec."Floor")
                {
                    ApplicationArea = All;
                    Caption = 'ชั้น';
                    ToolTip = 'Specifies the value of the ชั้น field.';
                }
                field("Village No."; Rec."Village No.")
                {
                    ApplicationArea = All;
                    Caption = 'หมู่ที่';
                    ToolTip = 'Specifies the value of the หมู่ที่ field.';
                }
                field("Street"; Rec."Street")
                {
                    ApplicationArea = All;
                    Caption = 'ถนน';
                    ToolTip = 'Specifies the value of the ถนน field.';
                }
                field("Alley/Lane"; Rec."Alley/Lane")
                {
                    ApplicationArea = All;
                    Caption = 'ตรอก/ซอย';
                    ToolTip = 'Specifies the value of the ตรอก/ซอย field.';
                }
                field("Sub-district"; Rec."Sub-district")
                {
                    ApplicationArea = All;
                    Caption = 'ตำบล/แขวง';
                    ToolTip = 'Specifies the value of the ตำบล/แขวง field.';
                }
                field("District"; Rec."District")
                {
                    ApplicationArea = All;
                    Caption = 'อำเภอ/เขต';
                    ToolTip = 'Specifies the value of the อำเภอ/เขต field.';
                }

                field("Province"; Rec."Province")
                {
                    ApplicationArea = All;
                    Caption = 'จังหวัด';
                    ToolTip = 'Specifies the value of the จังหวัด field.';
                }
                field("post Code"; Rec."post Code")
                {
                    ApplicationArea = All;
                    Caption = 'รหัสไปษณีย์';
                    ToolTip = 'Specifies the value of the รหัสไปษณีย์ field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = All;
                    Caption = 'Fax No.';
                    ToolTip = 'Specifies the value of the Fax No. field.';
                }
                field("Contact"; Rec."Contact")
                {
                    ApplicationArea = all;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the value of the Contact field.';
                }


                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    Caption = 'Head Office';
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch Code';
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field("Vat Registration No."; Rec."Vat Registration No.")
                {
                    ApplicationArea = all;
                    Caption = 'เลขประจำตัวผู้เสียภาษี';
                    ToolTip = 'Specifies the value of the เลขประจำตัวผู้เสียภาษี field.';
                }
            }
        }
    }

}
