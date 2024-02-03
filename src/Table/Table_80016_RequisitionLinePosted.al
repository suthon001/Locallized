/// <summary>
/// Table NCT Requisition Line Posted (ID 80016).
/// </summary>
table 80016 "NCT Requisition Line Posted"
{
    Caption = 'Requisition Line Posted';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("Worksheet Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Enum "Requisition Line Type")
        {
            Caption = 'Type';

        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item;


        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;


        }
        field(9; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ValidateTableRelation = false;



        }
        field(10; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(12; "Due Date"; Date)
        {
            Caption = 'Due Date';


        }
        field(13; "Requester ID"; Code[50])
        {
            Caption = 'Requester ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;


        }
        field(14; Confirmed; Boolean)
        {
            Caption = 'Confirmed';
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));


        }
        field(17; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));


        }
        field(18; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(19; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(20; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(21; "Order Date"; Date)
        {
            Caption = 'Order Date';


        }
        field(22; "Vendor Item No."; Text[50])
        {
            Caption = 'Vendor Item No.';
        }
        field(23; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));

        }
        field(24; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

        }
        field(25; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;


        }
        field(26; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Editable = false;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));


        }
        field(28; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code where("Vendor No." = field("Vendor No."));
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;


        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;

        }
        field(31; "Reserved Quantity"; Decimal)
        {
            CalcFormula = sum("Reservation Entry".Quantity where("Source ID" = field("Worksheet Template Name"),
                                                                  "Source Ref. No." = field("Line No."),
                                                                  "Source Type" = const(246),
                                                                  "Source Subtype" = const("0"),
                                                                  "Source Batch Name" = field("Journal Batch Name"),
                                                                  "Source Prod. Order Line" = const(0),
                                                                  "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser" where(Blocked = const(false));


        }
        field(73; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";


        }
        field(5401; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            Editable = false;
            TableRelation = "Production Order"."No." where(Status = const(Released));
            ValidateTableRelation = false;


        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));


        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"),
                                            "Item Filter" = field("No."),
                                            "Variant Filter" = field("Variant Code"));


        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5405; "Qty. Rounding Precision"; Decimal)
        {
            Caption = 'Qty. Rounding Precision';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(5406; "Qty. Rounding Precision (Base)"; Decimal)
        {
            Caption = 'Qty. Rounding Precision (Base)';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            "Unit of Measure";


        }
        field(5408; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;


        }
        field(5431; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Source ID" = field("Worksheet Template Name"),
                                                                           "Source Ref. No." = field("Line No."),
                                                                           "Source Type" = const(246),
                                                                           "Source Subtype" = const("0"),
                                                                           "Source Batch Name" = field("Journal Batch Name"),
                                                                           "Source Prod. Order Line" = const(0),
                                                                           "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5520; "Demand Type"; Integer)
        {
            Caption = 'Demand Type';
            Editable = false;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(5521; "Demand Subtype"; Option)
        {
            Caption = 'Demand Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9";
        }
        field(5522; "Demand Order No."; Code[20])
        {
            Caption = 'Demand Order No.';
            Editable = false;
        }
        field(5525; "Demand Line No."; Integer)
        {
            Caption = 'Demand Line No.';
            Editable = false;
        }
        field(5526; "Demand Ref. No."; Integer)
        {
            Caption = 'Demand Ref. No.';
            Editable = false;
        }
        field(5527; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(5530; "Demand Date"; Date)
        {
            Caption = 'Demand Date';
            Editable = false;
        }
        field(5532; "Demand Quantity"; Decimal)
        {
            Caption = 'Demand Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5533; "Demand Quantity (Base)"; Decimal)
        {
            Caption = 'Demand Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5538; "Needed Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5539; "Needed Quantity (Base)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5540; Reserve; Boolean)
        {
            Caption = 'Reserve';


        }
        field(5541; "Qty. per UOM (Demand)"; Decimal)
        {
            Caption = 'Qty. per UOM (Demand)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5542; "Unit Of Measure Code (Demand)"; Code[10])
        {
            Caption = 'Unit Of Measure Code (Demand)';
            Editable = false;
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5552; "Supply From"; Code[20])
        {
            Caption = 'Supply From';
            TableRelation = if ("Replenishment System" = const(Purchase)) Vendor
            else
            if ("Replenishment System" = const(Transfer)) Location where("Use As In-Transit" = const(false));


        }
        field(5553; "Original Item No."; Code[20])
        {
            Caption = 'Original Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(5554; "Original Variant Code"; Code[10])
        {
            Caption = 'Original Variant Code';
            Editable = false;
            TableRelation = "Item Variant".Code where("Item No." = field("Original Item No."));
        }
        field(5560; Level; Integer)
        {
            Caption = 'Level';
            Editable = false;
        }
        field(5563; "Demand Qty. Available"; Decimal)
        {
            Caption = 'Demand Qty. Available';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5590; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
        }
        field(5701; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = if (Type = const(Item)) "Item Category";
        }
        field(5702; Nonstock; Boolean)
        {
            Caption = 'Catalog';
        }
        field(5703; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5705; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            ObsoleteReason = 'Product Groups became first level children of Item Categories.';
            ObsoleteState = Removed;
            ObsoleteTag = '15.0';
        }
        field(5706; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));


        }
        field(5707; "Transfer Shipment Date"; Date)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            Caption = 'Transfer Shipment Date';
            Editable = false;
        }
        field(7000; "Price Calculation Method"; Enum "Price Calculation Method")
        {
            Caption = 'Price Calculation Method';
        }
        field(7002; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(7100; "Blanket Purch. Order Exists"; Boolean)
        {
            CalcFormula = exist("Purchase Line" where("Document Type" = const("Blanket Order"),
                                                       Type = const(Item),
                                                       "No." = field("No."),
                                                       "Outstanding Quantity" = filter(<> 0)));
            Caption = 'Blanket Purch. Order Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7110; "Custom Sorting Order"; Code[50])
        {
            Caption = 'Custom Sorting Order';
        }

        field(80000; "NCT Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(80002; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80003; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "NCT PR No. Series"; Code[20])
        {
            Caption = 'PR No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(80005; "NCT Document Date"; date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(99998; "Ref. PO No."; code[20])
        {
            Caption = 'Ref. PO No.';
            Editable = false;
        }
        field(99999; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";


        }
        field(99000751; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            TableRelation = "Prod. Order Routing Line"."Operation No." where(Status = const(Released),
                                                                              "Prod. Order No." = field("Prod. Order No."),
                                                                              "Routing No." = field("Routing No."));


        }
        field(99000752; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center";

        }
        field(99000754; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            Editable = false;
            TableRelation = "Prod. Order Line"."Line No." where(Status = const(Finished),
                                                                 "Prod. Order No." = field("Prod. Order No."));
        }
        field(99000755; "MPS Order"; Boolean)
        {
            Caption = 'MPS Order';
        }
        field(99000756; "Planning Flexibility"; Enum "Reservation Planning Flexibility")
        {
            Caption = 'Planning Flexibility';


        }
        field(99000757; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
        }
        field(99000882; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(99000883; "Gen. Business Posting Group"; Code[20])
        {
            Caption = 'Gen. Business Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(99000884; "Low-Level Code"; Integer)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(99000885; "Production BOM Version Code"; Code[20])
        {
            Caption = 'Production BOM Version Code';
            TableRelation = "Production BOM Version"."Version Code" where("Production BOM No." = field("Production BOM No."));


        }
        field(99000886; "Routing Version Code"; Code[20])
        {
            Caption = 'Routing Version Code';
            TableRelation = "Routing Version"."Version Code" where("Routing No." = field("Routing No."));


        }
        field(99000887; "Routing Type"; Option)
        {
            Caption = 'Routing Type';
            OptionCaption = 'Serial,Parallel';
            OptionMembers = Serial,Parallel;
        }
        field(99000888; "Original Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Original Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000889; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(99000890; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(99000891; "Original Due Date"; Date)
        {
            Caption = 'Original Due Date';
            Editable = false;
        }
        field(99000892; "Scrap %"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Scrap %';
            DecimalPlaces = 0 : 5;
        }
        field(99000894; "Starting Date"; Date)
        {
            Caption = 'Starting Date';


        }
        field(99000895; "Starting Time"; Time)
        {
            Caption = 'Starting Time';


        }
        field(99000896; "Ending Date"; Date)
        {
            Caption = 'Ending Date';


        }
        field(99000897; "Ending Time"; Time)
        {
            Caption = 'Ending Time';


        }
        field(99000898; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header"."No.";


        }
        field(99000899; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
        }
        field(99000900; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0 : 5;
        }
        field(99000901; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;


        }
        field(99000902; "Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
            MinValue = 0;
        }
        field(99000903; "Replenishment System"; Enum "Replenishment System")
        {
            Caption = 'Replenishment System';


        }
        field(99000904; "Ref. Order No."; Code[20])
        {
            Caption = 'Ref. Order No.';
            Editable = false;
#pragma warning disable AL0603
            TableRelation = if ("Ref. Order Type" = const("Prod. Order")) "Production Order"."No." where(Status = field("Ref. Order Status"))
#pragma warning restore AL0603
            else
            if ("Ref. Order Type" = const(Purchase)) "Purchase Header"."No." where("Document Type" = const(Order))
            else
            if ("Ref. Order Type" = const(Transfer)) "Transfer Header"."No." where("No." = field("Ref. Order No."))
            else
            if ("Ref. Order Type" = const(Assembly)) "Assembly Header"."No." where("Document Type" = const(Order));
            ValidateTableRelation = false;


        }
        field(99000905; "Ref. Order Type"; Option)
        {
            Caption = 'Ref. Order Type';
            Editable = false;
            OptionCaption = ' ,Purchase,Prod. Order,Transfer,Assembly';
            OptionMembers = " ",Purchase,"Prod. Order",Transfer,Assembly;
        }
        field(99000906; "Ref. Order Status"; Option)
        {
            BlankZero = true;
            Caption = 'Ref. Order Status';
            Editable = false;
            OptionCaption = ',Planned,Firm Planned,Released';
            OptionMembers = ,Planned,"Firm Planned",Released;
        }
        field(99000907; "Ref. Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ref. Line No.';
            Editable = false;
        }
        field(99000908; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(99000909; "Expected Operation Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Planning Routing Line"."Expected Operation Cost Amt." where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                                                            "Worksheet Batch Name" = field("Journal Batch Name"),
                                                                                            "Worksheet Line No." = field("Line No.")));
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000910; "Expected Component Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Planning Component"."Cost Amount" where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                                        "Worksheet Batch Name" = field("Journal Batch Name"),
                                                                        "Worksheet Line No." = field("Line No.")));
            Caption = 'Expected Component Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000911; "Finished Qty. (Base)"; Decimal)
        {
            Caption = 'Finished Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000912; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000913; "Related to Planning Line"; Integer)
        {
            Caption = 'Related to Planning Line';
            Editable = false;
        }
        field(99000914; "Planning Level"; Integer)
        {
            Caption = 'Planning Level';
            Editable = false;
        }
        field(99000915; "Planning Line Origin"; Enum "Planning Line Origin Type")
        {
            Caption = 'Planning Line Origin';
            Editable = false;
        }
        field(99000916; "Action Message"; Enum "Action Message Type")
        {
            Caption = 'Action Message';


        }
        field(99000917; "Accept Action Message"; Boolean)
        {
            Caption = 'Accept Action Message';


        }
        field(99000918; "Net Quantity (Base)"; Decimal)
        {
            Caption = 'Net Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000919; "Starting Date-Time"; DateTime)
        {
            Caption = 'Starting Date-Time';


        }
        field(99000920; "Ending Date-Time"; DateTime)
        {
            Caption = 'Ending Date-Time';


        }
        field(99000921; "Order Promising ID"; Code[20])
        {
            Caption = 'Order Promising ID';
        }
        field(99000922; "Order Promising Line No."; Integer)
        {
            Caption = 'Order Promising Line No.';
        }
        field(99000923; "Order Promising Line ID"; Integer)
        {
            Caption = 'Order Promising Line ID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {

        }
        key(Key3; "Worksheet Template Name", "Journal Batch Name", "Vendor No.", "Sell-to Customer No.", "Ship-to Code", "Order Address Code", "Currency Code", "Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Location Code", "Transfer-from Code", "Purchasing Code")
        {
            MaintainSQLIndex = false;
        }
        key(Key4; Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Planning Line Origin", "Due Date", "Drop Shipment")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key5; Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Order Date")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key6; Type, "No.", "Variant Code", "Location Code", "Starting Date")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key7; "Worksheet Template Name", "Journal Batch Name", Type, "No.", "Due Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key8; "Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Ref. Line No.")
        {
        }
        key(Key9; "Replenishment System", Type, "No.", "Variant Code", "Transfer-from Code", "Transfer Shipment Date")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key10; "Order Promising ID", "Order Promising Line ID", "Order Promising Line No.")
        {
        }
        key(Key11; "User ID", "Demand Type", "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {
        }
        key(Key12; "User ID", "Demand Type", "Demand Subtype", "Demand Order No.", "Demand Line No.", "Demand Ref. No.")
        {
        }
        key(Key13; "User ID", "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key14; "Worksheet Template Name", "Journal Batch Name", "Custom Sorting Order")
        {
        }
        key(Key15; "Demand Order No.", "Demand Ref. No.", "Demand Subtype", "Demand Line No.", "Demand Type")
        {
            IncludedFields = "User ID";
        }
    }
    /// <summary>
    /// GetLastEntryNo.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastEntryNo(): Integer
    var
        RequisitionPosted: Record "NCT Requisition Line Posted";
    begin
        RequisitionPosted.reset();
        RequisitionPosted.ReadIsolation := IsolationLevel::UpdLock;
        RequisitionPosted.SetCurrentKey("Entry No.");
        if RequisitionPosted.FindLast() then
            exit(RequisitionPosted."Entry No." + 1);
        exit(1);
    end;

}

