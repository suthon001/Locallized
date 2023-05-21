tableextension 80050 "ExtenPostedGenLines" extends "Posted Gen. Journal Line"
{
    fields
    {

        field(80001; "Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
        }
        field(80002; "Sales Receipt No."; Code[20])
        {
            Caption = 'Sales Receipt No.';
            DataClassification = CustomerContent;
        }
        field(80003; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80004; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80005; "Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;


        }
        field(80006; "Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80007; "Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor/Cutomer No.';
            DataClassification = CustomerContent;


        }
        field(80008; "Tax Invoice Name"; Text[150])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80009; "Description Line"; Text[150])
        {
            Caption = 'Description Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80010; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;


        }
        field(80011; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;


        }
        field(80012; "Description Voucher"; Text[250])
        {
            Caption = 'Description Voucher';
            DataClassification = CustomerContent;
        }
        field(80013; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80014; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'Product Posting Group';
            TableRelation = "WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80015; "WHT Name"; text[50])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(80016; "WHT Name 2"; text[100])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(80017; "WHT Address"; Text[50])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(80018; "WHT Address 2"; Text[100])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(80019; "WHT Post Code"; Code[10])
        {
            Caption = 'WHT Post Code';
            DataClassification = CustomerContent;
        }
        field(80020; "WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(80021; "WHT County"; Text[50])
        {
            Caption = 'WHT County';
            DataClassification = CustomerContent;
        }
        field(80022; "WHT Country Code"; Code[10])
        {
            Caption = 'WHT Country Code';
            DataClassification = CustomerContent;
        }
        field(80023; "WHT Registration No."; Text[20])
        {
            Caption = 'WHT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80024; "WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;

        }
        field(80025; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = CustomerContent;
        }
        field(80026; "WHT Revenue Type"; Code[10])
        {
            Caption = 'WHT Revenue Type';
            DataClassification = CustomerContent;
        }
        field(80027; "WHT Revenue Description"; Text[50])
        {
            Caption = 'WHT Revenue Description';
            DataClassification = CustomerContent;
        }
        field(80028; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(80029; "WHT Document No."; Code[30])
        {
            Caption = 'WHT Document No.';
            DataClassification = CustomerContent;
        }
        field(80030; "WHT Option"; Option)
        {
            Caption = 'WHT Option';
            OptionCaption = ' ,(1) หักภาษี ณ ที่จ่าย,(2) ออกภาษีให้ตลอดไป,(3) ออกภาษีให้ครั้งเดียว,(4) อื่นๆ';
            OptionMembers = " ","(1) หักภาษี ณ ที่จ่าย","(2) ออกภาษีให้ตลอดไป","(3) ออกภาษีให้ครั้งเดียว","(4) อื่นๆ";
            DataClassification = CustomerContent;
        }
        field(80031; "WHT No. Series"; Code[10])
        {
            Caption = 'WHT No. Series';
            DataClassification = CustomerContent;
        }
        field(80032; "WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(80033; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                BankAcc: Record "Bank Account";
            begin
                IF NOT BankAcc.GET("Bank Code") THEN
                    BankAcc.INIT;
                "Bank Name" := BankAcc.Name + ' ' + BankAcc."Name 2";
                "Bank Account No." := BankAcc."Bank Account No.";
                "Bank Branch No." := BankAcc."Bank Branch No.";
            end;

        }
        field(80034; "Bank Name"; Text[150])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;

        }
        field(80035; "Bank Account No."; text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80036; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;

        }
        field(80037; "Cheque No."; Text[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "External Document No." := "Cheque No.";
                "Cheque Date" := TODAY;
            end;

        }
        field(80038; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;

        }
        field(80039; "Pay Name"; Text[150])
        {
            Caption = 'Pay Name';
            DataClassification = CustomerContent;

        }

        field(80040; "WHT Vendor No."; Code[20])
        {
            Caption = 'WHT Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vendor: Record vendor;
            begin
                IF NOT Vendor.GET("WHT Vendor No.") THEN
                    Vendor.INIT;

                "VAT Registration No." := Vendor."VAT Registration No.";
                "WHT Name" := Vendor.Name;
                "WHT Name 2" := Vendor."Name 2";
                "WHT Address" := Vendor.Address;
                "WHT Address 2" := Vendor."Address 2";
                "WHT City" := Vendor.City;
                "WHT Post Code" := Vendor."Post Code";
                "WHT County" := Vendor.County;
                VALIDATE("WHT Business Posting Group", Vendor."WHT Business Posting Group");
                "WHT Registration No." := Vendor."VAT Registration No.";

            end;
        }
        field(80041; "Tax Invoice Address"; Code[150])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = CustomerContent;
        }
        field(80042; "Tax Invoice City"; text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = CustomerContent;
        }
        field(80043; "Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = CustomerContent;
        }
        field(80044; "Require Screen Detail"; Option)
        {
            Caption = 'Require Screen Detail';
            OptionMembers = " ",CHEQUE,VAT,WHT;
            OptionCaption = ' ,CHEQUE,VAT,WHT';
            DataClassification = CustomerContent;


        }
        field(80045; "Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
        }


        field(80046; "Cheque Name"; Text[100])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;

        }
        field(80047; "Journal Description"; Text[250])
        {

            Caption = 'Journal Description';
            DataClassification = CustomerContent;
        }
        field(80048; "WHT Cust/Vend No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(80049; "Template Source Type"; Enum "Gen. Journal Template Type")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Gen. Journal Template".Type where(Name = field("Journal Template Name")));
            Caption = 'Template Source Type';
        }
        field(80050; "Create By"; Code[30])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80051; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}