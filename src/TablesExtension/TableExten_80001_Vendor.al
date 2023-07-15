/// <summary>
/// TableExtension NCT ExtenVendor (ID 80001) extends Record Vendor.
/// </summary>
tableextension 80001 "NCT ExtenVendor" extends Vendor
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
            TableRelation = "NCT Customer & Vendor Branch"."Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("No."));
            ValidateTableRelation = true;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var

                CustVendBarch: Record "NCT Customer & Vendor Branch";
            begin
                CustVendBarch.reset();
                CustVendBarch.SetRange("Source Type", CustVendBarch."Source Type"::Vendor);
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
                    UpdateVendorCustBranch(4, "NCT Branch Code", false);

                end;
                if "NCT Branch Code" = '00000' then begin
                    "NCT Head Office" := TRUE;
                    "NCT Branch Code" := '';
                end;

            end;
        }
        field(80002; "NCT WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "NCT WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80003; "NCT WHT Title Name"; Enum "NCT Title Document Name")
        {
            Caption = 'คำนำหน้า';
            DataClassification = CustomerContent;
        }
        field(80004; "NCT WHT Building"; Text[100])
        {
            Caption = 'ชื่ออาคาร/หมู่บ้าน';
            DataClassification = CustomerContent;
        }
        field(80005; "NCT WHT Alley/Lane"; Text[100])
        {
            Caption = 'ตรอก/ซอย';
            DataClassification = CustomerContent;
        }
        field(80006; "NCT WHT Sub-district"; Text[100])
        {
            Caption = 'ตำบล/แขวง';
            DataClassification = CustomerContent;
        }
        field(80007; "NCT WHT District"; Text[100])
        {
            Caption = 'อำเภอ/เขต';
            DataClassification = CustomerContent;
        }
        field(80008; "NCT WHT Floor"; Text[10])
        {
            Caption = 'ชั้น';
            DataClassification = CustomerContent;
        }
        field(80009; "NCT WHT House No."; Text[50])
        {
            Caption = 'เลขที่ห้อง';
            DataClassification = CustomerContent;
        }
        field(80010; "NCT WHT Village No."; Text[15])
        {
            Caption = 'หมู่ที่';
            DataClassification = CustomerContent;
        }
        field(80011; "NCT WHT Street"; Text[50])
        {
            Caption = 'ถนน';
            DataClassification = CustomerContent;
        }
        field(80012; "NCT WHT Province"; Text[50])
        {
            Caption = 'จังหวัด';
            DataClassification = CustomerContent;
        }
        field(80013; "NCT WHT Post Code"; code[20])
        {
            Caption = 'รหัสไปรษณีย์';
            DataClassification = CustomerContent;
            TableRelation = "Post Code".Code;
            trigger OnValidate()
            var
                ltPostCode: Record "Post Code";
            begin
                ltPostCode.reset();
                ltPostCode.SetRange(code, rec."NCT WHT Post Code");
                if ltPostCode.FindFirst() then
                    rec."NCT WHT Province" := ltPostCode.City;
            end;
        }
        field(80014; "NCT WHT No."; code[20])
        {
            Caption = 'เลขที่';
            DataClassification = CustomerContent;
        }
        field(80015; "NCT WHT Name"; text[100])
        {
            Caption = 'ชื่อ';
            DataClassification = CustomerContent;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(5, Name, false);
                rec."NCT WHT Name" := rec.Name;
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(6, Address, false);
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(16, City, false);
                rec."NCT WHT Province" := rec.City;
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(17, "Post Code", false);
                rec."NCT WHT Post Code" := rec."Post Code";
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
                UpdateVendorCustBranch(21, "Phone No.", TRUE);
            end;
        }
        modify("Fax No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(22, "Fax No.", TRUE);
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
            VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Vendor);
            VendorCustBranch.SetRange("Source No.", xrec."No.");
            VendorCustBranch.DeleteAll();

            VendorCustBranch.init();
            VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Vendor;
            VendorCustBranch."Source No." := "No.";
            VendorCustBranch."Head Office" := TRUE;

            VendorCustBranch.insert();
            VenCust.Get(VendorCustBranch.RecordId);
            MyFieldRef := VenCust.Field(FiledsNo);
            if FiledsNo = 3 then
                MyFieldRef.validate(tempHeadOffice)
            else
                MyFieldRef.validate(WHTResult);
            VenCust.Modify();
        end else begin
            VendorCustBranch.reset();
            VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Vendor);
            VendorCustBranch.SetRange("Source No.", "No.");
            VendorCustBranch.SetRange("Head Office", TRUE);
            if VendorCustBranch.FindFirst() then begin
                VenCust.Get(VendorCustBranch.RecordId);
                MyFieldRef := VenCust.Field(FiledsNo);
                if FiledsNo = 3 then
                    MyFieldRef.validate(tempHeadOffice)
                else
                    MyFieldRef.validate(WHTResult);
                VenCust.Modify();
            end else begin
                VendorCustBranch.init();
                VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Vendor;
                VendorCustBranch."Source No." := "No.";
                VendorCustBranch."Head Office" := TRUE;

                VendorCustBranch.insert();
                VenCust.Get(VendorCustBranch.RecordId);
                MyFieldRef := VenCust.Field(FiledsNo);
                if FiledsNo = 3 then
                    MyFieldRef.validate(tempHeadOffice)
                else
                    MyFieldRef.validate(WHTResult);
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
        VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Vendor);
        VendorCustBranch.SetRange("Source No.", "No.");
        VendorCustBranch.DeleteAll();
    end;
}