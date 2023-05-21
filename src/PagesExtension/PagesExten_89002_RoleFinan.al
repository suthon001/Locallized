pageextension 89002 "Role Finan" extends "Accountant Role Center"
{
    actions
    {
        addfirst(sections)
        {
            group("Locallized")
            {
                Caption = 'Locallized';
                group("WHT Posting Group")
                {
                    Caption = 'VAT & WHT Posting Setup';
                    action("WHT Business Posting Group")
                    {
                        Caption = 'WHT Business Posting Group';
                        ApplicationArea = all;
                        RunObject = page "WHT Business Posting Group";
                    }
                    action("WHT Product Posting Group")
                    {
                        Caption = 'WHT Product Posting Group';
                        ApplicationArea = all;
                        RunObject = page "WHT Product Posting Group";
                    }
                    action("WHT Posting Setup")
                    {

                        Caption = 'WHT Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "WHT Posting Setup";
                    }
                    action("VAT Bus. Posting Group")
                    {
                        Caption = 'VAT Business Posting Group';
                        ApplicationArea = all;
                        RunObject = page "VAT Business Posting Groups";
                    }
                    action("VAT Prod. Posting Group")
                    {
                        Caption = 'VAT Product Posting Group';
                        ApplicationArea = all;
                        RunObject = page "VAT Product Posting Groups";
                    }
                    action("VAT Posting Setup")
                    {
                        Caption = 'VAT Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "VAT Posting Setup";
                    }
                }
                group("Tax Report")
                {
                    Caption = 'Tax & WHT';
                    action("Sale Vat")
                    {
                        Caption = 'Sale Vat';
                        ApplicationArea = all;
                        RunObject = page "Sales Vat Lists";
                    }
                    action("Purchase Vat")
                    {
                        Caption = 'Purchase Vat';
                        ApplicationArea = all;
                        RunObject = page "Purchase Vat Lists";
                    }
                    action("WHT Certificate")
                    {
                        Caption = 'WHT Certificate';
                        ApplicationArea = all;
                        RunObject = page "WHT Certificate List";
                    }
                    action("WHT03")
                    {
                        Caption = 'WHT03';
                        ApplicationArea = all;
                        RunObject = page "WHT Lists";
                    }
                    action("WHT53")
                    {
                        Caption = 'WHT53';
                        ApplicationArea = all;
                        RunObject = page "WHT53 Lists";
                    }
                }
                group("Billing&Receipt")
                {
                    Caption = 'Billing & Receipt';
                    action("Sales Billing List")
                    {
                        Caption = 'Sales Billing';
                        ApplicationArea = all;
                        RunObject = page "Sales Billing List";
                    }
                    action("Sales Receipt List")
                    {
                        Caption = 'Sales Receipt';
                        ApplicationArea = all;
                        RunObject = page "Sales Receipt List";
                    }
                    action("Purchase Billing List")
                    {
                        Caption = 'Purchase Billing';
                        ApplicationArea = all;
                        RunObject = page "Purchase Billing List";
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
                            RunObject = report "Report Stock Card Cost";
                        }
                        action("Stock Movement")
                        {
                            Caption = 'Stock Movement';
                            ApplicationArea = all;
                            RunObject = report "Stock Movement";
                        }
                        action("Stock On Hand")
                        {
                            Caption = 'Stock On Hand';
                            ApplicationArea = all;
                            RunObject = report "Stock On Hand";
                        }
                    }
                    group("LCL Fixed")
                    {
                        Caption = 'Fixed Asset Report';
                        action("Fixed Asset Write off")
                        {
                            Caption = 'รายงานการตัดจำหน่ายทรัพย์สิน (Write-Off)';
                            ApplicationArea = all;
                            RunObject = report "Fixed Asset Write off";
                        }
                        action("Fixed Asset Purchase")
                        {
                            Caption = 'รายงานซื้อทรัพย์สิน';
                            ApplicationArea = all;
                            RunObject = report "Fixed Asset Purchase";
                        }
                        action("Fixed Asset Sales")
                        {
                            Caption = 'รายงานการขายทรัพย์สิน';
                            ApplicationArea = all;
                            RunObject = report "Fixed Asset Sales";
                        }
                        action("Phys. Count Fixed Asset")
                        {
                            Caption = 'รายงานตรวจนับทรัพย์สิน (ก่อนนับ)';
                            ApplicationArea = all;
                            RunObject = report "Phys. Count Fixed Asset";
                        }
                        action("After Phys.Count FA")
                        {
                            Caption = 'รายงานตรวจนับทรัพย์สิน (หลังนับ)';
                            ApplicationArea = all;
                            RunObject = report "After Phys.Count FA";
                        }
                        action("Compare Phys. Count FA")
                        {
                            Caption = 'รายงานเปรียบทรัพย์สินระหว่างสถานที่เก็บ';
                            ApplicationArea = all;
                            RunObject = report "Compare Phys. Count FA";
                        }

                    }
                    action("GL Journal Report")
                    {
                        Caption = 'GL Journal Report';
                        ApplicationArea = all;
                        RunObject = report "GL Journal Report";
                    }
                    action("Bank Acc. Reconciliation")
                    {
                        Caption = 'Bank Acc. Reconciliation';
                        ApplicationArea = all;
                        RunObject = report "Bank Acc. Reconciliation";
                    }

                }
            }

        }
        addafter("Purchase Orders")
        {
            action("BWK Goods Receipt Note List")
            {
                Caption = 'Goods Receipt Note';
                ApplicationArea = all;
                RunObject = page "Goods Receipt Note List";
            }
        }
    }
}