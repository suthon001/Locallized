/// <summary>
/// PageExtension Role Purchase (ID 80094) extends Record Purchasing Agent Role Center.
/// </summary>
pageextension 80094 "NCT Role Purchase" extends "Purchasing Agent Role Center"
{
    actions
    {
        addfirst(sections)
        {
            group("Localized")
            {
                Caption = 'Localized';
                group("WHT Posting Group")
                {
                    Caption = 'VAT & WHT Posting Setup';
                    action("WHT Business Posting Group")
                    {
                        Caption = 'WHT Business Posting Group';
                        ApplicationArea = all;
                        RunObject = page "NCT WHT Business Posting Group";
                        ToolTip = 'Executes the WHT Business Posting Group action.';
                    }
                    action("WHT Product Posting Group")
                    {
                        Caption = 'WHT Product Posting Group';
                        ApplicationArea = all;
                        RunObject = page "NCT WHT Product Posting Group";
                        ToolTip = 'Executes the WHT Product Posting Group action.';
                    }
                    action("WHT Posting Setup")
                    {

                        Caption = 'WHT Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "NCT WHT Posting Setup";
                        ToolTip = 'Executes the WHT Posting Setup action.';
                    }
                    action("VAT Bus. Posting Group")
                    {
                        Caption = 'VAT Business Posting Group';
                        ApplicationArea = all;
                        RunObject = page "VAT Business Posting Groups";
                        ToolTip = 'Executes the VAT Business Posting Group action.';
                    }
                    action("VAT Prod. Posting Group")
                    {
                        Caption = 'VAT Product Posting Group';
                        ApplicationArea = all;
                        RunObject = page "VAT Product Posting Groups";
                        ToolTip = 'Executes the VAT Product Posting Group action.';
                    }
                    action("VAT Posting Setup")
                    {
                        Caption = 'VAT Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "VAT Posting Setup";
                        ToolTip = 'Executes the VAT Posting Setup action.';
                    }
                }
                group("Tax Report")
                {
                    Caption = 'Tax & WHT';
                    action("Sale Vat")
                    {
                        Caption = 'Sale Vat';
                        ApplicationArea = all;
                        RunObject = page "NCT Sales Vat Lists";
                        ToolTip = 'Executes the Sale Vat action.';
                    }
                    action("Purchase Vat")
                    {
                        Caption = 'Purchase Vat';
                        ApplicationArea = all;
                        RunObject = page "NCT Purchase Vat Lists";
                        ToolTip = 'Executes the Purchase Vat action.';
                    }
                    action("WHT Certificate")
                    {
                        Caption = 'WHT Certificate';
                        ApplicationArea = all;
                        RunObject = page "NCT WHT Certificate List";
                        ToolTip = 'Executes the WHT Certificate action.';
                    }
                    action("WHT03")
                    {
                        Caption = 'WHT03';
                        ApplicationArea = all;
                        RunObject = page "NCT WHT Lists";
                        ToolTip = 'Executes the WHT03 action.';
                    }
                    action("WHT53")
                    {
                        Caption = 'WHT53';
                        ApplicationArea = all;
                        RunObject = page "NCT WHT53 Lists";
                        ToolTip = 'Executes the WHT53 action.';
                    }
                }
                group("Billing&Receipt")
                {
                    Caption = 'Billing & Receipt';
                    action("Sales Billing List")
                    {
                        Caption = 'Sales Billing';
                        ApplicationArea = all;
                        RunObject = page "NCT Sales Billing List";
                        ToolTip = 'Executes the Sales Billing action.';
                    }
                    action("Sales Receipt List")
                    {
                        Caption = 'Sales Receipt';
                        ApplicationArea = all;
                        RunObject = page "NCT Sales Receipt List";
                        ToolTip = 'Executes the Sales Receipt action.';
                    }
                    action("Purchase Billing List")
                    {
                        Caption = 'Purchase Billing';
                        ApplicationArea = all;
                        RunObject = page "NCT Purchase Billing List";
                        ToolTip = 'Executes the Purchase Billing action.';
                    }
                }
                group("LCL Report")
                {
                    Caption = 'LCL Report';
                    group("LCL Stock")
                    {
                        Caption = 'Stock Report';
                        action("Stock Card Cost")
                        {
                            Caption = 'Stock Card Cost';
                            ApplicationArea = all;
                            RunObject = report "NCT Report Stock Card Cost";
                            ToolTip = 'Executes the Stock Card Cost action.';
                        }
                        action("Stock Movement")
                        {
                            Caption = 'Stock Movement';
                            ApplicationArea = all;
                            RunObject = report "NCT Stock Movement";
                            ToolTip = 'Executes the Stock Movement action.';
                        }
                        action("Stock On Hand")
                        {
                            Caption = 'Stock On Hand';
                            ApplicationArea = all;
                            RunObject = report "NCT Stock On Hand";
                            ToolTip = 'Executes the Stock On Hand action.';
                        }
                    }
                    group("LCL Fixed")
                    {
                        Caption = 'Fixed Asset Report';
                        action("Fixed Asset Write off")
                        {
                            Caption = 'รายงานการตัดจำหน่ายทรัพย์สิน (Write-Off)';
                            ApplicationArea = all;
                            RunObject = report "NCT Fixed Asset Write off";
                            ToolTip = 'Executes the รายงานการตัดจำหน่ายทรัพย์สิน (Write-Off) action.';
                        }
                        action("Fixed Asset Purchase")
                        {
                            Caption = 'รายงานซื้อทรัพย์สิน';
                            ApplicationArea = all;
                            RunObject = report "NCT Fixed Asset Purchase";
                            ToolTip = 'Executes the รายงานซื้อทรัพย์สิน action.';
                        }
                        action("Fixed Asset Sales")
                        {
                            Caption = 'รายงานการขายทรัพย์สิน';
                            ApplicationArea = all;
                            RunObject = report "NCT Fixed Asset Sales";
                            ToolTip = 'Executes the รายงานการขายทรัพย์สิน action.';
                        }
                        action("Phys. Count Fixed Asset")
                        {
                            Caption = 'รายงานตรวจนับทรัพย์สิน (ก่อนนับ)';
                            ApplicationArea = all;
                            RunObject = report "NCT Phys. Count Fixed Asset";
                            ToolTip = 'Executes the รายงานตรวจนับทรัพย์สิน (ก่อนนับ) action.';
                        }
                        action("After Phys.Count FA")
                        {
                            Caption = 'รายงานตรวจนับทรัพย์สิน (หลังนับ)';
                            ApplicationArea = all;
                            RunObject = report "NCT After Phys.Count FA";
                            ToolTip = 'Executes the รายงานตรวจนับทรัพย์สิน (หลังนับ) action.';
                        }
                        action("Compare Phys. Count FA")
                        {
                            Caption = 'รายงานเปรียบทรัพย์สินระหว่างสถานที่เก็บ';
                            ApplicationArea = all;
                            RunObject = report "NCT Compare Phys. Count FA";
                            ToolTip = 'Executes the รายงานเปรียบทรัพย์สินระหว่างสถานที่เก็บ action.';
                        }

                    }
                    action("GL Journal Report")
                    {
                        Caption = 'GL Journal Report';
                        ApplicationArea = all;
                        RunObject = report "NCT GL Journal Report";
                        ToolTip = 'Executes the GL Journal Report action.';
                    }
                    action("Bank Acc. Reconciliation")
                    {
                        Caption = 'Bank Acc. Reconciliation';
                        ApplicationArea = all;
                        RunObject = report "Bank Acc. Reconciliation";
                        ToolTip = 'Executes the Bank Acc. Reconciliation action.';
                    }

                }
            }


        }
        addafter("Purchase &Order")
        {
            action("Goods Receipt Note List")
            {
                Caption = 'Goods Receipt Note';
                ApplicationArea = all;
                RunObject = page "NCT Goods Receipt Note List";
                ToolTip = 'Executes the Goods Receipt Note action.';
            }
        }
    }
}