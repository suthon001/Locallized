codeunit 80013 "NCT Clear Transactions"
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
    TableData "Warehouse Entry" = rimd,
    TableData "NCT VAT Transections" = rimd, TableData "Posted Gen. Journal Line" = rimd, TableData "NCT Posted ItemJournal Lines" = rimd,
    TableData "NCT Tax & WHT Header" = rimd, TableData "NCT Tax & WHT Line" = rimd, TableData "NCT WHT Header" = rimd,
    TableData "NCT WHT Line" = rimd, TableData "NCT Billing Receipt Header" = rimd, TableData "NCT Billing Receipt Line" = rimd,
    tabledata "NCT Record Deletion Table" = rimd,
    tabledata "g/l entry - vat Entry link" = rimd,
    tabledata "Change Log Entry" = ridm,
    tabledata "Fa Register" = ridm,
    tabledata "NCT WHT Applied Entry" = ridm,
    tabledata "G/L - Item Ledger Relation" = ridm;
    trigger OnRun()
    begin
    end;

    var
        Text0002: Label 'Deleting Records!\Table: #1#######';

    procedure DeleteRecords(pCompanyName: Text; setdefultnoseries: Boolean)
    var
        Window: Dialog;
        RecRef: RecordRef;
        RecordDeletionTable: Record "NCT Record Deletion Table";
        NoseriesLine: Record "No. Series Line";
    begin
        Window.Open(Text0002);
        RecordDeletionTable.reset();
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
                if NoseriesLine.FindSet() then begin
                    NoseriesLine.modifyall("Last Date Used", 0D);
                    NoseriesLine.modifyall("Last No. Used", '');
                end;
            end;
        end else
            Message('Nothing to Clean');
        Window.Close();
    end;

    procedure "Generate Table"()
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
        MyTable.add('Posted Gen. Journal Line');
        MyTable.add('NCT VAT Transections');
        MyTable.add('NCT Tax & WHT Header');
        MyTable.add('NCT Tax & WHT Line');
        MyTable.add('NCT Posted ItemJournal Lines');
        MyTable.add('NCT WHT Header');
        MyTable.add('NCT WHT Line');
        MyTable.add('NCT Billing Receipt Header');
        MyTable.add('NCT Billing Receipt Line');
        MyTable.add('NCT WHT Applied Entry');
        RecordDeltetionEntry.reset();
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
                RecordDeltetionEntry.Insert();
            end;
        end;
    end;


}
