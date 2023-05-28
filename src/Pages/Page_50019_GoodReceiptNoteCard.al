/// <summary>
/// Page Goods Receipt Note Card (ID 50019).
/// </summary>
page 50019 "Goods Receipt Note Card"
{
    Caption = 'Goods Receipt Note Card';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = WHERE("Document Type" = FILTER(Order), Status = const(Released));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;

                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = DocNoVisible;
                    Editable = false;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor No.';

                    NotBlank = true;
                    ToolTip = 'Specifies the number of the vendor who delivers the products.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.OnAfterValidateBuyFromVendorNo(Rec, xRec);
                        CurrPage.Update();
                    end;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the vendor who delivers the products.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.OnAfterValidateBuyFromVendorNo(Rec, xRec);
                        CurrPage.Update();
                    end;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                    Visible = false;
                    Editable = false;
                }

                field("Buy-from Address"; Rec."Buy-from Address")
                {
                    ApplicationArea = Suite;

                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the vendor''s buy-from address.';
                    Editable = false;

                }
                field("Buy-from Address 2"; Rec."Buy-from Address 2")
                {
                    ApplicationArea = Suite;

                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies an additional part of the vendor''s buy-from address.';
                    Editable = false;
                }
                field("Buy-from City"; Rec."Buy-from City")
                {
                    ApplicationArea = Suite;

                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the city of the vendor on the purchase document.';
                    Editable = false;
                }

                field("Buy-from County"; Rec."Buy-from County")
                {
                    ApplicationArea = Suite;

                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the state, province or county of the address.';
                    Editable = false;
                }

                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Post Code';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the postal code.';
                    Editable = false;
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Country/Region';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the country or region of the address.';


                }
                field("Buy-from Contact No."; Rec."Buy-from Contact No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact No.';
                    Importance = Additional;
                    ToolTip = 'Specifies the number of contact person of the vendor''s buy-from.';
                    Editable = false;
                }

                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact';
                    Editable = Rec."Buy-from Vendor No." <> '';
                    ToolTip = 'Specifies the name of the person to contact about an order from this vendor.';

                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the posting date of the record.';
                    // Editable = false;

                    trigger OnValidate()
                    begin
                        SaveInvoiceDiscountAmount();
                    end;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the related purchase invoice must be paid.';
                    Editable = false;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = Suite;
                    ShowMandatory = VendorInvoiceNoMandatory;

                    ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';

                    trigger OnValidate()
                    begin
                        PurchaserCodeOnAfterValidate();
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                }
                field("Expected Receipt Date"; rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies the number of archived versions for this document.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies the date when the order was created.';
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies the quote number for the purchase order.';
                }
                field("Vendor Order No."; Rec."Vendor Order No.")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor''s order number.';
                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s shipment number.';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Alternate Vendor Address Code';
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies the order address of the related vendor.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Receiving No. Series"; Rec."Receiving No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }

            }
            part(PurchLines; "Goods Receipt Note Subform")
            {
                ApplicationArea = Suite;
                Editable = Rec."Buy-from Vendor No." <> '';
                Enabled = Rec."Buy-from Vendor No." <> '';
                SubPageLink = "Document No." = FIELD("No."), "Document Type" = field("Document Type");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Editable = false;
                    ToolTip = 'Specifies the currency of amounts on the purchase document.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if Rec."Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                        else
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate());
                        if ChangeExchangeRate.RunModal() = ACTION::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());
                            SaveInvoiceDiscountAmount();
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                    end;
                }

                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = VAT;
                    Editable = false;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid();
                    end;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = VAT;
                    Editable = false;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Editable = false;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV();
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV();
                    end;
                }

                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = SalesTax;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies if this vendor charges you sales tax for purchases.';
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = SalesTax;
                    Importance = Additional;
                    ToolTip = 'Specifies the tax area code used for this purchase to calculate and post sales tax.';

                    trigger OnValidate()
                    begin
                        CurrPage.PurchLines.PAGE.RedistributeTotalsOnAfterValidate();
                    end;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor.';
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.';
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {
                    ApplicationArea = Warehouse;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies the time it takes to make items part of available inventory, after the items have been posted as received.';
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address.';
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = OrderPromising;
                    Editable = false;
                    ToolTip = 'Specifies the date that the vendor has promised to deliver the order.';
                }
            }
            group("Shipping and Payment")
            {
                Caption = 'Shipping and Payment';
                Editable = false;
                group(Control83)
                {
                    ShowCaption = false;
                    group(Control94)
                    {
                        ShowCaption = false;
                        field(ShippingOptionWithLocation; ShipToOptions)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ship-to';
                            HideValue = NOT ShowShippingOptionsWithLocation AND (ShipToOptions = ShipToOptions::Location);
                            OptionCaption = 'Default (Company Address),Location,Customer Address,Custom Address';
                            ToolTip = 'Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company''s location addresses. Customer Address: Used in connection with drop shipment. Custom Address: Any ship-to address that you specify in the fields below.';

                            trigger OnValidate()
                            begin
                                ValidateShippingOption();
                            end;
                        }
                        group(Control99)
                        {
                            ShowCaption = false;
                            group(Control101)
                            {
                                ShowCaption = false;
                                Visible = ShipToOptions = ShipToOptions::"Customer Address";
                                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                                {
                                    ApplicationArea = Suite;
                                    Caption = 'Customer';
                                    ToolTip = 'Specifies the number of the customer that the items are shipped to directly from your vendor, as a drop shipment.';
                                }
                                field("Ship-to Code"; Rec."Ship-to Code")
                                {
                                    ApplicationArea = Suite;
                                    Editable = Rec."Sell-to Customer No." <> '';
                                    ToolTip = 'Specifies the code for another delivery address than the vendor''s own address, which is entered by default.';
                                }
                            }
                            field("Ship-to Name"; Rec."Ship-to Name")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Name';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                ToolTip = 'Specifies the name of the company at the address that you want the items on the purchase document to be shipped to.';
                            }
                            field("Ship-to Address"; Rec."Ship-to Address")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the address that you want the items on the purchase document to be shipped to.';
                            }
                            field("Ship-to Address 2"; Rec."Ship-to Address 2")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address 2';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies additional address information.';
                            }
                            field("Ship-to City"; Rec."Ship-to City")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'City';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the city of the vendor on the purchase document.';
                            }
                            group(Control124)
                            {
                                ShowCaption = false;
                                Visible = IsShipToCountyVisible;
                                field("Ship-to County"; Rec."Ship-to County")
                                {
                                    ApplicationArea = Basic, Suite;
                                    Caption = 'County';
                                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                    Importance = Additional;
                                    QuickEntry = false;
                                    ToolTip = 'Specifies the state, province or county of the address.';
                                }
                            }
                            field("Ship-to Post Code"; Rec."Ship-to Post Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Post Code';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the postal code of the address that you want the items on the purchase document to be shipped to.';
                            }
                            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Country/Region';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the country/region code of the address that you want the items on the purchase document to be shipped to.';

                                trigger OnValidate()
                                begin
                                    IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
                                end;
                            }
                            field("Ship-to Contact"; Rec."Ship-to Contact")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Contact';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                ToolTip = 'Specifies the name of a contact person for the address of the address that you want the items on the purchase document to be shipped to.';
                            }
                        }
                    }
                }
                group(Control71)
                {
                    ShowCaption = false;
                    Editable = false;
                    field(PayToOptions; PayToOptions)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pay-to';
                        OptionCaption = 'Default (Vendor),Another Vendor,Custom Address';
                        ToolTip = 'Specifies the vendor that the purchase document will be paid to. Default (Vendor): The same as the vendor on the purchase document. Another Vendor: Any vendor that you specify in the fields below.';

                        trigger OnValidate()
                        begin
                            if PayToOptions = PayToOptions::"Default (Vendor)" then
                                Rec.Validate("Pay-to Vendor No.", Rec."Buy-from Vendor No.");
                        end;
                    }
                    group(Control95)
                    {
                        ShowCaption = false;
                        Visible = NOT (PayToOptions = PayToOptions::"Default (Vendor)");
                        field("Pay-to Name"; Rec."Pay-to Name")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Name';
                            Editable = PayToOptions = PayToOptions::"Another Vendor";
                            Enabled = PayToOptions = PayToOptions::"Another Vendor";
                            Importance = Promoted;
                            ToolTip = 'Specifies the name of the vendor sending the invoice.';
                        }
                        field("Pay-to Address"; Rec."Pay-to Address")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the address of the vendor sending the invoice.';
                        }
                        field("Pay-to Address 2"; Rec."Pay-to Address 2")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address 2';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies additional address information.';
                        }
                        field("Pay-to City"; Rec."Pay-to City")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'City';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the city of the vendor on the purchase document.';
                        }
                        group(Control123)
                        {
                            ShowCaption = false;
                            Visible = IsPayToCountyVisible;
                            field("Pay-to County"; Rec."Pay-to County")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'County';
                                Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                                Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the state, province or county of the address.';
                            }
                        }
                        field("Pay-to Post Code"; Rec."Pay-to Post Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Post Code';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the postal code.';
                        }
                        field("Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Country/Region';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the country/region code of the vendor on the purchase document.';

                            trigger OnValidate()
                            begin
                                IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
                            end;
                        }
                        field("Pay-to Contact No."; Rec."Pay-to Contact No.")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Contact No.';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Importance = Additional;
                            ToolTip = 'Specifies the number of contact person of the vendor''s buy-from.';
                        }
                        field("Pay-to Contact"; Rec."Pay-to Contact")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR (Rec."Buy-from Vendor No." <> Rec."Pay-to Vendor No.");
                            ToolTip = 'Specifies the name of the person to contact about an order from this vendor.';
                        }
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                Editable = false;
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies a specification of the document''s transaction, for the purpose of reporting to INTRASTAT.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.';
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
                }
                field("Entry Point"; Rec."Entry Point")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.';
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.';
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Editable = false;
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = Prepayments;
                    Importance = Promoted;
                    ToolTip = 'Specifies the prepayment percentage to use to calculate the prepayment for sales.';

                    trigger OnValidate()
                    begin
                        Prepayment37OnAfterValidate();
                    end;
                }
                field("Compress Prepayment"; Rec."Compress Prepayment")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies that prepayments on the purchase order are combined if they have the same general ledger account for prepayments or the same dimensions.';
                }
                field("Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the code that represents the payment terms for prepayment invoices related to the purchase document.';
                }
                field("Prepayment Due Date"; Rec."Prepayment Due Date")
                {
                    ApplicationArea = Prepayments;
                    Importance = Promoted;
                    ToolTip = 'Specifies when the prepayment invoice for this purchase order is due.';
                }
                field("Prepmt. Payment Discount %"; Rec."Prepmt. Payment Discount %")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the payment discount percent granted on the prepayment if the vendor pays on or before the date entered in the Prepmt. Pmt. Discount Date field.';
                }
                field("Prepmt. Pmt. Discount Date"; Rec."Prepmt. Pmt. Discount Date")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the last date the vendor can pay the prepayment invoice and still receive a payment discount on the prepayment amount.';
                }
                field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number that the vendor uses for the purchase order.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(38),
                              "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
            }
            part(Control23; "Pending Approval FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Table ID" = CONST(38),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1903326807; "Item Replenishment FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = Suite;
                Visible = false;
            }
            part(Control1901138007; "Vendor Details FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
                Visible = false;
            }
            part(Control1904651607; "Vendor Statistics FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Suite;
                ShowFilter = false;
                Visible = false;
            }
            part(Control1903435607; "Vendor Hist. Buy-from FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
            }
            part(Control1906949207; "Vendor Hist. Pay-to FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
                Visible = false;
            }
            part(Control3; "Purchase Line FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                    trigger OnAction()
                    begin
                        Rec.OpenPurchaseOrderStatistics();
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(Vendor)
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor';
                    Enabled = rec."Buy-from Vendor No." <> '';
                    Image = Vendor;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Buy-from Vendor No."),
                                  "Date Filter" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the vendor on the purchase document.';
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalsPurchase(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add comments for the record.';
                }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Receipts)
                {
                    ApplicationArea = Suite;
                    Caption = 'Receipts';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Category11;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                    ToolTip = 'View a list of posted purchase receipts for the order.';
                }
                action(Invoices)
                {
                    ApplicationArea = Suite;
                    Caption = 'Invoices';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Category11;
                    PromotedIsBig = false;
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                    ToolTip = 'View a list of ongoing purchase invoices for the order.';
                }
                action(PostedPrepaymentInvoices)
                {
                    ApplicationArea = Prepayments;
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                    ToolTip = 'View related posted sales invoices that involve a prepayment. ';
                }
                action(PostedPrepaymentCrMemos)
                {
                    ApplicationArea = Prepayments;
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Purchase Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                    ToolTip = 'View related posted sales credit memos that involve a prepayment. ';
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("In&vt. Put-away/Pick Lines")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = CONST("Purchase Order"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                    ToolTip = 'View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.';
                }
                action("Whse. Receipt Lines")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Whse. Receipt Lines';
                    Image = ReceiptLines;
                    RunObject = Page "Whse. Receipt Lines";
                    RunPageLink = "Source Type" = CONST(39),
                                  "Source Subtype" = CONST(1),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                    ToolTip = 'View ongoing warehouse receipts for the document, in advanced warehouse configurations.';
                }
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment';
                    Image = Delivery;
                    action(Warehouse_GetSalesOrder)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Get &Sales Order';
                        Image = "Order";
                        RunObject = Codeunit "Purch.-Get Drop Shpt.";
                        ToolTip = 'Select the sales order that must be linked to the purchase order, for drop shipment or special order. ';
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action("Get &Sales Order")
                    {
                        AccessByPermission = TableData "Sales Shipment Header" = R;
                        ApplicationArea = Suite;
                        Caption = 'Get &Sales Order';
                        Image = "Order";
                        ToolTip = 'Select the sales order that must be linked to the purchase order, for drop shipment or special order. ';

                        trigger OnAction()
                        var
                            PurchHeader: Record "Purchase Header";
                            DistIntegration: Codeunit "Dist. Integration";
                        begin
                            PurchHeader.Copy(Rec);
                            DistIntegration.GetSpecialOrders(PurchHeader);
                            Rec := PurchHeader;
                        end;
                    }
                }
            }
        }
        area(processing)
        {



            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData "Vendor Invoice Disc." = R;
                    ApplicationArea = Suite;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    ToolTip = 'Calculate the discount that can be granted based on all lines in the purchase document.';

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc();
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(GetRecurringPurchaseLines)
                {
                    ApplicationArea = Suite;
                    Caption = 'Get Recurring Purchase Lines';
                    Ellipsis = true;
                    Image = VendorCode;
                    ToolTip = 'Insert purchase document lines that you have set up for the vendor as recurring. Recurring purchase lines could be for a monthly replenishment order or a fixed freight expense.';

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }


                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Suite;
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document" = R;
                        ApplicationArea = Suite;
                        Caption = 'Select Incoming Document';
                        Image = SelectLineToApply;
                        ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            Rec.Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = (Rec."Incoming Document Entry No." = 0) AND (Rec."No." <> '');
                        Image = Attach;
                        ToolTip = 'Create an incoming document from a file that you select from the disk. The file will be attached to the incoming document record.';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        ToolTip = 'Remove any incoming document records and file attachments.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            if IncomingDocument.Get(Rec."Incoming Document Entry No.") then
                                IncomingDocument.RemoveLinkToRelatedRecord();
                            Rec."Incoming Document Entry No." := 0;
                            Rec.Modify(true);
                        end;
                    }
                }
            }

            group(Action17)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Create &Whse. Receipt")
                {
                    AccessByPermission = TableData "Warehouse Receipt Header" = R;
                    ApplicationArea = Warehouse;
                    Caption = 'Create &Whse. Receipt';
                    Image = NewReceipt;
                    ToolTip = 'Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.';

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.CreateFromPurchOrder(Rec);

                        if not Rec.Find('=><') then
                            Rec.Init();
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    AccessByPermission = TableData "Posted Invt. Put-away Header" = R;
                    ApplicationArea = Warehouse;
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.';

                    trigger OnAction()
                    begin
                        Rec.CreateInvtPutAwayPick();

                        if not Rec.Find('=><') then
                            Rec.Init();
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Suite;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        PostDocument(CODEUNIT::"Purch.-Post (Yes/No)");
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    begin
                        ShowPreview();
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintPurchHeader(Rec);
                    end;
                }


                group("Prepa&yment")
                {
                    Caption = 'Prepa&yment';
                    Image = Prepayment;
                    action("Prepayment Test &Report")
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Prepayment Test &Report';
                        Ellipsis = true;
                        Image = PrepaymentSimulation;
                        ToolTip = 'Preview the prepayment transactions that will results from posting the sales document as invoiced. ';

                        trigger OnAction()
                        begin
                            ReportPrint.PrintPurchHeaderPrepmt(Rec);
                        end;
                    }
                    action(PostPrepaymentInvoice)
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        ToolTip = 'Post the specified prepayment information. ';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                                PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec, false);
                        end;
                    }
                    action("Post and Print Prepmt. Invoic&e")
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        ToolTip = 'Post the specified prepayment information and print the related report. ';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                                PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec, true);
                        end;
                    }
                    action(PreviewPrepmtInvoicePosting)
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Preview Prepmt. Invoice Posting';
                        Image = ViewPostedOrder;
                        ToolTip = 'Review the different types of entries that will be created when you post the prepayment invoice.';

                        trigger OnAction()
                        begin
                            ShowPrepmtInvoicePreview();
                        end;
                    }
                    action(PostPrepaymentCreditMemo)
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        ToolTip = 'Create and post a credit memo for the specified prepayment information.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                                PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec, false);
                        end;
                    }
                    action("Post and Print Prepmt. Cr. Mem&o")
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        ToolTip = 'Create and post a credit memo for the specified prepayment information and print the related report.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                                PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec, true);
                        end;
                    }
                    action(PreviewPrepmtCrMemoPosting)
                    {
                        ApplicationArea = Prepayments;
                        Caption = 'Preview Prepmt. Cr. Memo Posting';
                        Image = ViewPostedOrder;
                        ToolTip = 'Review the different types of entries that will be created when you post the prepayment credit memo.';

                        trigger OnAction()
                        begin
                            ShowPrepmtCrMemoPreview();
                        end;
                    }
                }
            }
            group(Print)
            {
                Caption = 'Print';
                Image = Print;
                action("Purchase Order")
                {
                    Caption = 'Purchase Order';
                    Image = PrintReport;
                    ApplicationArea = all;
                    PromotedCategory = Category10;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Show Report';
                    trigger OnAction()
                    var

                        PurchaseHeader: Record "Purchase Header";
                    begin
                        PurchaseHeader.reset();
                        PurchaseHeader.SetRange("Document Type", rec."Document Type");
                        PurchaseHeader.SetRange("No.", rec."No.");
                        REPORT.RunModal(REPORT::"PurchaseOrder", true, true, PurchaseHeader);
                    end;
                }
                action("Purchase Receipt")
                {
                    Caption = 'Purchase Receipt';
                    Image = PrintReport;
                    ApplicationArea = all;
                    PromotedCategory = Category10;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Show Report';
                    trigger OnAction()
                    var
                        PurchaseRecripet: Record "Purch. Rcpt. Header";
                    begin

                        PurchaseRecripet.reset();
                        PurchaseRecripet.SetRange("Order No.", rec."No.");
                        if PurchaseRecripet.FindLast() then
                            REPORT.RunModal(REPORT::"Good Receipt Note", true, true, PurchaseRecripet);
                    end;
                }
                action(SendCustom)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send';
                    Ellipsis = true;
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to send the document according to the vendor''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        PurchaseHeader := Rec;
                        CurrPage.SetSelectionFilter(PurchaseHeader);
                        PurchaseHeader.SendRecords();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCurrentShippingAndPayToOption();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord();
        exit(Rec.ConfirmDeletion());
    end;

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin

        SetExtDocNoMandatoryCondition();
        ShowShippingOptionsWithLocation := ApplicationAreaMgmtFacade.IsLocationEnabled() or ApplicationAreaMgmtFacade.IsAllDisabled();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();

        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetBuyFromVendorFromFilter();

        CalculateCurrentShippingAndPayToOption();
    end;

    trigger OnOpenPage()
    begin
        SetDocNoVisible();


        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
        if (Rec."No." <> '') and (Rec."Buy-from Vendor No." = '') then
            DocumentIsPosted := (not Rec.Get(Rec."Document Type", Rec."No."));

        ActivateFields();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if ShowReleaseNotification() then
            if not InstructionMgt.ShowConfirmUnreleased() then
                exit(false);
        if not DocumentIsPosted then
            exit(Rec.ConfirmCloseUnposted());
    end;

    var

        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";

        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        FormatAddress: Codeunit "Format Address";
        ChangeExchangeRate: Page "Change Exchange Rate";
        ShipToOptions: Option "Default (Company Address)",Location,"Customer Address","Custom Address";
        PayToOptions: Option "Default (Vendor)","Another Vendor","Custom Address";

        [InDataSet]
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        VendorInvoiceNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;

        ShowWorkflowStatus: Boolean;

        DocumentIsPosted: Boolean;
        OpenPostedPurchaseOrderQst: Label 'The order is posted as number %1 and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ShowShippingOptionsWithLocation: Boolean;


        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;

    local procedure ActivateFields()
    begin

        IsPayToCountyVisible := FormatAddress.UseCounty(Rec."Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    local procedure PostDocument(PostingCodeunitID: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        IsScheduledPosting: Boolean;
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled() then
            LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

        Rec.SendToPosting(PostingCodeunitID);

        IsScheduledPosting := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (not PurchaseHeader.Get(Rec."Document Type", Rec."No.")) or IsScheduledPosting;

        if IsScheduledPosting then
            CurrPage.Close();
        CurrPage.Update(false);

        if PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" then
            exit;

        if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode()) then
            ShowPostedConfirmationMessage();
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.PurchLines.PAGE.ApproveCalcInvDisc();
    end;

    local procedure SaveInvoiceDiscountAmount()
    var
        DocumentTotals: Codeunit "Document Totals";
    begin
        CurrPage.SaveRecord();
        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmountsOnDocument(Rec);
        CurrPage.Update(false);
    end;

    local procedure PurchaserCodeOnAfterValidate()
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(true);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update();
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update();
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update();
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update();
    end;

    local procedure ShowPreview()
    var
        PurchPostYesNo: Codeunit "Purch.-Post (Yes/No)";
    begin
        PurchPostYesNo.Preview(Rec);
    end;

    local procedure ShowPrepmtInvoicePreview()
    var
        PurchPostPrepmtYesNo: Codeunit "Purch.-Post Prepmt. (Yes/No)";
    begin
        PurchPostPrepmtYesNo.Preview(Rec, 2);
    end;

    local procedure ShowPrepmtCrMemoPreview()
    var
        PurchPostPrepmtYesNo: Codeunit "Purch.-Post Prepmt. (Yes/No)";
    begin
        PurchPostPrepmtYesNo.Preview(Rec, 3);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Order, Rec."No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();
        VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin

        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition();

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        OrderPurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if not OrderPurchaseHeader.Get(Rec."Document Type", Rec."No.") then begin
            PurchInvHeader.SetRange("No.", Rec."Last Posting No.");
            if PurchInvHeader.FindFirst() then
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedPurchaseOrderQst, PurchInvHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode())
                then
                    PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader);
        end;
    end;

    local procedure ValidateShippingOption()
    begin
        case ShipToOptions of
            ShipToOptions::"Default (Company Address)",
            ShipToOptions::"Custom Address":
                begin
                    Rec.Validate("Location Code", '');
                    Rec.Validate("Sell-to Customer No.", '');
                end;
            ShipToOptions::Location:
                begin
                    Rec.Validate("Location Code");
                    Rec.Validate("Sell-to Customer No.", '');
                end;
            ShipToOptions::"Customer Address":
                begin
                    Rec.Validate("Sell-to Customer No.");
                    Rec.Validate("Location Code", '');
                end;
        end;
    end;

    local procedure ShowReleaseNotification(): Boolean
    var
        LocationsQuery: Query "Locations from items Purch";
    begin
        if Rec.Status <> Rec.Status::Released then begin
            LocationsQuery.SetRange(Document_No, Rec."No.");
            LocationsQuery.SetRange(Require_Receive, true);
            LocationsQuery.Open();
            if LocationsQuery.Read() then
                exit(true);
            LocationsQuery.SetRange(Document_No, Rec."No.");
            LocationsQuery.SetRange(Require_Receive);
            LocationsQuery.SetRange(Require_Put_away, true);
            LocationsQuery.Open();
            exit(LocationsQuery.Read());
        end;
        exit(false);
    end;

    local procedure CalculateCurrentShippingAndPayToOption()
    begin
        case true of
            Rec."Sell-to Customer No." <> '':
                ShipToOptions := ShipToOptions::"Customer Address";
            Rec."Location Code" <> '':
                ShipToOptions := ShipToOptions::Location;
            else
                if Rec.ShipToAddressEqualsCompanyShipToAddress() then
                    ShipToOptions := ShipToOptions::"Default (Company Address)"
                else
                    ShipToOptions := ShipToOptions::"Custom Address";
        end;

        case true of
            (Rec."Pay-to Vendor No." = Rec."Buy-from Vendor No.") and Rec.BuyFromAddressEqualsPayToAddress():
                PayToOptions := PayToOptions::"Default (Vendor)";
            (Rec."Pay-to Vendor No." = Rec."Buy-from Vendor No.") and (not Rec.BuyFromAddressEqualsPayToAddress()):
                PayToOptions := PayToOptions::"Custom Address";
            Rec."Pay-to Vendor No." <> Rec."Buy-from Vendor No.":
                PayToOptions := PayToOptions::"Another Vendor";
        end;

        OnAfterCalculateCurrentShippingAndPayToOption(ShipToOptions, PayToOptions, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateCurrentShippingAndPayToOption(var ShipToOptions: Option "Default (Company Address)",Location,"Customer Address","Custom Address"; var PayToOptions: Option "Default (Vendor)","Another Vendor","Custom Address"; PurchaseHeader: Record "Purchase Header")
    begin
    end;
}
