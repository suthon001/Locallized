/// <summary>
/// TableExtension NCT ExtenSales Header (ID 80012) extends Record Sales Header.
/// </summary>
tableextension 80012 "NCT ExtenSales Header" extends "Sales Header"
{
    fields
    {

        field(80000; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "NCT Head Office" then
                    "NCT VAT Branch Code" := '';
            end;


        }
        field(80002; "NCT VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            TableRelation = "NCT Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Sell-to Customer No."));
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

            trigger OnLookup()
            var
                VendCustBranch: Record "NCT Customer & Vendor Branch";
                VendCustPage: Page "NCT Cust. & Vendor BranchLists";
            begin
                clear(VendCustPage);
                VendCustBranch.reset();
                VendCustBranch.SetRange("Source Type", VendCustBranch."Source Type"::Customer);
                VendCustBranch.SetRange("Source No.", "Sell-to Customer No.");
                VendCustPage.Editable := false;
                VendCustPage.LookupMode := true;
                VendCustPage.SetTableView(VendCustBranch);
                if VendCustPage.RunModal() IN [Action::LookupOK, Action::OK] then begin
                    VendCustPage.GetRecord(VendCustBranch);
                    if VendCustBranch."Head Office" then begin
                        "NCT Head Office" := true;
                        "NCT VAT Branch Code" := '';
                        "VAT Registration No." := VendCustBranch."Vat Registration No.";
                    end else
                        if VendCustBranch."VAT Branch Code" <> '' then begin
                            "NCT VAT Branch Code" := VendCustBranch."VAT Branch Code";
                            "NCT Head Office" := false;
                            "VAT Registration No." := VendCustBranch."Vat Registration No.";
                        end;
                end;
                clear(VendCustPage);

            end;

        }
        field(80003; "NCT Ref. Tax Invoice Date"; Date)
        {
            Caption = 'Ref. Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT Ref. Tax Invoice No."; Code[20])
        {
            Caption = 'Ref. Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT Ref. Tax Invoice Amount"; Decimal)
        {
            Caption = 'Ref. Tax Invoice Amount';
            DataClassification = CustomerContent;
        }

        field(80006; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80008; "NCT Make Order No. Series"; Code[20])
        {
            Caption = 'Make Order No. Series';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                SalesSetup: Record "Sales & Receivables Setup";
                NoseriesMgt: Codeunit "No. Series";
                newNoseries: code[20];
            begin
                SalesSetup.GET();
                SalesSetup.TestField("Order Nos.");
                if NoseriesMgt.LookupRelatedNoSeries(SalesSetup."Order Nos.", "No. Series", newNoseries) then
                    "NCT Make Order No. Series" := newNoseries;
            end;
        }
        field(80009; "NCT Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = SystemMetadata;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                if not Cust.get("Sell-to Customer No.") then
                    Cust.init();

                "NCT Head Office" := Cust."NCT Head Office";
                "NCT VAT Branch Code" := Cust."NCT VAT Branch Code";
                "NCT WHT Business Posting Group" := Cust."NCT WHT Business Posting Group";
                if (NOT "NCT Head Office") AND ("NCT VAT Branch Code" = '') then
                    "NCT Head Office" := true;
            end;
        }

    }

    trigger OnInsert()
    begin
        TestField("No.");
        "NCT Create By" := COPYSTR(UserId, 1, 50);
        "NCT Create DateTime" := CurrentDateTime;
        if rec."Posting Date" = 0D then
            rec."Posting Date" := Today();
        if rec."Document Date" = 0D then
            rec."Document Date" := Today();
        if "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
            "Posting No." := "No.";
            "Posting No. Series" := "No. Series";
        end;

        if "Document Type" = "Document Type"::"Return Order" then begin
            "Return Receipt No." := "No.";
            "Return Receipt No. Series" := "No. Series";
        end;
    end;
}