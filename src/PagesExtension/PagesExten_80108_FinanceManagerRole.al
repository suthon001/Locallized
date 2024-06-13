/// <summary>
/// PageExtension NCT Finance Manager Role (ID 80108) extends Record Finance Manager Role Center.
/// </summary>
pageextension 80108 "NCT Finance Manager Role" extends "Finance Manager Role Center"
{
    actions
    {
        addlast(Group38)
        {

            action("Requisition Line Posted")
            {
                Caption = 'Posted Requisition Line';
                ApplicationArea = all;
                RunObject = page "NCT Posted Requisition Line";
                ToolTip = 'Executes the Posted Requisition Line action.';
            }
        }
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
                    action(WHTTransaction)
                    {
                        Caption = 'WHT Transaction';
                        ApplicationArea = all;
                        RunObject = page "NCT WHT Transaction Entries";
                        ToolTip = 'Executes the WHT Transaction Entries action.';
                    }
                    action(VatTransaction)
                    {
                        Caption = 'VAT Transaction';
                        ApplicationArea = all;
                        RunObject = page "NCT Vat Transaction Entries";
                        ToolTip = 'Executes the VAT Transaction Entries action.';
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
                            Caption = 'Fixed Asset - Write-Off';
                            ApplicationArea = all;
                            RunObject = report "NCT Fixed Asset Write off";
                            ToolTip = 'Executes the Fixed Asset - Write-Off action.';
                        }
                        action("Fixed Asset Purchase")
                        {
                            Caption = 'Fixed Asset - Purchase';
                            ApplicationArea = all;
                            RunObject = report "NCT Fixed Asset Purchase";
                            ToolTip = 'Executes the Fixed Asset - Purchase action.';
                        }
                        action("Fixed Asset Sales")
                        {
                            Caption = 'Fixed Asset - Sale';
                            ApplicationArea = all;
                            RunObject = report "NCT Fixed Asset Sales";
                            ToolTip = 'Executes the Fixed Asset - Sale action.';
                        }
                        action("Phys. Count Fixed Asset")
                        {
                            Caption = 'Fixed Asset - Count (Before)';
                            ApplicationArea = all;
                            RunObject = report "NCT Phys. Count Fixed Asset";
                            ToolTip = 'Executes the Fixed Asset - Count (Before) action.';
                            Visible = false;
                        }
                        action("After Phys.Count FA")
                        {
                            Caption = 'Fixed Asset - Count (After)';
                            ApplicationArea = all;
                            RunObject = report "NCT After Phys.Count FA";
                            ToolTip = 'Executes the Fixed Asset - Count (After) action.';
                            Visible = false;
                        }
                        action("Compare Phys. Count FA")
                        {
                            Caption = 'Fixed Asset - Property Comparison';
                            ApplicationArea = all;
                            RunObject = report "NCT Compare Phys. Count FA";
                            ToolTip = 'Executes the Fixed Asset - Property Comparison action.';
                            Visible = false;
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
    }
}
