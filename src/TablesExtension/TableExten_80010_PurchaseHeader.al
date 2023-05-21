tableextension 80010 "ExtenPurchase Header" extends "Purchase Header"
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
            TableRelation = "Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Buy-from Vendor No."));
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
                VendCustBranch.SetRange("Source Type", VendCustBranch."Source Type"::Vendor);
                VendCustBranch.SetRange("Source No.", "Buy-from Vendor No.");
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

        field(80003; "Create By"; Code[30])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "Purchase Order No."; Code[30])
        {
            Caption = 'Purchase Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "Make PO No.Series No."; Code[20])
        {
            // TableRelation = "No. Series".Code;
            Caption = 'Make PO No.Series No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                Noseries: Record "No. Series";
                PayableSetup: Record "Purchases & Payables Setup";
                NoseriesMgt: Codeunit NoSeriesManagement;
                OldNoseries, newNoseries : Code[30];


            begin
                PayableSetup.GET;
                PayableSetup.TestField("Order Nos.");
                if NoseriesMgt.SelectSeries(PayableSetup."Order Nos.", "No. Series", newNoseries) then
                    "Make PO No.Series No." := newNoseries;
            end;
        }



        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
            begin
                if not Vend.get("Buy-from Vendor No.") then
                    Vend.init;

                "Head Office" := Vend."Head Office";
                "Branch Code" := Vend."Branch Code";
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