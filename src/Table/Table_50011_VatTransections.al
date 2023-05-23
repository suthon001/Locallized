/// <summary>
/// Table VAT Transections (ID 50011).
/// </summary>
table 50011 "VAT Transections"
{
    Caption = 'VAT Transections';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            Editable = false;
            TableRelation = "Gen. Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(3; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = false;
            TableRelation = "Gen. Product Posting Group";
            DataClassification = SystemMetadata;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(6; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(7; "Type"; Enum "General Posting Type")
        {
            Caption = 'Type';
            Editable = false;
            DataClassification = SystemMetadata;

        }
        field(8; "Base"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(9; "Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(10; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(12; "Bill-to/Pay-to No."; Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';
            TableRelation = IF ("Type" = CONST(Purchase)) Vendor
            ELSE
            IF ("Type" = CONST(Sale)) Customer;
            DataClassification = SystemMetadata;
        }
        field(13; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';

            DataClassification = SystemMetadata;
        }
        field(14; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            DataClassification = SystemMetadata;
            //This property is currently not supported
            //TestTableRelation = false;


        }
        field(15; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
            DataClassification = SystemMetadata;
        }
        field(16; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            Editable = false;
            TableRelation = "Reason Code";
            DataClassification = SystemMetadata;
        }
        field(17; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            Editable = false;
            TableRelation = "VAT Entry";
            DataClassification = SystemMetadata;
        }
        field(18; "Closed"; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(19; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = SystemMetadata;

        }
        field(20; "Internal Ref. No."; Text[30])
        {
            Caption = 'Internal Ref. No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(21; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(22; "Unrealized Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Unrealized Amount';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(23; "Unrealized Base"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Unrealized Base';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(24; "Remaining Unrealized Amt."; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Unrealized Amount';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(25; "Remaining Unrealized Base"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Unrealized Base';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(26; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(28; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = SystemMetadata;
        }
        field(29; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            Editable = false;
            TableRelation = "Tax Area";
            DataClassification = SystemMetadata;
        }
        field(30; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(31; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            Editable = false;
            TableRelation = "Tax Group";
            DataClassification = SystemMetadata;
        }
        field(32; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(33; "Tax Jurisdiction Code"; Code[10])
        {
            Caption = 'Tax Jurisdiction Code';
            Editable = false;
            TableRelation = "Tax Jurisdiction";
            DataClassification = SystemMetadata;
        }
        field(34; "Tax Group Used"; Code[20])
        {
            Caption = 'Tax Group Used';
            Editable = false;
            TableRelation = "Tax Group";
            DataClassification = SystemMetadata;
        }
        field(35; "Tax Type"; Option)
        {
            Caption = 'Tax Type';
            Editable = false;
            OptionCaption = 'Sales Tax,Excise Tax';
            OptionMembers = "Sales Tax","Excise Tax";
            DataClassification = SystemMetadata;
        }
        field(36; "Tax on Tax"; Boolean)
        {
            Caption = 'Tax on Tax';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(37; "Sales Tax Connection No."; Integer)
        {
            Caption = 'Sales Tax Connection No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(38; "Unrealized VAT Entry No."; Integer)
        {
            Caption = 'Unrealized VAT Entry No.';
            Editable = false;
            TableRelation = "VAT Entry";
            DataClassification = SystemMetadata;
        }
        field(39; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            Editable = false;
            TableRelation = "VAT Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(40; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            Editable = false;
            TableRelation = "VAT Product Posting Group";
            DataClassification = SystemMetadata;
        }
        field(43; "Additional-Currency Amount"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Additional-Currency Amount';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(44; "Additional-Currency Base"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Additional-Currency Base';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(45; "Add.-Curr. Unrealized Amt."; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Currency Unrealized Amt.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(46; "Add.-Curr. Unrealized Base"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Currency Unrealized Base';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(48; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
            DataClassification = SystemMetadata;
        }
        field(49; "Add.Curr. Rem. Unreal. Amt"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Curr. Rem. Unreal. Amount';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(50; "Add.Curr. Rem. Unreal.Base"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Curr. Rem. Unreal. Base';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(51; "VAT Difference"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(52; "Add.-Curr. VAT Difference"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Curr. VAT Difference';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(53; "Ship-to/Order Address Code"; Code[10])
        {
            Caption = 'Ship-to/Order Address Code';
            TableRelation = IF ("Type" = CONST(Purchase)) "Order Address".Code WHERE("Vendor No." = FIELD("Bill-to/Pay-to No."))
            ELSE
            IF ("Type" = CONST(Sale)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Bill-to/Pay-to No."));
            DataClassification = SystemMetadata;
        }
        field(54; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(55; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = SystemMetadata;

        }
        field(56; "Reversed"; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = SystemMetadata;
        }
        field(57; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "VAT Entry";
            DataClassification = SystemMetadata;
        }
        field(58; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "VAT Entry";
            DataClassification = SystemMetadata;
        }
        field(59; "EU Service"; Boolean)
        {
            Caption = 'EU Service';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(60; "Base Before Pmt. Disc."; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base Before Pmt. Disc.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(78; "Journal Templ. Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(79; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(81; "Realized Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Realized Amount';
            Editable = false;
        }
        field(82; "Realized Base"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Realized Base';
            Editable = false;
        }
        field(83; "Add.-Curr. Realized Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Curr. Realized Amount';
            Editable = false;
        }
        field(84; "Add.-Curr. Realized Base"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Curr. Realized Base';
            Editable = false;
        }
        field(85; "G/L Acc. No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(86; "VAT Reporting Date"; Date)
        {
            Caption = 'VAT Date';

        }
        field(80001; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80002; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80003; "Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;

        }
        field(80004; "Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80005; "Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            //TableRelation = Vendor."No.";
        }
        field(80006; "Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80007; "Description Line"; Text[100])
        {
            Caption = 'Description Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80009; "Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;

        }
        field(80010; "Tax Line No."; Integer)
        {
            Caption = 'Tax Line No.';
            DataClassification = SystemMetadata;

        }
        field(80011; "Tax Invoice Address"; Text[100])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = SystemMetadata;

        }
        field(80012; "Tax Invoice City"; Text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = SystemMetadata;

        }
        field(80013; "Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = SystemMetadata;

        }
        field(80014; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
        field(80015; "Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80016; "Tax Invoice Address 2"; Text[50])
        {
            Caption = 'Tax Invoice Address 2';
            DataClassification = SystemMetadata;

        }
        field(99993; "Ref. Tax Type"; Enum "Tax Type")
        {
            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Tax Type';
        }
        field(99994; "Ref. Tax No."; Code[30])
        {
            Editable = false;
            Caption = 'Ref. Tax No.';
            DataClassification = SystemMetadata;
        }
        field(99995; "Ref. Tax Line No."; Integer)
        {
            Editable = false;
            Caption = 'Ref. Tax Line No.';
            DataClassification = SystemMetadata;
        }
        field(99996; "Unrealized VAT Type"; Option)
        {
            Caption = 'Unrealized VAT Type';
            OptionCaption = ' ,Percentage,First,Last,First (Fully Paid),Last (Fully Paid)';
            OptionMembers = " ",Percentage,First,Last,"First (Fully Paid)","Last (Fully Paid)";
            FieldClass = FlowField;
            CalcFormula = lookup("VAT Posting Setup"."Unrealized VAT Type" where("VAT Bus. Posting Group" = field("VAT Bus. Posting Group"), "VAT Prod. Posting Group" = field("VAT Prod. Posting Group")));
            Editable = false;
        }
        field(99997; "Allow Generate to Purch. Vat"; Boolean)
        {
            Caption = 'Allow Generate Purch. to Vat';
            FieldClass = FlowField;
            CalcFormula = lookup("VAT Posting Setup"."Allow Generate to Purch. Vat" where("VAT Bus. Posting Group" = field("VAT Bus. Posting Group"), "VAT Prod. Posting Group" = field("VAT Prod. Posting Group")));
            Editable = false;

        }
        field(99998; "Allow Generate to Sale Vat"; Boolean)
        {
            Caption = 'Allow Generate Sale to Vat';
            FieldClass = FlowField;
            CalcFormula = lookup("VAT Posting Setup"."Allow Generate to Sales Vat" where("VAT Bus. Posting Group" = field("VAT Bus. Posting Group"), "VAT Prod. Posting Group" = field("VAT Prod. Posting Group")));
            Editable = false;

        }
        field(99999; "Get to Tax"; Boolean)
        {
            Caption = 'Get to Tax';
            DataClassification = SystemMetadata;
            Editable = false;

        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Type", "Closed", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date")
        {
            SumIndexFields = "Base", "Amount", "Additional-Currency Base", "Additional-Currency Amount", "Remaining Unrealized Amt.", "Remaining Unrealized Base", "Add.Curr. Rem. Unreal. Amt", "Add.Curr. Rem. Unreal.Base";
        }
        key(Key3; "Type", "Closed", "Tax Jurisdiction Code", "Use Tax", "Posting Date")
        {
            SumIndexFields = "Base", "Amount", "Unrealized Amount", "Unrealized Base", "Remaining Unrealized Amt.";
        }
        key(Key4; "Type", "Country/Region Code", "VAT Registration No.", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date")
        {
            SumIndexFields = "Base", "Additional-Currency Base";
        }
        key(Key5; "Document No.", "Posting Date")
        {
        }
        key(Key6; "Transaction No.")
        {
        }
        key(Key7; "Tax Jurisdiction Code", "Tax Group Used", "Tax Type", "Use Tax", "Posting Date")
        {
        }
        key(Key8; "Type", "Bill-to/Pay-to No.", "Transaction No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key9; "Type", "Closed", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Tax Jurisdiction Code", "Use Tax", "Posting Date")
        {
            SumIndexFields = "Base", "Amount", "Unrealized Amount", "Unrealized Base", "Additional-Currency Base", "Additional-Currency Amount", "Add.-Curr. Unrealized Amt.", "Add.-Curr. Unrealized Base", "Remaining Unrealized Amt.";
        }
        key(Key10; "Posting Date", "Type", "Closed", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Reversed")
        {
            SumIndexFields = "Base", "Amount", "Unrealized Amount", "Unrealized Base", "Additional-Currency Base", "Additional-Currency Amount", "Add.-Curr. Unrealized Amt.", "Add.-Curr. Unrealized Base", "Remaining Unrealized Amt.";
        }
        key(Key11; "Document Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Posting Date", "Document Type", "Document No.", "Posting Date")
        {
        }
    }


    var

        GeneralLedgerSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;

    /// <summary> 
    /// Description for GetCurrencyCode.
    /// </summary>
    /// <returns>Return variable "Code[10]".</returns>
    local procedure "GetCurrencyCode"(): Code[10]
    begin
        IF NOT GLSetupRead THEN BEGIN
            GeneralLedgerSetup.GET();
            GLSetupRead := TRUE;
        END;
        EXIT(GeneralLedgerSetup."Additional Reporting Currency");
    end;


}

