/// <summary>
/// TableExtension NCT ExtenCustomer (ID 80000) extends Record Customer.
/// </summary>
tableextension 80000 "NCT ExtenCustomer" extends Customer
{
    fields
    {
        field(80000; "NCT Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "NCT Head Office" then
                    "NCT Branch Code" := '';

            end;

        }
        field(80001; "NCT Branch Code"; code[5])
        {
            Caption = 'Branch Code';
            TableRelation = "NCT Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("No."));
            ValidateTableRelation = true;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TempSendtoUpdate: Text[50];
                CustVendBarch: Record "NCT Customer & Vendor Branch";
            begin

                CustVendBarch.reset();
                CustVendBarch.SetRange("Source Type", CustVendBarch."Source Type"::Customer);
                CustVendBarch.SetRange("Source No.", "No.");
                CustVendBarch.SetRange("Branch Code", "NCT Branch Code");
                if CustVendBarch.FindFirst() then begin
                    "VAT Registration No." := CustVendBarch."Vat Registration No.";
                    if CustVendBarch."Head Office" then
                        "NCT Branch Code" := '00000';
                end;

                if "NCT Branch Code" <> '' then begin
                    if StrLen("NCT Branch Code") < 5 then
                        Error('Branch Code must be 5 characters');
                    "NCT Head Office" := false;
                end;
                if "NCT Branch Code" = '00000' then begin
                    "NCT Head Office" := TRUE;
                    "NCT Branch Code" := '';
                end;
                UpdateVendorCustBranch(4, TempSendtoUpdate, TRUE);
            end;


        }
        field(80002; "WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(5, Name + ' ' + "Name 2", false);
            end;
        }
        modify("Name 2")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(5, Name + ' ' + "Name 2", false);
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(6, Address + ' ' + "Address 2", false);
            end;
        }
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(6, Address + ' ' + "Address 2", false);
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(16, City, false);
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(17, "Post Code", false);
            end;
        }

        modify("VAT Registration No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(19, "VAT Registration No.", false);
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(3, '00000', TRUE);
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(21, '00000', TRUE);
            end;
        }
        modify("Fax No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(22, '00000', TRUE);
            end;
        }

    }
    local procedure UpdateVendorCustBranch(FiledsNo: Integer; WHTResult: Text[250]; FieldsBranch: Boolean)
    var
        VendorCustBranch: Record "NCT Customer & Vendor Branch";
        VenCust: RecordRef;
        MyFieldRef: FieldRef;
        tempHeadOffice: Boolean;
    begin

        CLEAR(tempHeadOffice);

        if FieldsBranch then
            tempHeadOffice := WHTResult = '00000';

        if (xRec."No." <> '') AND (xRec."No." <> "No.") then begin
            VendorCustBranch.reset();
            VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Customer);
            VendorCustBranch.SetRange("Source No.", xrec."No.");
            VendorCustBranch.DeleteAll();

            VendorCustBranch.init();
            VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Customer;
            VendorCustBranch."Source No." := "No.";
            VendorCustBranch."Head Office" := TRUE;

            VendorCustBranch.insert();
            VenCust.Get(VendorCustBranch.RecordId);
            MyFieldRef := VenCust.Field(FiledsNo);
            if FiledsNo = 3 then
                MyFieldRef.Value := tempHeadOffice
            else
                MyFieldRef.Value := WHTResult;
            VenCust.Modify();
        end else begin
            VendorCustBranch.reset();
            VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Customer);
            VendorCustBranch.SetRange("Source No.", "No.");
            VendorCustBranch.SetRange("Head Office", TRUE);
            if VendorCustBranch.FindFirst() then begin
                VenCust.Get(VendorCustBranch.RecordId);
                MyFieldRef := VenCust.Field(FiledsNo);
                if FiledsNo = 3 then
                    MyFieldRef.Value := tempHeadOffice
                else
                    MyFieldRef.Value := WHTResult;
                VenCust.Modify();
            end else begin
                VendorCustBranch.init();
                VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Customer;
                VendorCustBranch."Source No." := "No.";
                VendorCustBranch."Head Office" := TRUE;

                VendorCustBranch.insert();
                VenCust.Get(VendorCustBranch.RecordId);
                MyFieldRef := VenCust.Field(FiledsNo);
                if FiledsNo = 3 then
                    MyFieldRef.Value := tempHeadOffice
                else
                    MyFieldRef.Value := WHTResult;
                VenCust.Modify();
            end;
        END;
    end;

    trigger OnInsert()
    begin
        "NCT Head Office" := true;
    end;

    trigger OnDelete()
    var
        VendorCustBranch: Record "NCT Customer & Vendor Branch";
    begin
        VendorCustBranch.reset();
        VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Customer);
        VendorCustBranch.SetRange("Source No.", "No.");
        VendorCustBranch.DeleteAll();
    end;
}