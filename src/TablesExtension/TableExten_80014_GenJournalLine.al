/// <summary>
/// TableExtension NCT GenJournal Lines (ID 80014) extends Record Gen. Journal Line.
/// </summary>
tableextension 80014 "NCT GenJournal Lines" extends "Gen. Journal Line"
{
    fields
    {
        field(80001; "NCT Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
        }
        field(80003; "NCT Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "NCT Tax Invoice Amount" := ROUND("NCT Tax Invoice Base" * "VAT %" / 100, 0.01);
                if "NCT Tax Invoice Amount" = 0 then
                    "NCT Tax Invoice Amount" := "Amount (LCY)";
            end;

        }
        field(80006; "NCT Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80007; "NCT Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor/Cutomer No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Gen. Posting Type" = filter(Purchase)) Vendor."no."
            else
            IF ("Gen. Posting Type" = filter(Sale)) Customer."No."
            else
            IF ("Gen. Posting Type" = filter(" "), "NCT Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";


            trigger OnValidate()
            var
                Vendor: Record Vendor;
                Cust: Record Customer;
            begin
                IF "Gen. Posting Type" = "Gen. Posting Type"::Sale then begin
                    IF not Cust.GET("NCT Tax Vendor No.") THEN
                        Cust.INIT();
                    "NCT Tax Invoice Name" := Cust.Name;
                    "NCT Tax Invoice Name 2" := Cust."Name 2";
                    "NCT Head Office" := Cust."NCT Head Office";
                    "NCT VAT Branch Code" := Cust."NCT VAT Branch Code";
                    if (NOT "NCT Head Office") AND ("NCT VAT Branch Code" = '') then
                        "NCT Head Office" := true;
                    "NCT Tax Invoice Address" := Cust.Address;
                    "NCT Tax Invoice Address 2" := Cust."Address 2";
                    "VAT Registration No." := Cust."VAT Registration No.";
                end else
                    IF "Gen. Posting Type" = "Gen. Posting Type"::Purchase then begin
                        IF NOT Vendor.GET("NCT Tax Vendor No.") THEN
                            Vendor.INIT();
                        "NCT Tax Invoice Name" := Vendor.Name;
                        "NCT Tax Invoice Name 2" := Vendor."Name 2";
                        "NCT Head Office" := Vendor."NCT Head Office";
                        "NCT VAT Branch Code" := Vendor."NCT VAT Branch Code";
                        if (NOT "NCT Head Office") AND ("NCT VAT Branch Code" = '') then
                            "NCT Head Office" := true;
                        "NCT Tax Invoice Address" := Vendor.Address;
                        "NCT Tax Invoice Address 2" := Vendor."Address 2";
                        "VAT Registration No." := Vendor."VAT Registration No.";
                    end;


            end;

        }
        field(80008; "NCT Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }

        field(80010; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "NCT Head Office" then
                    "NCT VAT Branch Code" := '';

            end;

        }
        field(80011; "NCT VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "NCT VAT Branch Code" <> '' then begin
                    if StrLen("NCT VAT Branch Code") <> 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "NCT Head Office" := false;

                end;
                if ("NCT VAT Branch Code" = '00000') OR ("NCT VAT Branch Code" = '') then begin
                    "NCT Head Office" := TRUE;
                    "NCT VAT Branch Code" := '';

                end;
            end;

        }
        field(80012; "NCT Description Voucher"; Text[250])
        {
            Caption = 'Description Voucher';
            DataClassification = CustomerContent;
        }
        field(80013; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                WHTBusinessPostingGroup: Record "NCT WHT Business Posting Group";
            begin
                IF NOT WHTBusinessPostingGroup.GET("NCT WHT Business Posting Group") THEN
                    WHTBusinessPostingGroup.init();
                "NCT WHT No. Series" := WHTBusinessPostingGroup."WHT Certificate No. Series";
                CalWhtAmount();
            end;
        }
        field(80014; "NCT WHT Product Posting Group"; Code[10])
        {
            Caption = 'Product Posting Group';
            TableRelation = "NCT WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;
        }
        field(80015; "NCT WHT Name"; text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(80016; "NCT WHT Name 2"; text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(80017; "NCT WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(80018; "NCT WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(80019; "NCT WHT Post Code"; Code[20])
        {
            Caption = 'WHT Post Code';
            DataClassification = CustomerContent;
        }
        field(80020; "NCT WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(80021; "NCT WHT County"; Text[50])
        {
            Caption = 'WHT County';
            DataClassification = CustomerContent;
        }
        field(80022; "NCT WHT Country Code"; Code[10])
        {
            Caption = 'WHT Country Code';
            DataClassification = CustomerContent;
        }
        field(80023; "NCT WHT Registration No."; Text[20])
        {
            Caption = 'WHT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80024; "NCT WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;
        }
        field(80025; "NCT WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = CustomerContent;
        }
        field(80026; "NCT WHT Revenue Type"; Code[10])
        {
            Caption = 'WHT Revenue Type';
            DataClassification = CustomerContent;
        }
        field(80027; "NCT WHT Revenue Description"; Text[50])
        {
            Caption = 'WHT Revenue Description';
            DataClassification = CustomerContent;
        }
        field(80028; "NCT WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(80029; "NCT WHT Document No."; Code[30])
        {
            Caption = 'WHT Document No.';
            DataClassification = CustomerContent;
        }
        field(80030; "NCT WHT Option"; Enum "NCT WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80031; "NCT WHT No. Series"; Code[20])
        {
            Caption = 'WHT No. Series';
            DataClassification = CustomerContent;
        }
        field(80032; "NCT WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(80033; "NCT Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";
            trigger OnValidate()
            var
                BankAcc: Record "Bank Account";
            begin
                IF NOT BankAcc.GET("NCT Bank Code") THEN
                    BankAcc.INIT();
                "NCT Bank Name" := BankAcc.Name;
                "NCT Bank Account No." := COPYSTR(BankAcc."Bank Account No.", 1, 20);
                "NCT Bank Branch No." := BankAcc."Bank Branch No.";
            end;

        }
        field(80034; "NCT Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;

        }
        field(80035; "NCT Bank Account No."; text[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80036; "NCT Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;

        }
        field(80037; "NCT Cheque No."; Text[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                IsHandle: Boolean;
            begin
                IsHandle := false;
                "NCT OnbeforUpdateChequeToExternal"(IsHandle);
                if not IsHandle then begin
                    "External Document No." := "NCT Cheque No.";
                    if "NCT Cheque No." <> '' then
                        "NCT Cheque Date" := "Document Date"
                    else
                        "NCT Cheque Date" := 0D;
                end;
            end;

        }
        field(80038; "NCT Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;

        }
        field(80039; "NCT Pay Name"; Text[100])
        {
            Caption = 'Pay Name';
            DataClassification = CustomerContent;
        }

        field(80040; "NCT WHT Vendor No."; Code[20])
        {
            Caption = 'WHT Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vendor: Record vendor;
            begin
                IF NOT Vendor.GET("NCT WHT Vendor No.") THEN
                    Vendor.INIT();
                "VAT Registration No." := Vendor."VAT Registration No.";
                "NCT WHT Name" := Vendor.Name;
                "NCT WHT Name 2" := Vendor."Name 2";
                "NCT WHT Address" := Vendor.Address;
                "NCT WHT Address 2" := Vendor."Address 2";
                "NCT WHT City" := Vendor.City;
                "NCT WHT Post Code" := Vendor."Post Code";
                "NCT WHT County" := Vendor.County;
                VALIDATE("NCT WHT Business Posting Group", Vendor."NCT WHT Business Posting Group");
                "NCT WHT Registration No." := Vendor."VAT Registration No.";
                "NCT OnAfterInitWHTVendorNo"(rec, Vendor);
                CalWhtAmount();
            end;
        }
        field(80041; "NCT Tax Invoice Address"; Code[100])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = CustomerContent;
        }
        field(80042; "NCT Tax Invoice City"; text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = CustomerContent;
        }
        field(80043; "NCT Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = CustomerContent;
        }
        field(80044; "NCT Require Screen Detail"; Enum "NCT Require Screen Detail")
        {
            Caption = 'Require Screen Detail';
            DataClassification = CustomerContent;



        }
        field(80045; "NCT Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("NCT Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";
            trigger OnValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                if ("NCT Template Source Type" = "NCT Template Source Type"::"Cash Receipts") then begin
                    IF not Customer.GET("NCT Customer/Vendor No.") THEN
                        Customer.init();
                    "NCT Pay Name" := Customer.Name;
                end else begin
                    IF not Vendor.GET("NCT Customer/Vendor No.") THEN
                        Vendor.init();
                    "NCT Pay Name" := Vendor.Name;
                end;


            end;

        }


        field(80046; "NCT Cheque Name"; Text[100])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;

        }
        field(80047; "NCT Journal Description"; Text[250])
        {

            Caption = 'Journal Description';
            DataClassification = CustomerContent;
        }
        field(80048; "NCT WHT Cust/Vend No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Cust/Vend No.';
        }
        field(80049; "NCT Tax Invoice Name 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Name 2';
        }

        field(80050; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80051; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80052; "NCT Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80053; "NCT Tax Invoice Address 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Address 2';
        }

        field(80054; "NCT Template Source Type"; Enum "Gen. Journal Template Type")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Gen. Journal Template".Type where(Name = field("Journal Template Name")));
            Caption = 'Template Source Type';
        }
        field(80055; "NCT Ref. Billing & Receipt No."; code[30])
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Ref. Billing & Receipt No.';

        }

        modify("External Document No.")
        {
            trigger OnAfterValidate()
            var
                IsHandle: Boolean;
            begin
                IsHandle := false;
                "NCT OnbeforUpdateExternalToCheque"(IsHandle);
                if not IsHandle then
                    if "Account Type" = "Account Type"::"Bank Account" then begin
                        "NCT Cheque No." := rec."External Document No.";
                        "NCT Cheque Date" := rec."Document Date";
                    end else begin
                        "NCT Cheque No." := '';
                        "NCT Cheque Date" := 0D;
                    end;

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
                "NCT Bank Name" := BankAccount.Name;
                "NCT Bank Branch No." := BankAccount."Bank Branch No.";
                "NCT Bank Account No." := COPYSTR(BankAccount."Bank Account No.", 1, 20);

                if "Account Type" = "Account Type"::Customer then begin
                    if not Cust.GET("Account No.") then
                        Cust.init();
                    "NCT Head Office" := Cust."NCT Head Office";
                    "NCT VAT Branch Code" := Cust."NCT VAT Branch Code";
                    "VAT Registration No." := Cust."VAT Registration No.";
                end;
                if "Account Type" = "Account Type"::Vendor then begin
                    if not Vend.GET("Account No.") then
                        Vend.init();
                    "NCT Head Office" := Vend."NCT Head Office";
                    "NCT VAT Branch Code" := Vend."NCT VAT Branch Code";
                    "VAT Registration No." := Vend."VAT Registration No.";
                end;
                rec."NCT Journal Description" := rec.Description;
            end;
        }
        modify(Description)
        {
            trigger OnAfterValidate()
            begin
                rec."NCT Journal Description" := rec.Description;
            end;
        }
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin
                if xRec."Account Type" <> "Account Type" then begin
                    "NCT Require Screen Detail" := "NCT Require Screen Detail"::" ";
                    "NCT Head Office" := false;
                    "NCT VAT Branch Code" := '';
                end;
            end;
        }
    }
    trigger OnInsert()
    begin
        "NCT Create By" := COPYSTR(USERID, 1, 50);
        "NCT Create DateTime" := CurrentDateTime;
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
        GenJnlBatch.TESTFIELD("NCT Document No. Series");
        IF NoSeriesMgt.SelectSeries(GenJnlBatch."NCT Document No. Series", OldGenJnlLine."NCT Document No. Series",
            GenJnlLine."NCT Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(GenJnlLine."Document No.");
            Rec := GenJnlLine;
            EXIT(TRUE);
        END;
        //  END;
    end;

    local procedure CalWhtAmount()
    var
        WHTPostingSetup: Record "NCT WHT Posting Setup";

    begin
        IF WHTPostingSetup.GET("NCT WHT Business Posting Group", "NCT WHT Product Posting Group") THEN BEGIN
            CalcFields("NCT Template Source Type");
            "NCT WHT %" := WHTPostingSetup."WHT %";
            "NCT WHT Amount" := ROUND(("NCT WHT Base") * (WHTPostingSetup."WHT %" / 100), 0.01);
            if "NCT Template Source Type" = "NCT Template Source Type"::Payments THEN
                VALIDATE(Amount, "NCT WHT Amount" * -1)
            else
                if "NCT Template Source Type" = "NCT Template Source Type"::"Cash Receipts" THEN
                    Validate(Amount, Abs("NCT WHT Amount"));
        END
        ELSE BEGIN
            "NCT WHT %" := 0;
            "NCT WHT Amount" := 0;
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

    [IntegrationEvent(false, false)]
    local procedure "NCT OnbeforUpdateExternalToCheque"(var IsHandle: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT OnbeforUpdateChequeToExternal"(var IsHandle: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "NCT OnAfterInitWHTVendorNo"(var GenLine: Record "Gen. Journal Line"; Vendor: Record Vendor)
    begin
    end;
}