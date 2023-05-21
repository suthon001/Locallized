tableextension 80012 "ExtenSales Header" extends "Sales Header"
{
    fields
    {

        field(80000; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then begin
                    "Branch Code" := '';
                end;

            end;


        }
        field(80002; "Branch Code"; Code[5])
        {
            Caption = 'Tax Branch Code';
            TableRelation = "Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Sell-to Customer No."));
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

            trigger OnLookup()
            var
                VendCustBranch: Record "Customer & Vendor Branch";
                VendCustPage: Page "Cust. & Vendor BranchLists";
            begin
                clear(VendCustPage);
                VendCustBranch.reset;
                VendCustBranch.SetRange("Source Type", VendCustBranch."Source Type"::Customer);
                VendCustBranch.SetRange("Source No.", "Sell-to Customer No.");
                VendCustPage.Editable := false;
                VendCustPage.LookupMode := true;
                VendCustPage.SetTableView(VendCustBranch);
                if VendCustPage.RunModal() IN [Action::LookupOK, Action::OK] then begin
                    VendCustPage.GetRecord(VendCustBranch);
                    if VendCustBranch."Head Office" then begin
                        "Head Office" := true;
                        "Branch Code" := '';
                        "VAT Registration No." := VendCustBranch."Vat Registration No.";
                    end else begin
                        if VendCustBranch."Branch Code" <> '' then begin
                            "Branch Code" := VendCustBranch."Branch Code";
                            "Head Office" := false;
                            "VAT Registration No." := VendCustBranch."Vat Registration No.";
                        end;
                    end;
                end;
                clear(VendCustPage);

            end;

        }
        field(80003; "Ref. Tax Invoice Date"; Date)
        {
            Caption = 'Ref. Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80004; "Ref. Tax Invoice No."; Code[20])
        {
            Caption = 'Ref. Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80005; "Ref. Tax Invoice Amount"; Decimal)
        {
            Caption = 'Ref. Tax Invoice Amount';
            DataClassification = CustomerContent;
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
        field(80008; "Make Order No. Series"; Code[20])
        {
            Caption = 'Make Order No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(80009; "Sales Order No."; Code[20])
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
                    Cust.init;

                "Head Office" := Cust."Head Office";
                "Branch Code" := Cust."Branch Code";
                if (NOT "Head Office") AND ("Branch Code" = '') then
                    "Head Office" := true;
            end;
        }

    }

    trigger OnInsert()
    begin
        TestField("No.");
        "Create By" := UserId;
        "Create DateTime" := CurrentDateTime;
        if "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then
            "Posting No." := "No.";
    end;
}