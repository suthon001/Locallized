/// <summary>
/// Codeunit NCT Clear Transactions (ID 80013).
/// </summary>
codeunit 80013 "NCT Clean Transactions"
{

    //Std. Table
    Permissions = TableData "Item Ledger Entry" = rimd, TableData "Value Entry" = rimd,
    TableData "G/L Entry" = rimd, TableData "Cust. Ledger Entry" = rimd,
    TableData "Vendor Ledger Entry" = rimd, TableData "Item Vendor" = rimd,
    TableData "G/L Register" = rimd, TableData "Item Register" = rimd,
    TableData "Sales Shipment Header" = rimd, TableData "Sales Shipment Line" = rimd,
    TableData "Sales Invoice Header" = rimd, TableData "Sales Invoice Line" = rimd,
    TableData "Sales Cr.Memo Header" = rimd, TableData "Sales Cr.Memo Line" = rimd,
    TableData "Purch. Rcpt. Header" = rimd, TableData "Purch. Rcpt. Line" = rimd,
    TableData "Purch. Inv. Header" = rimd, TableData "Purch. Inv. Line" = rimd,
    TableData "Purch. Cr. Memo Hdr." = rimd, TableData "Purch. Cr. Memo Line" = rimd,
    TableData "Reservation Entry" = rimd, TableData "Entry Summary" = rimd,
    TableData "Detailed Cust. Ledg. Entry" = rimd, TableData "Detailed Vendor Ledg. Entry" = rimd,
    TableData "Deferral Header" = rimd, TableData "Deferral Line" = rimd,
    TableData "Item Application Entry" = rimd,
    TableData "Production Order" = rimd, TableData "Prod. Order Line" = rimd,
    TableData "Prod. Order Component" = rimd, TableData "Prod. Order Routing Line" = rimd,
    TableData "Posted Deferral Header" = rimd, TableData "Posted Deferral Line" = rimd,
    TableData "Item Variant" = rimd, TableData "Unit of Measure Translation" = rimd,
    TableData "Item Unit of Measure" = rimd,
    TableData "Transfer Header" = rimd, TableData "Transfer Line" = rimd,
    TableData "Transfer Route" = rimd, TableData "Transfer Shipment Header" = rimd,
    TableData "Transfer Shipment Line" = rimd, TableData "Transfer Receipt Header" = rimd,
    TableData "Transfer Receipt Line" = rimd,
    TableData "Capacity Ledger Entry" = rimd, TableData "Lot No. Information" = rimd,
    TableData "Serial No. Information" = rimd, TableData "Item Entry Relation" = rimd,
    TableData "Return Shipment Header" = rimd, TableData "Return Shipment Line" = rimd,
    TableData "Return Receipt Header" = rimd, TableData "Return Receipt Line" = rimd,
    TableData "G/L Budget Entry" = rimd, TableData "Res. Capacity Entry" = rimd,
    TableData "Job Ledger Entry" = rimd, TableData "Res. Ledger Entry" = rimd,
    TableData "VAT Entry" = rimd, TableData "Document Entry" = rimd,
    TableData "Bank Account Ledger Entry" = rimd, TableData "Phys. Inventory Ledger Entry" = rimd,
    TableData "Approval Entry" = rimd, TableData "Posted Approval Entry" = rimd,
    TableData "Cost Entry" = rimd, TableData "Employee Ledger Entry" = rimd,
    TableData "Detailed Employee Ledger Entry" = rimd, TableData "FA Ledger Entry" = rimd,
    TableData "Maintenance Ledger Entry" = rimd, TableData "Service Ledger Entry" = rimd,
    TableData "Warranty Ledger Entry" = rimd, TableData "Item Budget Entry" = rimd,
    TableData "Production Forecast Entry" = rimd, TableData "Location" = rimd, TableData "Bin" = rimd,
    TableData "Customer" = rimd, TableData "Vendor" = rimd, TableData "Item" = rimd,
    TableData "Warehouse Entry" = rimd, tabledata "Post Value Entry to G/L" = rimd,
    TableData "NCT VAT Transections" = rimd, TableData "Posted Gen. Journal Line" = rimd, tableData "Posted Gen. Journal Batch" = rimd,
    TableData "NCT Tax & WHT Header" = rimd, TableData "NCT Tax & WHT Line" = rimd, TableData "NCT WHT Header" = rimd,
    TableData "NCT WHT Line" = rimd,
    tabledata "NCT Record Deletion Table" = rimd,
    tabledata "g/l entry - vat Entry link" = rimd,
    tabledata "Change Log Entry" = ridm,
    tabledata "Fa Register" = ridm,
    tabledata "NCT WHT Applied Entry" = ridm,
    tabledata "G/L - Item Ledger Relation" = ridm,
    tabledata "Bank Acc. Reconciliation Line" = rimd,
    tabledata "NCT Billing Receipt Header" = rimd,
    tabledata "NCT Billing Receipt Line" = rimd,
    tabledata "Workflow Step Instance" = rimd,
    tabledata "Workflow Step Instance Archive" = rimd,
    tabledata "Workflow Step Argument Archive" = rimd;
    trigger OnRun()
    begin
    end;

    var
        Text0002: Label 'Deleting Records!\Table: #1#######';
    /// <summary>
    /// DeleteRecords.
    /// </summary>
    /// <param name="pCompanyName">Text.</param>
    /// <param name="setdefultnoseries">Boolean.</param>
    /// <param name="UseTransaction">Boolean.</param>
    /// <param name="UseMaster">Boolean.</param>
    procedure DeleteRecords(pCompanyName: Text; setdefultnoseries: Boolean; UseTransaction: Boolean; UseMaster: Boolean)
    var
        Window: Dialog;
        RecRef: RecordRef;
        RecordDeletionTable: Record "NCT Record Deletion Table";
        NoseriesLine: Record "No. Series Line";
    begin
        if (NOT UseTransaction) and (NOT UseMaster) then
            error('Suggest Transaction Or Suggest Master must be select');
        Window.Open(Text0002);
        RecordDeletionTable.reset();
        if (UseTransaction) and (UseMaster) then
            RecordDeletionTable.SetFilter("Transaction Type", '%1|%2', RecordDeletionTable."Transaction Type"::Transaction, RecordDeletionTable."Transaction Type"::Master)
        else begin
            if UseTransaction then
                RecordDeletionTable.SetRange("Transaction Type", RecordDeletionTable."Transaction Type"::Transaction);
            if UseMaster then
                RecordDeletionTable.SetRange("Transaction Type", RecordDeletionTable."Transaction Type"::Master);
        end;
        RecordDeletionTable.SetRange("Delete Records", true);
        if RecordDeletionTable.FindSet() then begin
            repeat
                Window.Update(1, Format(RecordDeletionTable."Table ID"));
                RecRef.Open(RecordDeletionTable."Table ID", false, pCompanyName);
                if RecRef.FindSet() then
                    RecRef.DeleteAll();
                RecRef.Close();

                RecordDeletionTable."LastTime Clean Transection" := CurrentDateTime;
                RecordDeletionTable."LastTime Clean By" := COPYSTR(UserId(), 1, 50);
                RecordDeletionTable.Modify();

            until RecordDeletionTable.Next() = 0;
            if setdefultnoseries then begin
                NoseriesLine.reset();
                if NoseriesLine.FindSet() then
                    repeat
                        NoseriesLine."Last Date Used" := 0D;
                        NoseriesLine."Last No. Used" := '';
                        NoseriesLine.Modify();
                    until NoseriesLine.Next() = 0;
            end;
        end else
            Message('Nothing to Clean');
        Window.Close();
    end;
    /// <summary>
    /// Generate Table.
    /// </summary>
    procedure "Generate TableTansaction"()
    var
        MyTable: list of [text];
        RecordDeltetionEntry: Record "NCT Record Deletion Table";
        ObjectAll: Record AllObj;
        NyTableName: Text[250];
    begin
        CLEAR(NyTableName);
        CLEAR(MyTable);
        MyTable.add('Cust. Ledger Entry');
        MyTable.add('Vendor Ledger Entry');
        MyTable.add('Item Ledger Entry');
        MyTable.add('Sales Header');
        MyTable.add('Sales Line');
        MyTable.add('Purchase Header');
        MyTable.add('Purchase Line');
        MyTable.add('Purch. Comment Line');
        MyTable.add('Sales Comment Line');
        MyTable.add('G/L Register');
        MyTable.add('Item Register');
        MyTable.add('User Time Register');
        MyTable.add('Gen. Journal Line');
        MyTable.add('Item Journal Line');
        MyTable.add('Date Compr. Register');
        MyTable.add('G/L Budget Entry');
        MyTable.add('Sales Shipment Header');
        MyTable.add('Sales Shipment Line');
        MyTable.add('Sales Invoice Header');
        MyTable.add('Sales Invoice Line');
        MyTable.add('Sales Cr.Memo Header');
        MyTable.add('Sales Cr.Memo Line');
        MyTable.add('Purch. Rcpt. Header');
        MyTable.add('Purch. Rcpt. Line');
        MyTable.add('Purch. Inv. Header');
        MyTable.add('Purch. Inv. Line');
        MyTable.add('Purch. Cr. Memo Hdr.');
        MyTable.add('Purch. Cr. Memo Line');
        MyTable.add('Res. Capacity Entry');
        MyTable.add('Job Ledger Entry');
        MyTable.add('Reversal Entry');
        MyTable.add('Res. Ledger Entry');
        MyTable.add('Gen. Jnl. Allocation');
        MyTable.add('Resource Register');
        MyTable.add('Job Register');
        MyTable.add('Requisition Line');
        MyTable.add('G/L Entry');
        MyTable.add('G/L Entry - VAT Entry Link');
        MyTable.add('VAT Entry');
        MyTable.add('Document Entry');
        MyTable.add('Bank Account Ledger Entry');
        MyTable.add('Check Ledger Entry');
        MyTable.add('Bank Acc. Reconciliation');
        MyTable.add('Phys. Inventory Ledger Entry');
        MyTable.add('Entry/Exit Point');
        MyTable.add('Reminder/Fin. Charge Entry');
        MyTable.add('Payable Vendor Ledger Entry');
        MyTable.add('Tracking Specification');
        MyTable.add('Reservation Entry');
        MyTable.add('Entry Summary');
        MyTable.add('Item Application Entry');
        MyTable.add('Item Application Entry History');
        MyTable.add('Analysis View');
        MyTable.add('Analysis View Entry');
        MyTable.add('Analysis View Budget Entry');
        MyTable.add('Detailed Cust. Ledg. Entry');
        MyTable.add('Detailed Vendor Ledg. Entry');
        MyTable.add('Change Log Entry');
        MyTable.add('Approval Entry');
        MyTable.add('Posted Approval Entry');
        MyTable.add('Overdue Approval Entry');
        MyTable.add('Job Queue Entry');
        MyTable.add('Job Queue Log Entry');
        MyTable.add('Standard General Journal Line');
        MyTable.add('Assembly Header');
        MyTable.add('Assembly Line');
        MyTable.add('Assemble-to-Order Link');
        MyTable.add('Assembly Comment Line');
        MyTable.add('Posted Assembly Header');
        MyTable.add('Posted Assembly Line');
        MyTable.add('Posted Assemble-to-Order Link');
        MyTable.add('Job Task');
        MyTable.add('Job Task Dimension');
        MyTable.add('Job Planning Line');
        MyTable.add('Job WIP Entry');
        MyTable.add('Job WIP G/L Entry');
        MyTable.add('Job Entry No.');
        MyTable.add('Interaction Log Entry');
        MyTable.add('Campaign Entry');
        MyTable.add('Opportunity');
        MyTable.add('Opportunity Entry');
        MyTable.add('Sales Header Archive');
        MyTable.add('Sales Line Archive');
        MyTable.add('Purchase Header Archive');
        MyTable.add('Purchase Line Archive');
        MyTable.add('Inter. Log Entry Comment Line');
        MyTable.add('Purch. Comment Line Archive');
        MyTable.add('Sales Comment Line Archive');
        MyTable.add('Production Order');
        MyTable.add('Prod. Order Line');
        MyTable.add('Prod. Order Component');
        MyTable.add('Prod. Order Routing Line');
        MyTable.add('Prod. Order Capacity Need');
        MyTable.add('Prod. Order Comment Line');
        MyTable.add('FA Ledger Entry');
        MyTable.add('Maintenance Registration');
        MyTable.add('FA Register');
        MyTable.add('FA Journal Line');
        MyTable.add('FA Reclass. Journal Line');
        MyTable.add('Maintenance Ledger Entry');
        MyTable.add('Ins. Coverage Ledger Entry');
        MyTable.add('Insurance Journal Line');
        MyTable.add('Insurance Register');
        MyTable.add('Stockkeeping Unit');
        MyTable.add('Nonstock Item');
        MyTable.add('Transfer Header');
        MyTable.add('Transfer Line');
        MyTable.add('Transfer Shipment Header');
        MyTable.add('Transfer Shipment Line');
        MyTable.add('Transfer Receipt Header');
        MyTable.add('Transfer Receipt Line');
        MyTable.add('Warehouse Request');
        MyTable.add('Warehouse Activity Header');
        MyTable.add('Warehouse Activity Line');
        MyTable.add('Whse. Cross-Dock Opportunity');
        MyTable.add('Warehouse Comment Line');
        MyTable.add('Registered Whse. Activity Hdr.');
        MyTable.add('Registered Whse. Activity Line');
        MyTable.add('Value Entry');
        MyTable.add('Avg. Cost Adjmt. Entry Point');
        MyTable.add('Item Charge Assignment (Purch)');
        MyTable.add('Item Charge Assignment (Sales)');
        MyTable.add('Post Value Entry to G/L');
        MyTable.add('Inventory Period Entry');
        MyTable.add('G/L - Item Ledger Relation');
        MyTable.add('Capacity Ledger Entry');
        MyTable.add('Standard Cost Worksheet');
        MyTable.add('Inventory Report Entry');
        MyTable.add('Service Header');
        MyTable.add('Service Item Line');
        MyTable.add('Service Line');
        MyTable.add('Service Ledger Entry');
        MyTable.add('Warranty Ledger Entry');
        MyTable.add('Loaner Entry');
        MyTable.add('Service Register');
        MyTable.add('Service Document Register');
        MyTable.add('Service Contract Line');
        MyTable.add('Service Contract Header');
        MyTable.add('Contract Gain/Loss Entry');
        MyTable.add('Service Shipment Header');
        MyTable.add('Service Shipment Line');
        MyTable.add('Service Invoice Header');
        MyTable.add('Service Invoice Line');
        MyTable.add('Service Cr.Memo Header');
        MyTable.add('Service Cr.Memo Line');
        MyTable.add('Serial No. Information');
        MyTable.add('Lot No. Information');
        MyTable.add('Item Entry Relation');
        MyTable.add('Value Entry Relation');
        MyTable.add('Whse. Item Entry Relation');
        MyTable.add('Whse. Item Tracking Line');
        MyTable.add('Return Shipment Header');
        MyTable.add('Return Shipment Line');
        MyTable.add('Return Receipt Header');
        MyTable.add('Return Receipt Line');
        MyTable.add('Analysis Report Name');
        MyTable.add('Analysis Line Template');
        MyTable.add('Item Budget Name');
        MyTable.add('Item Budget Entry');
        MyTable.add('Item Analysis View');
        MyTable.add('Item Analysis View Entry');
        MyTable.add('Item Analysis View Budg. Entry');
        MyTable.add('Bin Content');
        MyTable.add('Warehouse Journal Line');
        MyTable.add('Warehouse Entry');
        MyTable.add('Warehouse Register');
        MyTable.add('Warehouse Receipt Header');
        MyTable.add('Warehouse Receipt Line');
        MyTable.add('Posted Whse. Receipt Header');
        MyTable.add('Posted Whse. Receipt Line');
        MyTable.add('Warehouse Shipment Header');
        MyTable.add('Warehouse Shipment Line');
        MyTable.add('Posted Whse. Shipment Header');
        MyTable.add('Posted Whse. Shipment Line');
        MyTable.add('Whse. Put-away Request');
        MyTable.add('Whse. Pick Request');
        MyTable.add('Whse. Worksheet Line');
        MyTable.add('Calendar Entry');
        MyTable.add('Calendar Absence Entry');
        MyTable.add('Routing Header');
        MyTable.add('Routing Line');
        MyTable.add('Manufacturing Comment Line');
        MyTable.add('Production BOM Header');
        MyTable.add('Production BOM Line');
        MyTable.add('Family');
        MyTable.add('Family Line');
        MyTable.add('Order Tracking Entry');
        MyTable.add('Planning Component');
        MyTable.add('Planning Routing Line');
        MyTable.add('Action Message Entry');
        MyTable.add('Planning Assignment');
        MyTable.add('Production Forecast Entry');
        MyTable.add('Untracked Planning Element');
        MyTable.add('Posted Gen.Journal Batch');
        MyTable.add('Posted Gen. Journal Line');
        MyTable.add('NCT VAT Transections');
        MyTable.add('NCT Tax & WHT Header');
        MyTable.add('NCT Tax & WHT Line');
        MyTable.add('NCT WHT Header');
        MyTable.add('NCT WHT Line');
        MyTable.add('NCT WHT Applied Entry');
        MyTable.add('Bank Acc. Reconciliation Line');
        MyTable.add('IC Outbox Transaction');
        MyTable.add('IC Outbox Jnl. Line');
        MyTable.add('Handled IC Outbox Trans.');
        MyTable.add('Handled IC Outbox Jnl. Line');
        MyTable.add('IC Inbox Transaction');
        MyTable.add('IC Inbox Jnl. Line');
        MyTable.add('Handled IC Inbox Trans.');
        MyTable.add('Handled IC Inbox Jnl. Line');
        MyTable.add('IC Inbox/Outbox Jnl. Line Dim.');
        MyTable.add('IC Comment Line');
        MyTable.add('IC Outbox Sales Header');
        MyTable.add('IC Outbox Sales Line');
        MyTable.add('IC Outbox Purchase Header');
        MyTable.add('IC Outbox Purchase Line');
        MyTable.add('Handled IC Outbox Sales Header');
        MyTable.add('Handled IC Outbox Sales Line');
        MyTable.add('Handled IC Outbox Purch. Hdr');
        MyTable.add('Handled IC Outbox Purch. Line');
        MyTable.add('IC Inbox Sales Header');
        MyTable.add('IC Inbox Sales Line');
        MyTable.add('IC Inbox Purchase Header');
        MyTable.add('IC Inbox Purchase Line');
        MyTable.add('Handled IC Inbox Sales Header');
        MyTable.add('Handled IC Inbox Sales Line');
        MyTable.add('Handled IC Inbox Purch. Header');
        MyTable.add('Handled IC Inbox Purch. Line');
        MyTable.add('IC Document Dimension');
        MyTable.add('Activities Cue');
        MyTable.add('Top Customers By Sales Buffer');
        MyTable.add('Deferral Header');
        MyTable.add('Deferral Line');
        MyTable.add('Posted Deferral Header');
        MyTable.add('Posted Deferral Line');
        MyTable.add('Deferral Header Archive');
        MyTable.add('Deferral Line Archive');
        MyTable.add('Team Member Cue');
        MyTable.add('Service Cue');
        MyTable.add('Sales Cue');
        MyTable.add('Finance Cue');
        MyTable.add('Purchase Cue');
        MyTable.add('Manufacturing Cue');
        MyTable.add('Job Cue');
        MyTable.add('Warehouse Worker WMS Cue');
        MyTable.add('Administration Cue');
        MyTable.add('SB Owner Cue');
        MyTable.add('RapidStart Services Cue');
        MyTable.add('Relationship Mgmt. Cue');
        MyTable.add('NCT Billing Receipt Header');
        MyTable.add('NCT Billing Receipt Line');
        OnAfterAddtableCleanMaster(MyTable);
        RecordDeltetionEntry.reset();
        RecordDeltetionEntry.SetRange("Transaction Type", RecordDeltetionEntry."Transaction Type"::Transaction);
        RecordDeltetionEntry.DeleteAll();
        foreach NyTableName in MyTable do begin
            ObjectAll.reset();
            ObjectAll.SetRange("Object Type", ObjectAll."Object Type"::Table);
            ObjectAll.SetRange("Object Name", NyTableName);
            if ObjectAll.FindFirst() then begin
                RecordDeltetionEntry.init();
                RecordDeltetionEntry."Table ID" := ObjectAll."Object ID";
                RecordDeltetionEntry."Table Name" := ObjectAll."Object Name";
                RecordDeltetionEntry."Delete Records" := true;
                RecordDeltetionEntry."Transaction Type" := RecordDeltetionEntry."Transaction Type"::Transaction;
                RecordDeltetionEntry.Insert();
            end;
        end;
    end;

    /// <summary>
    /// Generate Table.
    /// </summary>
    procedure "Generate TableMaster"()
    var
        MyTable: list of [text];
        RecordDeltetionEntry: Record "NCT Record Deletion Table";
        ObjectAll: Record AllObj;
        NyTableName: Text[250];
    begin
        CLEAR(NyTableName);
        CLEAR(MyTable);
        MyTable.add('Payment Terms');
        MyTable.add('Currency');
        MyTable.add('Finance Charge Terms');
        MyTable.add('Customer Price Group');
        MyTable.add('Shipment Method');
        MyTable.add('Salesperson/Purchaser');
        MyTable.add('Location');
        MyTable.add('G/L Account');
        MyTable.add('Customer');
        MyTable.add('Cust. Invoice Disc.');
        MyTable.add('Vendor');
        MyTable.add('Vendor Invoice Disc.');
        MyTable.add('Item');
        MyTable.add('Acc. Schedule Name');
        MyTable.add('Acc. Schedule Line');
        MyTable.add('Customer Posting Group');
        MyTable.add('Vendor Posting Group');
        MyTable.add('Inventory Posting Group');
        MyTable.add('Item Vendor');
        MyTable.add('Unit of Measure');
        MyTable.add('Gen. Business Posting Group');
        MyTable.add('Gen. Product Posting Group');
        MyTable.add('General Posting Setup');
        MyTable.add('Bank Account');
        MyTable.add('Bank Account Posting Group');
        MyTable.add('Customer Bank Account');
        MyTable.add('Vendor Bank Account');
        MyTable.add('Payment Method');
        MyTable.add('Shipping Agent');
        MyTable.add('No. Series');
        MyTable.add('No. Series Line');
        MyTable.add('No. Series Relationship');
        MyTable.add('Resources Setup');
        MyTable.add('VAT Business Posting Group');
        MyTable.add('VAT Product Posting Group');
        MyTable.add('VAT Posting Setup');
        MyTable.add('Currency Exchange Rate');
        MyTable.add('Column Layout Name');
        MyTable.add('Column Layout');
        MyTable.add('Customer Discount Group');
        MyTable.add('Item Discount Group');
        MyTable.add('Dimension');
        MyTable.add('Dimension Value');
        MyTable.add('Dimension Combination');
        MyTable.add('Dimension Value Combination');
        MyTable.add('Default Dimension');
        MyTable.add('Dimension ID Buffer');
        MyTable.add('Default Dimension Priority');
        MyTable.add('Dimension Set ID Filter Line');
        MyTable.add('Dim. Value per Account');
        MyTable.add('Analysis View Filter');
        MyTable.add('Selected Dimension');
        MyTable.add('IC G/L Account');
        MyTable.add('IC Dimension');
        MyTable.add('IC Dimension Value');
        MyTable.add('IC Partner');
        MyTable.add('IC Bank Account');
        MyTable.add('IC Setup');
        MyTable.add('Customer Template');
        MyTable.add('Item Template');
        MyTable.add('Vendor Template');
        MyTable.add('Employee Template');
        MyTable.add('Workflow Step Instance');
        MyTable.add('Workflow Step Instance Archive');
        MyTable.add('Workflow Step Argument Archive');
        MyTable.add('Deferral Template');
        MyTable.add('Contact');
        MyTable.add('Business Relation');
        MyTable.add('Fixed Asset');
        MyTable.add('FA Class');
        MyTable.add('FA Subclass');
        MyTable.add('FA Location');
        MyTable.add('FA Depreciation Book');
        MyTable.add('Item Charge');
        MyTable.add('Price List');
        MyTable.add('Price List Line');
        MyTable.add('Sales Price');
        MyTable.add('Sales Line Discount');
        MyTable.add('Purchase Price');
        MyTable.add('Purchase Line Discount');
        MyTable.add('Bin');
        MyTable.add('Item Attribute');
        MyTable.add('Item Attribute Value');
        MyTable.add('Item Attribute Translation');
        MyTable.add('Item Attr. Value Translation');
        MyTable.add('Item Attribute Value Selection');
        MyTable.add('Item Attribute Value Mapping');
        MyTable.add('Over-Receipt Code');
        MyTable.add('NCT WHT Business Posting Group');
        MyTable.add('NCT WHT Posting Setup');
        MyTable.add('NCT WHT Product Posting Group');
        MyTable.Add('NCT Caption Report Setup');
        OnAfterAddtableCleanTransaction(MyTable);
        RecordDeltetionEntry.reset();
        RecordDeltetionEntry.SetRange("Transaction Type", RecordDeltetionEntry."Transaction Type"::Master);
        RecordDeltetionEntry.DeleteAll();
        foreach NyTableName in MyTable do begin
            ObjectAll.reset();
            ObjectAll.SetRange("Object Type", ObjectAll."Object Type"::Table);
            ObjectAll.SetRange("Object Name", NyTableName);
            if ObjectAll.FindFirst() then begin
                RecordDeltetionEntry.init();
                RecordDeltetionEntry."Table ID" := ObjectAll."Object ID";
                RecordDeltetionEntry."Table Name" := ObjectAll."Object Name";
                RecordDeltetionEntry."Delete Records" := true;
                RecordDeltetionEntry."Transaction Type" := RecordDeltetionEntry."Transaction Type"::Master;
                RecordDeltetionEntry.Insert();
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAddtableCleanTransaction(var pMyTable: List of [text])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAddtableCleanMaster(var pMyTable: List of [text])
    begin
    end;

}
