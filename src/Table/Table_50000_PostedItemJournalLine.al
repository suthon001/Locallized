/// <summary>
/// Table Posted ItemJournal Lines (ID 50000).
/// </summary>
table 50000 "Posted ItemJournal Lines"
{
    Caption = 'Posted Item Journal Lines';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = SystemMetadata;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = SystemMetadata;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(5; "Entry Type"; Enum "Item Journal Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = SystemMetadata;
        }
        field(6; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = SystemMetadata;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = SystemMetadata;
        }
        field(8; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = SystemMetadata;
        }
        field(10; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            DataClassification = SystemMetadata;
        }
        field(11; "Source Posting Group"; Code[20])
        {
            Caption = 'Source Posting Group';
            DataClassification = SystemMetadata;
        }
        field(13; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(15; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
            DataClassification = SystemMetadata;
        }
        field(16; "Unit Amount"; Decimal)
        {
            Caption = 'Unit Amount';
            DataClassification = SystemMetadata;
        }
        field(17; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = SystemMetadata;
        }
        field(18; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = SystemMetadata;
        }
        field(22; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DataClassification = SystemMetadata;
        }
        field(23; "Salespers./Purch. Code"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            DataClassification = SystemMetadata;
        }
        field(26; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = SystemMetadata;
        }
        field(29; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
            DataClassification = SystemMetadata;
        }
        field(32; "Item Shpt. Entry No."; Integer)
        {
            Caption = 'Item Shpt. Entry No.';
            DataClassification = SystemMetadata;
        }
        field(34; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = SystemMetadata;
        }
        field(35; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = SystemMetadata;
        }
        field(37; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %"';
            DataClassification = SystemMetadata;
        }
        field(39; "Source Type"; Enum "Analysis Source Type")
        {
            Caption = 'Source Type';
            DataClassification = SystemMetadata;

        }
        field(40; "Shpt. Method Code"; Code[10])
        {
            Caption = 'Shpt. Method Code';
            DataClassification = SystemMetadata;
        }
        field(41; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = SystemMetadata;
        }
        field(42; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = SystemMetadata;
        }
        field(43; "Recurring Method"; Option)

        {
            Caption = 'Recurring Method';
            DataClassification = SystemMetadata;
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(44; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = SystemMetadata;
        }
        field(45; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
            DataClassification = SystemMetadata;
        }
        field(46; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            DataClassification = SystemMetadata;
        }
        field(47; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            DataClassification = SystemMetadata;
        }
        field(48; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method"';
            DataClassification = SystemMetadata;
        }
        field(49; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = SystemMetadata;
        }
        field(50; "New Location Code"; Code[10])
        {
            Caption = 'New Location Code';
            DataClassification = SystemMetadata;
        }
        field(51; "New Shortcut Dim. 1 Code"; Code[20])
        {
            Caption = 'New Shortcut Dim. 1 Code';
            DataClassification = SystemMetadata;
        }
        field(52; "New Shortcut Dim. 2 Code"; Code[20])
        {
            Caption = 'New Shortcut Dim. 2 Code';
            DataClassification = SystemMetadata;
        }
        field(53; "Qty. (Calculated)"; Decimal)
        {
            Caption = 'Qty. (Calculated)';
            DataClassification = SystemMetadata;
        }
        field(54; "Qty. (Phys. Inventory)"; Decimal)
        {
            Caption = 'Qty. (Phys. Inventory)';
            DataClassification = SystemMetadata;
        }
        field(55; "Last Item Ledger Entry No."; Integer)
        {
            Caption = 'Last Item Ledger Entry No.';
            DataClassification = SystemMetadata;
        }
        field(56; "Phys. Inventory"; Boolean)
        {
            Caption = 'Phys. Inventory';
            DataClassification = SystemMetadata;
        }
        field(57; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = SystemMetadata;
        }
        field(58; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = SystemMetadata;
        }
        field(59; "Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            DataClassification = SystemMetadata;
        }
        field(60; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = SystemMetadata;
        }
        field(62; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = SystemMetadata;
        }
        field(63; "Area"; Code[10])
        {
            Caption = 'Area';
            DataClassification = SystemMetadata;
        }
        field(64; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            DataClassification = SystemMetadata;
        }
        field(65; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = SystemMetadata;
        }
        field(68; "Reserved Quantity"; Decimal)
        {
            Caption = 'Reserved Quantity';
            DataClassification = SystemMetadata;
        }
        field(72; "Unit Cost (ACY)"; Decimal)
        {
            Caption = 'Unit Cost (ACY)';
            DataClassification = SystemMetadata;
        }
        field(73; "Source Currency Code"; Code[10])
        {
            Caption = 'Source Currency Code';
            DataClassification = SystemMetadata;
        }
        field(79; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;
        }
        field(80; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
        field(86; "VAT Reporting Date"; Date)
        {
            Caption = 'VAT Date';
            DataClassification = SystemMetadata;
        }
        field(90; "Order Type"; Enum "Inventory Order Type")
        {
            Caption = 'Order Type';
            DataClassification = SystemMetadata;

        }
        field(91; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = SystemMetadata;
        }
        field(92; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            DataClassification = SystemMetadata;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = SystemMetadata;
        }
        field(481; "New Dimension Set ID"; Integer)
        {
            Caption = 'New Dimension Set ID';
            DataClassification = SystemMetadata;
        }
        field(904; "Assemble to Order"; Boolean)
        {
            Caption = 'Assemble to Order';
            DataClassification = SystemMetadata;
        }
        field(1000; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = SystemMetadata;
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = SystemMetadata;
        }
        field(1002; "Job Purchase"; Boolean)
        {
            Caption = 'Job Purchase';
            DataClassification = SystemMetadata;
        }
        field(1030; "Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            DataClassification = SystemMetadata;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = SystemMetadata;
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = SystemMetadata;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = SystemMetadata;
        }
        field(5406; "New Bin Code"; Code[20])
        {
            Caption = 'New Bin Code';
            DataClassification = SystemMetadata;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = SystemMetadata;
        }
        field(5408; "Derived from Blanket Order"; Boolean)
        {
            Caption = 'Derived from Blanket Order';
            DataClassification = SystemMetadata;
        }
        field(5413; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = SystemMetadata;
        }
        field(5415; "Invoiced Qty. (Base)"; Decimal)
        {
            Caption = 'Invoiced Qty. (Base)';
            DataClassification = SystemMetadata;
        }
        field(5468; "Reserved Qty. (Base)"; Decimal)
        {
            Caption = 'Reserved Qty. (Base)';
            DataClassification = SystemMetadata;
        }
        field(5560; "Level"; Integer)
        {
            Caption = 'Level';
            DataClassification = SystemMetadata;
        }
        field(5561; "Flushing Method"; Enum "Flushing Method")
        {
            Caption = 'Flushing Method';
            DataClassification = SystemMetadata;

        }
        field(5562; "Changed by User"; Boolean)
        {
            Caption = 'Changed by User';
            DataClassification = SystemMetadata;
        }
        field(5700; "Cross-Reference No."; Code[20])
        {
            Caption = 'Cross-Reference No.';
            DataClassification = SystemMetadata;
        }
        field(5701; "Originally Ordered No."; Code[20])
        {
            Caption = 'Originally Ordered No.';
            DataClassification = SystemMetadata;
        }
        field(5702; "Origi. Ordered Var. Code"; Code[10])
        {
            Caption = 'Originally Ordered Var. Code';
            DataClassification = SystemMetadata;
        }
        field(5703; "Out-of-Stock Substitution"; Boolean)
        {
            Caption = 'Out-of-Stock Substitution';
            DataClassification = SystemMetadata;
        }
        field(5704; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = SystemMetadata;
        }
        field(5705; "Nonstock"; Boolean)
        {
            Caption = 'Nonstock';
            DataClassification = SystemMetadata;
        }
        field(5706; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            DataClassification = SystemMetadata;
        }
        field(5707; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = SystemMetadata;
        }
        field(5791; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
            DataClassification = SystemMetadata;
        }
        field(5793; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = SystemMetadata;
        }
        field(5800; "Value Entry Type"; Enum "Cost Entry Type")
        {
            Caption = 'Value Entry Type';
            DataClassification = SystemMetadata;

        }
        field(5801; "Item Charge No."; Code[20])
        {
            Caption = 'Item Charge No.';
            DataClassification = SystemMetadata;
        }
        field(5802; "Inventory Value (Cal.)"; Decimal)
        {
            Caption = 'Inventory Value (Calculated)';
            DataClassification = SystemMetadata;
        }
        field(5803; "Inventory Value (Revalued)"; Decimal)
        {
            Caption = 'Inventory Value (Revalued)';
            DataClassification = SystemMetadata;
        }
        field(5804; "Variance Type"; Enum "Cost Variance Type")
        {
            Caption = 'Variance Type';
            DataClassification = SystemMetadata;

        }
        field(5805; "Inventory Value Per"; Option)
        {
            Caption = 'Inventory Value Per"';
            DataClassification = SystemMetadata;
            OptionCaption = ' ,Item,Location,Variant,Location and Variant';
            OptionMembers = " ",Item,Location,Variant,"Location and Variant";
        }
        field(5806; "Partial Revaluation"; Boolean)
        {
            Caption = 'Partial Revaluation';
            DataClassification = SystemMetadata;
        }
        field(5807; "Applies-from Entry"; Integer)
        {
            Caption = 'Applies-from Entry';
            DataClassification = SystemMetadata;
        }
        field(5808; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = SystemMetadata;
        }
        field(5809; "Unit Cost (Calculated)"; Decimal)
        {
            Caption = 'Unit Cost (Calculated)';
            DataClassification = SystemMetadata;
        }
        field(5810; "Unit Cost (Revalued)"; Decimal)
        {
            Caption = 'Unit Cost (Revalued)';
            DataClassification = SystemMetadata;
        }
        field(5811; "Applied Amount"; Decimal)
        {
            Caption = 'Applied Amount';
            DataClassification = SystemMetadata;
        }
        field(5812; "Update Standard Cost"; Boolean)
        {
            Caption = 'Update Standard Cost';
            DataClassification = SystemMetadata;
        }
        field(5813; "Amount (ACY)"; Decimal)
        {
            Caption = 'Amount (ACY)';
            DataClassification = SystemMetadata;
        }
        field(5817; "Correction"; Boolean)
        {
            Caption = 'Correction';
            DataClassification = SystemMetadata;
        }
        field(5818; "Adjustment"; Boolean)
        {
            Caption = 'Adjustment';
            DataClassification = SystemMetadata;
        }
        field(5819; "Applies-to Value Entry"; Integer)
        {
            Caption = 'Applies-to Value Entry';
            DataClassification = SystemMetadata;
        }
        field(5820; "Invoice-to Source No."; Code[20])
        {
            Caption = 'Invoice-to Source No.';
            DataClassification = SystemMetadata;
        }
        field(5830; "Type"; Enum "Capacity Type Journal")
        {
            Caption = 'Type';
            DataClassification = SystemMetadata;

        }
        field(5831; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(5838; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            DataClassification = SystemMetadata;
        }
        field(5839; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            DataClassification = SystemMetadata;
        }
        field(5841; "Setup Time"; Decimal)
        {
            Caption = 'Setup Time';
            DataClassification = SystemMetadata;
        }
        field(5842; "Run Time"; Decimal)
        {
            Caption = 'Run Time';
            DataClassification = SystemMetadata;
        }
        field(5843; "Stop Time"; Decimal)
        {
            Caption = 'Stop Time';
            DataClassification = SystemMetadata;
        }
        field(5846; "Output Quantity"; Decimal)
        {
            Caption = 'Output Quantity';
            DataClassification = SystemMetadata;
        }
        field(5847; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
            DataClassification = SystemMetadata;
        }
        field(5849; "Concurrent Capacity"; Decimal)
        {
            Caption = 'Concurrent Capacity';
            DataClassification = SystemMetadata;
        }
        field(5851; "Setup Time (Base)"; Decimal)
        {
            Caption = 'Setup Time (Base)';
            DataClassification = SystemMetadata;
        }
        field(5852; "Run Time (Base)"; Decimal)
        {
            Caption = 'Run Time (Base)';
            DataClassification = SystemMetadata;
        }
        field(5853; "Stop Time (Base)"; Decimal)
        {
            Caption = 'Stop Time (Base)';
            DataClassification = SystemMetadata;
        }
        field(5856; "Output Quantity (Base)"; Decimal)
        {
            Caption = 'Output Quantity (Base)';
            DataClassification = SystemMetadata;
        }
        field(5857; "Scrap Quantity (Base)"; Decimal)
        {
            Caption = 'Scrap Quantity (Base)';
            DataClassification = SystemMetadata;
        }
        field(5858; "Cap. Unit of Measure Code"; Code[10])
        {
            Caption = 'Cap. Unit of Measure Code';
            DataClassification = SystemMetadata;
        }
        field(5859; "Qty. per Cap. UOM"; Decimal)
        {
            Caption = 'Qty. per Cap. Unit of Measure';
            DataClassification = SystemMetadata;
        }
        field(5873; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
            DataClassification = SystemMetadata;
        }
        field(5874; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
            DataClassification = SystemMetadata;
        }
        field(5882; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            DataClassification = SystemMetadata;
        }
        field(5883; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            DataClassification = SystemMetadata;
        }
        field(5884; "Prod. Order Comp. Line No."; Integer)
        {
            Caption = 'Prod. Order Comp. Line No.';
            DataClassification = SystemMetadata;
        }
        field(5885; "Finished"; Boolean)
        {
            Caption = 'Finished';
            DataClassification = SystemMetadata;
        }
        field(5887; "Unit Cost Calculation"; Option)
        {
            Caption = 'Unit Cost Calculation';
            DataClassification = SystemMetadata;
            OptionCaption = 'Time,Units';
            OptionMembers = Time,Units;
        }
        field(5888; "Subcontracting"; Boolean)
        {
            Caption = 'Subcontracting';
            DataClassification = SystemMetadata;
        }
        field(5895; "Stop Code"; Code[10])
        {
            Caption = 'Stop Code';
            DataClassification = SystemMetadata;
        }
        field(5896; "Scrap Code"; Code[10])
        {
            Caption = 'Scrap Code';
            DataClassification = SystemMetadata;
        }
        field(5898; "Work Center Group Code"; Code[10])
        {
            Caption = 'Work Center Group Code';
            DataClassification = SystemMetadata;
        }
        field(5899; "Work Shift Code"; Code[10])
        {
            Caption = 'Work Shift Code';
            DataClassification = SystemMetadata;
        }
        field(6500; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = SystemMetadata;
        }
        field(6501; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = SystemMetadata;
        }
        field(6502; "Warranty Date"; Date)
        {
            Caption = 'Warranty Date';
            DataClassification = SystemMetadata;
        }
        field(6503; "New Serial No."; Code[50])
        {
            Caption = 'New Serial No.';
            DataClassification = SystemMetadata;
        }
        field(6504; "New Lot No."; Code[50])
        {
            Caption = 'New Lot No.';
            DataClassification = SystemMetadata;
        }
        field(6505; "New Item Expiration Date"; Date)
        {
            Caption = 'New Item Expiration Date';
            DataClassification = SystemMetadata;
        }
        field(6506; "Item Expiration Date"; Date)
        {
            Caption = 'Item Expiration Date';
            DataClassification = SystemMetadata;
        }
        field(6600; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            DataClassification = SystemMetadata;
        }
        field(7315; "Warehouse Adjustment"; Boolean)
        {
            Caption = 'Warehouse Adjustment';
            DataClassification = SystemMetadata;
        }
        field(7316; "Direct Transfer"; Boolean)
        {
            Caption = 'Direct Transfer';
            DataClassification = SystemMetadata;
        }
        field(7380; "Phys.Invt Count Peri Code"; Code[10])
        {
            Caption = 'Phys Invt Counting Period Code';
            DataClassification = SystemMetadata;
        }
        field(7381; "Phys.Invt Count Peri Type"; Option)
        {
            Caption = 'Phys Invt Counting Period Type';
            DataClassification = SystemMetadata;
            OptionCaption = ' ,Item,SKU';
            OptionMembers = " ",Item,SKU;
        }
        field(99000755; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DataClassification = SystemMetadata;
        }
        field(99000756; "Single-Level Material Cost"; Decimal)
        {
            Caption = 'Single-Level Material Cost';
            DataClassification = SystemMetadata;
        }
        field(99000757; "Single-Level Capacity Cost"; Decimal)
        {
            Caption = 'Single-Level Capacity Cost';
            DataClassification = SystemMetadata;
        }
        field(99000758; "Single-Lel Subcontrd. Cost"; Decimal)
        {
            Caption = 'Single-Level Subcontrd. Cost';
            DataClassification = SystemMetadata;
        }
        field(99000759; "Single-Lel Cap. Ovhd Cost"; Decimal)
        {
            Caption = 'Single-Level Cap. Ovhd Cost';
            DataClassification = SystemMetadata;
        }
        field(99000760; "Single-Lel Mfg. Ovhd Cost"; Decimal)
        {
            Caption = 'Single-Level Mfg. Ovhd Cost';
            DataClassification = SystemMetadata;
        }
        field(99000761; "Rolled-up Material Cost"; Decimal)
        {
            Caption = 'Rolled-up Material Cost';
            DataClassification = SystemMetadata;
        }
        field(99000762; "Rolled-up Capacity Cost"; Decimal)
        {
            Caption = 'Rolled-up Capacity Cost';
            DataClassification = SystemMetadata;
        }
        field(99000763; "Rolled-up Subcon. Cost"; Decimal)
        {
            Caption = 'olled-up Subcontracted Cost';
            DataClassification = SystemMetadata;
        }
        field(99000764; "Rolled-up Mfg. Ovhd Cost"; Decimal)
        {
            Caption = 'Rolled-up Mfg. Ovhd Cost';
            DataClassification = SystemMetadata;
        }
        field(99000765; "Rolled-up Cap. Overh. Cost"; Decimal)
        {
            Caption = 'Rolled-up Cap. Overhead Cost';
            DataClassification = SystemMetadata;
        }

        field(80000; "Status"; Enum "Purchase Document Status")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }

        field(80001; "ID"; GUID)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80002; "Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = SystemMetadata;
        }
        field(80003; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(80004; "Vat Bus. Posting Group"; Code[20])
        {
            Caption = 'Vat Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(80005; "Vendor/Customer Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Vendor/Customer Name';
        }
        field(80006; "Create By"; Code[30])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(80098; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            DataClassification = SystemMetadata;

        }
        field(80099; "Posted DateTime"; DateTime)
        {
            Caption = 'Posted DateTime';
            DataClassification = SystemMetadata;

        }
        field(80100; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;

        }
    }
    keys
    {
        key(PK1; "Entry No.") { Clustered = true; }
        key(PK2; "Journal Template Name", "Journal Batch Name", "Line No.") { }
    }
    /// <summary> 
    /// Description for LastPostedEntryNo.
    /// </summary>
    /// <returns>Return variable "Integer".</returns>
    procedure "LastPostedEntryNo"(): Integer
    var
        postedItemLine: Record "Posted ItemJournal Lines";
    begin
        postedItemLine.reset();
        if postedItemLine.FindLast() then
            EXIT(postedItemLine."Entry No." + 1);
        EXIT(1);
    end;

    /// <summary> 
    /// Description for ShowShortcutDimCode.
    /// </summary>
    /// <param name="ShortcutDimCode">Parameter of type array[8] of code[20].</param>
    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


}
