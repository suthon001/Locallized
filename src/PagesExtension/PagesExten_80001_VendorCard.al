/// <summary>
/// PageExtension ExtenVendor Card (ID 80001) extends Record Vendor Card.
/// </summary>
pageextension 80001 "NCT ExtenVendor Card" extends "Vendor Card"
{

    layout
    {
        addlast(General)
        {

            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
            field("WHT Business Posting Group"; rec."NCT WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                ShowMandatory = true;
            }
            field("Head Office"; rec."NCT Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; rec."NCT VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        addafter(General)
        {
            group(WHTInfor)
            {
                Caption = 'WHT Information';
                field("NCT WHT Title Name"; rec."NCT WHT Title Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the คำนำหน้า field.';
                }
                field("NCT WHT Name"; rec."NCT WHT Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชื่อ field.';
                }
                field("NCT WHT Building"; rec."NCT WHT Building")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชื่ออาคาร/หมู่บ้าน field.';
                }
                field("NCT WHT House No."; rec."NCT WHT House No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the เลขที่ห้อง field.';
                }
                field("NCT WHT Village No."; rec."NCT WHT Village No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the หมู่ที่ field.';
                }
                field("NCT WHT Floor"; rec."NCT WHT Floor")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชั้น field.';
                }
                field("NCT WHT No."; rec."NCT WHT No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the เลขที่ field.';
                }
                field("NCT WHT Street"; rec."NCT WHT Street")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ถนน field.';
                }
                field("NCT WHT Alley/Lane"; rec."NCT WHT Alley/Lane")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ตรอก/ซอย field.';
                }
                field("NCT WHT Sub-district"; rec."NCT WHT Sub-district")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ตำบล/แขวง field.';
                }
                field("NCT WHT District"; rec."NCT WHT District")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the อำเภอ/เขต field.';
                }
                field("NCT WHT Province"; rec."NCT WHT Province")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the จังหวัด field.';
                }
                field("NCT WHT Post Code"; rec."NCT WHT Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the รหัสไปรษณีย์ field.';
                }

            }
        }
    }

}