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
                    "NCT Branch Code" := '';
            end;


        }
        field(80002; "NCT Branch Code"; Code[5])
        {
            Caption = 'Branch Code';
            TableRelation = "NCT Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Sell-to Customer No."));
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "NCT Branch Code" <> '' then begin
                    if StrLen("NCT Branch Code") <> 5 then
                        Error('Branch Code must be 5 characters');
                    "NCT Head Office" := false;

                end;
                if ("NCT Branch Code" = '00000') OR ("NCT Branch Code" = '') then begin
                    "NCT Head Office" := TRUE;
                    "NCT Branch Code" := '';

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
                        "NCT Branch Code" := '';
                        "VAT Registration No." := VendCustBranch."Vat Registration No.";
                    end else
                        if VendCustBranch."Branch Code" <> '' then begin
                            "NCT Branch Code" := VendCustBranch."Branch Code";
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
            TableRelation = "No. Series".Code;
        }
        field(80009; "NCT Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
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
                "NCT Branch Code" := Cust."NCT Branch Code";
                if (NOT "NCT Head Office") AND ("NCT Branch Code" = '') then
                    "NCT Head Office" := true;
            end;
        }

    }

    trigger OnInsert()
    begin
        TestField("No.");
        "NCT Create By" := COPYSTR(UserId, 1, 50);
        "NCT Create DateTime" := CurrentDateTime;
        if "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then
            "Posting No." := "No.";
    end;
}