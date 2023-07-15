/// <summary>
/// TableExtension NCT ExtenPurchase Header (ID 80010) extends Record Purchase Header.
/// </summary>
tableextension 80010 "NCT ExtenPurchase Header" extends "Purchase Header"
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
            TableRelation = "NCT Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Buy-from Vendor No."));
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
                VendCustBranch.SetRange("Source Type", VendCustBranch."Source Type"::Vendor);
                VendCustBranch.SetRange("Source No.", "Buy-from Vendor No.");
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

        field(80003; "NCT Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "NCT Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "NCT Purchase Order No."; Code[30])
        {
            Caption = 'Purchase Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "NCT Make PO No.Series No."; Code[20])
        {
            // TableRelation = "No. Series".Code;
            Caption = 'Make PO No.Series No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var

                PayableSetup: Record "Purchases & Payables Setup";
                NoseriesMgt: Codeunit NoSeriesManagement;
                newNoseries: code[20];


            begin
                PayableSetup.GET();
                PayableSetup.TestField("Order Nos.");
                if NoseriesMgt.SelectSeries(PayableSetup."Order Nos.", "No. Series", newNoseries) then
                    "NCT Make PO No.Series No." := newNoseries;
            end;
        }



        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
            begin
                if not Vend.get("Buy-from Vendor No.") then
                    Vend.init();

                "NCT Head Office" := Vend."NCT Head Office";
                "NCT Branch Code" := Vend."NCT Branch Code";
                if (NOT "NCT Head Office") AND ("NCT Branch Code" = '') then
                    "NCT Head Office" := true;
            end;
        }
    }
    trigger OnInsert()
    begin
        TestField("No.");
        "NCT Create By" := COPYSTR(UserId(), 1, 50);
        "NCT Create DateTime" := CurrentDateTime;
        if "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then
            "Posting No." := "No.";
    end;
}