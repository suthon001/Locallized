/// <summary>
/// TableExtension ExtenGenJournal Lines (ID 80014) extends Record Gen. Journal Line.
/// </summary>
tableextension 80014 "ExtenGenJournal Lines" extends "Gen. Journal Line"
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
            trigger OnValidate()
            begin
                "Tax Invoice Amount" := ROUND("Tax Invoice Base" * "VAT %" / 100, 0.01);
                if "Tax Invoice Amount" = 0 then
                    "Tax Invoice Amount" := "Amount (LCY)";
            end;

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
            TableRelation = IF ("Gen. Posting Type" = filter(Purchase)) Vendor."no."
            else
            IF ("Gen. Posting Type" = filter(Sale)) Customer."No."
            else
            IF ("Gen. Posting Type" = filter(" "), "Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";


            trigger OnValidate()
            var
                Vendor: Record Vendor;
                Cust: Record Customer;
            begin
                IF "Gen. Posting Type" = "Gen. Posting Type"::Sale then begin
                    IF not Cust.GET("Tax Vendor No.") THEN
                        Cust.INIT();
                    "Tax Invoice Name" := Cust.Name;
                    "Tax Invoice Name 2" := Cust."Name 2";
                    "Head Office" := Cust."Head Office";
                    "Branch Code" := Cust."Branch Code";
                    if (NOT "Head Office") AND ("Branch Code" = '') then
                        "Head Office" := true;
                    "Tax Invoice Address" := Cust.Address;
                    "Tax Invoice Address 2" := Cust."Address 2";
                    "VAT Registration No." := Cust."VAT Registration No.";
                end else
                    IF "Gen. Posting Type" = "Gen. Posting Type"::Purchase then begin
                        IF NOT Vendor.GET("Tax Vendor No.") THEN
                            Vendor.INIT();
                        "Tax Invoice Name" := Vendor.Name;
                        "Tax Invoice Name 2" := Vendor."Name 2";
                        "Head Office" := Vendor."Head Office";
                        "Branch Code" := Vendor."Branch Code";
                        if (NOT "Head Office") AND ("Branch Code" = '') then
                            "Head Office" := true;
                        "Tax Invoice Address" := Vendor.Address;
                        "Tax Invoice Address 2" := Vendor."Address 2";
                        "VAT Registration No." := Vendor."VAT Registration No.";
                    end;


            end;

        }
        field(80008; "Tax Invoice Name"; Text[100])
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
            trigger OnValidate()
            begin
                if "Head Office" then
                    "Branch Code" := '';

            end;

        }
        field(80011; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "Branch Code" <> '' then begin
                    if StrLen("Branch Code") <> 5 then
                        Error('Branch Code must be 5 characters');
                    "Head Office" := false;

                end;
                if ("Branch Code" = '00000') OR ("Branch Code" = '') then begin
                    "Head Office" := TRUE;
                    "Branch Code" := '';

                end;
            end;

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
            trigger OnValidate()
            var
                WHTBusinessPostingGroup: Record "WHT Business Posting Group";
            begin
                IF NOT WHTBusinessPostingGroup.GET("WHT Business Posting Group") THEN
                    WHTBusinessPostingGroup.init();
                "WHT No. Series" := WHTBusinessPostingGroup."WHT Certificate No. Series";
                CalWhtAmount();
            end;
        }
        field(80014; "WHT Product Posting Group"; Code[10])
        {
            Caption = 'Product Posting Group';
            TableRelation = "WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;
        }
        field(80015; "WHT Name"; text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(80016; "WHT Name 2"; text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(80017; "WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(80018; "WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(80019; "WHT Post Code"; Code[20])
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
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;
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
        field(80030; "WHT Option"; Enum "WHT Option")
        {
            Caption = 'WHT Option';
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
                    BankAcc.INIT();
                "Bank Name" := BankAcc.Name;
                "Bank Account No." := COPYSTR(BankAcc."Bank Account No.", 1, 20);
                "Bank Branch No." := BankAcc."Bank Branch No.";
            end;

        }
        field(80034; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;

        }
        field(80035; "Bank Account No."; text[20])
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
        field(80039; "Pay Name"; Text[100])
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
                    Vendor.INIT();
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
                CalWhtAmount();
            end;
        }
        field(80041; "Tax Invoice Address"; Code[100])
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
        field(80044; "Require Screen Detail"; Enum "Require Screen Detail")
        {
            Caption = 'Require Screen Detail';
            DataClassification = CustomerContent;


        }
        field(80045; "Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";
            trigger OnValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                if ("Template Source Type" = "Template Source Type"::"Cash Receipts") then begin
                    IF not Customer.GET("Customer/Vendor No.") THEN
                        Customer.init();
                    "Pay Name" := Customer.Name;
                end else begin
                    IF not Vendor.GET("Customer/Vendor No.") THEN
                        Vendor.init();
                    "Pay Name" := Vendor.Name;
                end;


            end;

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
        field(80049; "Tax Invoice Name 2"; text[50])
        {
            DataClassification = CustomerContent;
        }

        field(80050; "Create By"; Code[50])
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
        field(80052; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80053; "Tax Invoice Address 2"; text[50])
        {
            DataClassification = CustomerContent;
        }

        field(80054; "Template Source Type"; Enum "Gen. Journal Template Type")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Gen. Journal Template".Type where(Name = field("Journal Template Name")));
            Caption = 'Template Source Type';
        }

        modify("External Document No.")
        {
            trigger OnAfterValidate()
            begin
                if "Account Type" = "Account Type"::"Bank Account" then
                    "Cheque No." := "External Document No."
                else
                    "Cheque No." := '';
            end;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                GLAccount: Record "G/L Account";
                BankAccount: Record "Bank Account";
                Cust: Record Customer;
                Vend: record Vendor;
            begin
                if not GLAccount.GET("Account No.") then
                    GLAccount.init();

                if not BankAccount.GET("Account No.") then
                    BankAccount.init();
                "Bank Name" := BankAccount.Name;
                "Bank Branch No." := BankAccount."Bank Branch No.";
                "Bank Account No." := COPYSTR(BankAccount."Bank Account No.", 1, 20);

                if "Account Type" = "Account Type"::Customer then begin
                    if not Cust.GET("Account No.") then
                        Cust.init();
                    "Head Office" := Cust."Head Office";
                    "Branch Code" := Cust."Branch Code";
                    "VAT Registration No." := Cust."VAT Registration No.";
                end;
                if "Account Type" = "Account Type"::Vendor then begin
                    if not Vend.GET("Account No.") then
                        Vend.init();
                    "Head Office" := Vend."Head Office";
                    "Branch Code" := Vend."Branch Code";
                    "VAT Registration No." := Vend."VAT Registration No.";
                end;

            end;
        }
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin
                if xRec."Account Type" <> "Account Type" then begin
                    "Require Screen Detail" := "Require Screen Detail"::" ";
                    "Head Office" := false;
                    "Branch Code" := '';
                end;
            end;
        }
    }
    trigger OnInsert()
    begin
        "Create By" := COPYSTR(USERID, 1, 50);
        "Create DateTime" := CurrentDateTime;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldGenJnlLine">Record "Gen. Journal Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure "AssistEdit"(OldGenJnlLine: Record "Gen. Journal Line"): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // WITH GenJnlLine DO BEGIN
        GenJnlLine.COPY(Rec);
        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        GenJnlBatch.TESTFIELD("Document No. Series");
        IF NoSeriesMgt.SelectSeries(GenJnlBatch."Document No. Series", OldGenJnlLine."Document No. Series",
            GenJnlLine."Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(GenJnlLine."Document No.");
            Rec := GenJnlLine;
            EXIT(TRUE);
        END;
        //  END;
    end;

    local procedure CalWhtAmount()
    var
        WHTPostingSetup: Record "WHT Posting Setup";

    begin
        IF WHTPostingSetup.GET("WHT Business Posting Group", "WHT Product Posting Group") THEN BEGIN
            CalcFields("Template Source Type");
            "WHT %" := WHTPostingSetup."WHT %";
            "WHT Amount" := ROUND(("WHT Base") * (WHTPostingSetup."WHT %" / 100), 0.01);
            if "Template Source Type" = "Template Source Type"::Payments THEN
                VALIDATE(Amount, "WHT Amount" * -1)
            else
                if "Template Source Type" = "Template Source Type"::"Cash Receipts" THEN
                    Validate(Amount, Abs("WHT Amount"));
        END
        ELSE BEGIN
            "WHT %" := 0;
            "WHT Amount" := 0;
            VALIDATE(Amount, 0);
        END;
    end;

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        genJournalLine: Record "Gen. Journal Line";
    begin
        genJournalLine.reset();
        genJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        genJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        genJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if genJournalLine.FindLast() then
            exit(genJournalLine."Line No." + 10000);
        exit(10000);
    end;
}