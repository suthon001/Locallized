codeunit 50004 "Function Center"
{
    /// <summary> 
    /// Description for Get ThaiMonth.
    /// </summary>
    /// <param name="NoOfMonth">Parameter of type Integer.</param>
    /// <returns>Return variable "Text[50]".</returns>
    procedure "Get ThaiMonth"(NoOfMonth: Integer): Text[50]
    begin
        case NoOfMonth OF
            1:
                EXIT('มกราคม');
            2:
                EXIT('กุมภาพันธ์');
            3:
                EXIT('มีนาคม');
            4:
                EXIT('เมษายน');
            5:
                EXIT('พฤษภาคม');
            6:
                EXIT('มิถุนายน');
            7:
                EXIT('กรกฎาคม');
            8:
                EXIT('สิงหาคม');
            9:
                EXIT('กันยายน');
            10:
                EXIT('ตุลาคม');
            11:
                EXIT('พฤศจิกายน');
            12:
                EXIT('ธันวาคม');
        END;

    end;

    /// <summary> 
    /// Description for GetLastLineNoFromGenJnlLine.
    /// </summary>
    /// <param name="pTemplateName">Parameter of type Code[20].</param>
    /// <param name="pBatchName">Parameter of type Code[20].</param>
    procedure "GetLastLineNoFromGenJnlLine"(pTemplateName: Code[20]; pBatchName: Code[20]) rLineNo: Integer
    var
        vlGenJnLineRec: Record "Gen. Journal Line";
    begin
        vlGenJnLineRec.RESET;
        vlGenJnLineRec.SETFILTER("Journal Template Name", '%1', pTemplateName);
        vlGenJnLineRec.SETFILTER("Journal Batch Name", '%1', pBatchName);
        IF vlGenJnLineRec.FIND('+') THEN BEGIN
            rLineNo := vlGenJnLineRec."Line No.";
            EXIT(rLineNo);
        END ELSE BEGIN
            rLineNo := 10000;
            EXIT(rLineNo);
        END;
    end;

    /// <summary> 
    /// Description for ConverseDecimalToText.
    /// </summary>
    /// <param name="Deci">Parameter of type Decimal.</param>
    /// <returns>Return variable "Text".</returns>
    procedure "ConverseDecimalToText"(Deci: Decimal): Text
    begin
        exit(FORMAT(Deci, 0, '<Precision,2:2><Standard Format,0>'));
    end;

    /// <summary> 
    /// Description for CompanyInformation.
    /// </summary>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="EngName">Parameter of type Boolean.</param>
    procedure "CompanyInformation"(VAR Text: ARRAY[10] OF Text[250]; EngName: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.GET;
        if NOT EngName then begin
            Text[1] := CompanyInfo.Name + ' ' + CompanyInfo."Name 2";
            Text[2] := CompanyInfo.Address + ' ';
            Text[3] := CompanyInfo."Address 2" + ' ';
            Text[3] += CompanyInfo.City + ' ' + CompanyInfo."Post Code";
            Text[4] := 'โทร : ' + CompanyInfo."Phone No." + ' ' + CompanyInfo."Phone No. 2";
            if CompanyInfo."Fax No." <> '' then
                Text[4] += 'แฟกซ์ : ' + CompanyInfo."Fax No.";
            Text[5] := 'อีเมลล์ : ' + CompanyInfo."E-Mail";
            Text[6] := 'เลขประจำตัวผู้เสียภาษี : ' + CompanyInfo."VAT Registration No.";
            if CompanyInfo."Head Office" then
                Text[6] += ' (สำนักงานใหญ่)'
            else
                Text[6] += ' (' + CompanyInfo."Branch Code" + ')';
        end else begin
            Text[1] := CompanyInfo."Name (Eng)" + ' ' + CompanyInfo."Name 2 (Eng)";
            Text[2] := CompanyInfo."Address (Eng)" + ' ';
            Text[3] := CompanyInfo."Address 2 (Eng)" + ' ';
            Text[3] += CompanyInfo."City (Eng)" + ' ' + CompanyInfo."Post Code";
            Text[4] := 'Tel. : ' + CompanyInfo."Phone No." + ' ' + CompanyInfo."Phone No. 2";
            if CompanyInfo."Fax No." <> '' then
                Text[4] += 'แฟกซ์ : ' + CompanyInfo."Fax No.";
            Text[5] := 'E-Mail : ' + CompanyInfo."E-Mail";
            Text[6] := 'Tax ID. : ' + CompanyInfo."VAT Registration No.";
            if CompanyInfo."Head Office" then
                Text[6] += ' (Head Office)'
            else
                Text[6] += ' (' + CompanyInfo."Branch Code" + ')';
        end;
    end;

    /// <summary> 
    /// Description for CompanyinformationByVat.
    /// </summary>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="VatBus">Parameter of type Code[10].</param>
    /// <param name="EngName">Parameter of type Boolean.</param>
    procedure "CompanyinformationByVat"(VAR Text: ARRAY[10] OF Text[250]; VatBus: Code[10]; EngName: Boolean)
    var
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
    begin
        IF NOT VATBusinessPostingGroup.GET(VatBus) THEN
            VATBusinessPostingGroup.init;

        IF EngName THEN begin
            Text[1] := VATBusinessPostingGroup."Company Name (Eng)" + ' ';
            Text[1] += VATBusinessPostingGroup."Company Name 2 (Eng)";
            Text[2] := VATBusinessPostingGroup."Company Address (Eng)" + ' ';
            Text[3] := VATBusinessPostingGroup."Company Address 2 (Eng)" + ' ';
            Text[3] += VATBusinessPostingGroup."City (Eng)" + ' ' + VATBusinessPostingGroup."Postcode";

            Text[4] := 'Tel. : ' + VATBusinessPostingGroup."Phone No." + ' ';
            if VATBusinessPostingGroup."Fax No." <> '' then
                Text[4] += ' Fax. : ' + VATBusinessPostingGroup."Fax No.";
            Text[5] := 'E-mail : ' + VATBusinessPostingGroup."Email";
            Text[6] := 'Tax ID. : ' + VATBusinessPostingGroup."VAT Registration No.";
            if VATBusinessPostingGroup."Head Office" then
                Text[6] += ' (Head Office)'
            else
                Text[6] += ' (' + VATBusinessPostingGroup."Branch Code" + ')';
        end else begin
            Text[1] := VATBusinessPostingGroup."Company Name (Thai)" + ' ';
            Text[1] += VATBusinessPostingGroup."Company Name 2 (Thai)";
            Text[2] := VATBusinessPostingGroup."Company Address (Thai)" + ' ';
            Text[3] := VATBusinessPostingGroup."Company Address 2 (Thai)" + ' ';
            Text[3] += VATBusinessPostingGroup."City (Thai)" + ' ' + VATBusinessPostingGroup."Postcode";

            Text[4] := 'โทร : ' + VATBusinessPostingGroup."Phone No.";
            if VATBusinessPostingGroup."Fax No." <> '' then
                Text[4] += ' แฟกซ์ : ' + VATBusinessPostingGroup."Fax No.";
            Text[5] := 'อีเมลล์ : ' + VATBusinessPostingGroup."Email";
            Text[6] := 'เลขประจำตัวผู้เสียภาษี : ' + VATBusinessPostingGroup."VAT Registration No.";
            if VATBusinessPostingGroup."Head Office" then
                Text[6] += ' (สำนักงานใหญ่)'
            else
                Text[6] += ' (' + VATBusinessPostingGroup."Branch Code" + ')';

        end;
    END;

    /// <summary> 
    /// Description for PurchaseInformation.
    /// </summary>
    /// <param name="DocumentType">Parameter of type Enum "Purchase Document Type".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="Tab">Parameter of type Option General,Invoicing,Shipping.</param>
    procedure "PurchaseInformation"(DocumentType: Enum "Purchase Document Type"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        PurchHeader: Record "Purchase Header";
        Vend: Record Vendor;
        Cust: Record Customer;
        VandorBranch: Record "Customer & Vendor Branch";
    begin
        PurchHeader.GET(DocumentType, DocumentNo);
        // CASE DocumentType OF
        //     DocumentType::Quote, DocumentType::Order, DocumentType::Invoice,
        //     DocumentType::"Credit Memo", DocumentType::"Blanket Order", DocumentType::"Return Order", DocumentType::"Requisition":
        //         BEGIN

        CASE Tab OF
            Tab::General:
                BEGIN
                    // if (PurchHeader."Head Office") then begin
                    IF NOT Vend.GET(PurchHeader."Buy-from Vendor No.") THEN
                        Vend.INIT;
                    Text[1] := PurchHeader."Buy-from Vendor Name" + ' ' + PurchHeader."Buy-from Vendor Name 2";
                    Text[2] := PurchHeader."Buy-from Address" + ' ';
                    Text[3] := PurchHeader."Buy-from Address 2" + ' ';
                    Text[3] += PurchHeader."Buy-from City" + ' ' + PurchHeader."Buy-from Post Code";
                    Text[4] := Vend."Phone No." + ' ';
                    if PurchHeader."Currency Code" = '' then begin

                        IF Vend."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                    end else begin

                        IF Vend."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                    end;
                    Text[5] := PurchHeader."Buy-from Contact";
                    // END else begin
                    if (PurchHeader."Branch Code" <> '') AND (NOT PurchHeader."Head Office") then begin
                        if not VandorBranch.GET(VandorBranch."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."Head Office", PurchHeader."Branch Code") then
                            VandorBranch.Init();
                        Text[1] := VandorBranch."Name";
                        Text[2] := VandorBranch."Address";
                        Text[3] := VandorBranch."Province" + ' ' + VandorBranch."Post Code";
                        Text[4] := VandorBranch."Phone No." + ' ';
                        if PurchHeader."Currency Code" = '' then begin
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('แฟกซ์ : %1', VandorBranch."Fax No.");
                        end else begin
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('Fax. : %1', VandorBranch."Fax No.");
                        end;

                    end;


                    Text[9] := PurchHeader."Buy-from Vendor No.";
                END;
            Tab::Invoicing:
                BEGIN
                    IF NOT Vend.GET(PurchHeader."Pay-to Vendor No.") THEN
                        Vend.INIT;
                    Text[1] := PurchHeader."Pay-to Name" + ' ' + PurchHeader."Pay-to Name 2";
                    Text[2] := PurchHeader."Pay-to Address" + ' ';
                    Text[3] := PurchHeader."Pay-to Address 2" + ' ';
                    Text[3] += PurchHeader."Pay-to City" + ' ' + PurchHeader."Pay-to Post Code";
                    Text[4] := Vend."Phone No." + ' ';
                    if PurchHeader."Currency Code" = '' then begin

                        IF Vend."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                    end else begin

                        IF Vend."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                    end;
                    Text[5] := PurchHeader."Pay-to Contact";
                    if (PurchHeader."Branch Code" <> '') AND (NOT PurchHeader."Head Office") then begin
                        if not VandorBranch.GET(VandorBranch."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."Head Office", PurchHeader."Branch Code") then
                            VandorBranch.Init();
                        Text[1] := VandorBranch."Name";
                        Text[2] := VandorBranch."Address";
                        Text[3] := VandorBranch."Province" + ' ' + VandorBranch."Post Code";
                        Text[4] := VandorBranch."Phone No." + ' ';
                        if PurchHeader."Currency Code" = '' then begin
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('แฟกซ์ : %1', VandorBranch."Fax No.");
                        end else begin
                            IF VandorBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('Fax. : %1', VandorBranch."Fax No.");
                        end;

                    end;
                    Text[9] := PurchHeader."Pay-to Vendor No.";
                END;
            Tab::Shipping:
                BEGIN
                    IF NOT Cust.GET(PurchHeader."Sell-to Customer No.") THEN
                        Cust.init;
                    Text[1] := PurchHeader."Ship-to Name" + ' ' + PurchHeader."Ship-to Name 2";
                    Text[2] := PurchHeader."Ship-to Address" + ' ';
                    Text[3] := PurchHeader."Ship-to Address 2" + ' ';
                    Text[3] += PurchHeader."Ship-to City" + ' ' + PurchHeader."Ship-to Post Code";
                    Text[4] := Cust."Phone No." + ' ';
                    if PurchHeader."Currency Code" = '' then begin

                        IF Vend."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                    end else begin

                        IF Vend."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                    end;
                    Text[5] := PurchHeader."Ship-to Contact";

                END;
        end;
        //     end;
        //  end;
        //if PurchHeader."Head Office" then
        Text[10] := PurchHeader."VAT Registration No.";
        if (PurchHeader."Branch Code" <> '') AND (NOT PurchHeader."Head Office") then begin
            if not VandorBranch.GET(VandorBranch."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."Head Office", PurchHeader."Branch Code") then
                VandorBranch.Init();
            Text[10] := VandorBranch."VAT Registration No.";
        end;
        if PurchHeader."Currency Code" = '' then begin
            if PurchHeader."Head Office" then
                Text[10] += ' (สำนักงานใหญ่)'
            else
                Text[10] += ' (' + PurchHeader."Branch Code" + ')';
        end else begin
            if PurchHeader."Head Office" then
                Text[10] += ' (Head Office)'
            else
                Text[10] += ' (' + PurchHeader."Branch Code" + ')';
        end;
    end;

    /// <summary> 
    /// Description for ConvExchRate.
    /// </summary>
    /// <param name="CurrencyCode">Parameter of type Code[10].</param>
    /// <param name="CurrencyFactor">Parameter of type Decimal.</param>
    /// <param name="VAR Text">Parameter of type Text[30].</param>
    procedure "ConvExchRate"(CurrencyCode: Code[10]; CurrencyFactor: Decimal; VAR Text: Text[30])
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.GET;
        Text := '';
        IF CurrencyCode = '' THEN
            Text := 'THB'
        ELSE
            if CurrencyCode <> 'THB' then
                Text := STRSUBSTNO('%1 (%2)', COPYSTR(CurrencyCode, 1, 3), ROUND(1 / CurrencyFactor, 0.00001));
    end;



    /// <summary> 
    /// Description for NumberEngToText.
    /// </summary>
    /// <param name="TDecimal">Parameter of type Decimal.</param>
    /// <param name="CurrencyCode">Parameter of type Code[30].</param>
    procedure "NumberEngToText"(TDecimal: Decimal; CurrencyCode: Code[30]) TText: Text
    var
        THigh: Decimal;
        TLow: Decimal;
        TText1: array[2] of Text[1024];
    begin
        TDecimal := ROUND(TDecimal, 0.01);
        "InitTextVariable";
        "EngInterger"(TText1, TDecimal, CurrencyCode);
        TLow := (TDecimal - ROUND(TDecimal, 1, '<')) * 100;
        IF TLow < 1 THEN
            TLow := 0;
        if CurrencyCode <> '' then
            TText := STRSUBSTNO('%3 : %1 %2', TText1[1], TText1[2], CurrencyCode)
        else
            TText := StrSubstNo('%1 %2', TText1[1], TText1[2]);
        exit(TText);
    end;

    /// <summary> 
    /// Description for NumberThaiToText.
    /// </summary>
    /// <param name="Amount">Parameter of type Decimal.</param>
    /// <returns>Return variable "Text".</returns>
    procedure "NumberThaiToText"(Amount: Decimal): Text
    var
        AmountText: Text[1024];
        x: Integer;
        l: Integer;
        P: Integer;
        adigit: text[1];
        dflag: Boolean;
        AmtThaiText: text[200];
    begin
        AmountText := FORMAT(Amount, 0);
        x := STRPOS(AmountText, '.');
        CASE TRUE OF
            x = 0:
                AmountText := AmountText + '.00';
            x = STRLEN(AmountText) - 1:
                AmountText := AmountText + '0';
            x > STRLEN(AmountText) - 2:
                AmountText := COPYSTR(AmountText, 1, x + 2);
        END;
        l := STRLEN(AmountText);
        REPEAT
            dflag := FALSE;
            p := STRLEN(AmountText) - l + 1;
            adigit := COPYSTR(AmountText, p, 1);
            IF (l IN [4, 12, 20]) AND (l < STRLEN(AmountText)) AND (adigit = '1') THEN
                dflag := TRUE;
            AmtThaiText := AmtThaiText + "FormatDigitThai"(adigit, l - 3, dflag);
            l := l - 1;
        UNTIL l = 3;

        IF COPYSTR(AmountText, STRLEN(AmountText) - 2, 3) = '.00' THEN
            AmtThaiText := AmtThaiText + 'บาทถ้วน'
        ELSE BEGIN
            IF AmtThaiText <> '' THEN
                AmtThaiText := AmtThaiText + 'บาท';
            l := 2;
            REPEAT
                dflag := FALSE;
                p := STRLEN(AmountText) - l + 1;
                adigit := COPYSTR(AmountText, p, 1);
                IF (l = 1) AND (adigit = '1') AND (COPYSTR(AmountText, p - 1, 1) <> '0') THEN
                    dflag := TRUE;
                AmtThaiText := AmtThaiText + "FormatDigitThai"(adigit, l, dflag);
                l := l - 1;
            UNTIL l = 0;
            AmtThaiText := AmtThaiText + 'สตางค์';
        END;

        EXIT(AmtThaiText);
    end;

    Local procedure "FormatDigitThai"(adigit: text[1]; pos: Integer; dflag: Boolean): Text
    var
        fdigit: Text[30];
        fcount: Text[30];
    begin
        CASE adigit OF
            '1':
                BEGIN
                    IF (pos IN [1, 9, 17]) AND dflag THEN
                        fdigit := 'เอ็ด'
                    ELSE
                        IF pos IN [2, 10, 18] THEN
                            fdigit := ''
                        ELSE
                            fdigit := 'หนึ่ง';
                END;
            '2':
                BEGIN
                    IF pos IN [2, 10, 18] THEN
                        fdigit := 'ยี่'
                    ELSE
                        fdigit := 'สอง';
                END;
            '3':
                fdigit := 'สาม';
            '4':
                fdigit := 'สี่';
            '5':
                fdigit := 'ห้า';
            '6':
                fdigit := 'หก';
            '7':
                fdigit := 'เจ็ด';
            '8':
                fdigit := 'แปด';
            '9':
                fdigit := 'เก้า';
            '0':
                BEGIN
                    IF pos IN [9, 17, 25] THEN
                        fdigit := 'ล้าน';
                END;
            '-':
                fdigit := 'ลบ';
        END;
        IF (adigit <> '0') AND (adigit <> '-') THEN BEGIN
            CASE pos OF
                2, 10, 18:
                    fcount := 'สิบ';
                3, 11, 19:
                    fcount := 'ร้อย';
                5, 13, 21:
                    fcount := 'พัน';
                6, 14, 22:
                    fcount := 'หมื่น';
                7, 15, 23:
                    fcount := 'แสน';
                9, 17, 25:
                    fcount := 'ล้าน';
            END;
        END;
        EXIT(fdigit + fcount);
    end;

    Local procedure "InitTextVariable"()
    var

        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text126: Label 'SOON';
        Text127: Label 'ROI';
        Text128: Label '&';
        Text129: Label '%1 results in a written number that is too long.';
        Text130: Label 'is already applied to %1 %2 for customer %3.';
        Text131: Label 'is already applied to %1 %2 for vendor %3.';
        Text132: Label 'NUENG';
        Text133: Label 'SAWNG';
        Text134: Label 'SARM';
        Text135: Label 'SI';
        Text136: Label 'HA';
        Text137: Label 'HOK';
        Text138: Label 'CHED';
        Text139: Label 'PAED';
        Text140: Label 'KOW';
        Text141: Label 'SIB';
        Text142: Label 'SIB-ED';
        Text143: Label 'SIB-SAWNG';
        Text144: Label 'SIB-SARM';
        Text145: Label 'SIB-SI';
        Text146: Label 'SIB-HA';
        Text147: Label 'SIB-HOK';
        Text148: Label 'SIB-CHED';
        Text149: Label 'SIB-PAED';
        Text150: Label 'SIB-KOW';
        Text151: Label 'YI-SIB';
        Text152: Label 'SARM-SIB';
        Text153: Label 'SI-SIB';
        Text154: Label 'HA-SIB';
        Text155: Label 'HOK-SIB';
        Text156: Label 'CHED-SIB';
        Text157: Label 'PAED-SIB';
        Text158: Label 'KOW-SIB';
        Text159: Label 'PHAN';
        Text160: Label 'LAAN?';
        Text161: Label 'PHAN-LAAN?';
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    Local procedure "EngInterger"(VAR NoText: ARRAY[2] OF Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        varzero: Code[10];
        Text027: Label 'HUNDRED';
        Text026: Label 'ZERO';
        Text028: Label 'AND';
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            "AddToNoText"(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        IF CurrencyCode = '' THEN BEGIN
            IF No = 0 THEN BEGIN
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'BAHT');
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ONLY ')
            END
            ELSE BEGIN
                //  "AddToNoText"(NoText,NoTextIndex,PrintExponent,'BAHT');
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, Text028);
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'POINT');
                Ones := No * 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                //...Customize
                varzero := '';
                IF (No * 100) < 10 THEN
                    varzero := '0';
                //"AddToNoText"(NoText, NoTextIndex, PrintExponent, varzero + FORMAT((No * 100), 0, 0) + '/100');

                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[1], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1));
                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[2], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1));


                if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] <> 0) then
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]] + ' ' + OnesText[TempCurrencyPointInterger[2]])
                else begin
                    if (TempCurrencyPointInterger[1] = 0) And (TempCurrencyPointInterger[2] <> 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ZERO ' + OnesText[TempCurrencyPointInterger[2]]);
                    if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] = 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]]);

                end;
            END;
        END ELSE BEGIN
            IF No = 0 THEN BEGIN
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ONLY ');
            END ELSE BEGIN
                "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'POINT');
                //...Customize
                varzero := '';
                IF (No * 100) < 10 THEN
                    varzero := '0';
                // "AddToNoText"(NoText, NoTextIndex, PrintExponent, varzero + FORMAT((No * 100), 0, 0) + '/100');
                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[1], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 1, 1));
                if COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1) <> '' then
                    Evaluate(TempCurrencyPointInterger[2], COPYSTR(varzero + FORMAT((No * 100), 0, 0), 2, 1));

                if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] <> 0) then
                    "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]] + ' ' + OnesText[TempCurrencyPointInterger[2]])
                else begin
                    if (TempCurrencyPointInterger[1] = 0) And (TempCurrencyPointInterger[2] <> 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, 'ZERO ' + OnesText[TempCurrencyPointInterger[2]]);
                    if (TempCurrencyPointInterger[1] <> 0) And (TempCurrencyPointInterger[2] = 0) then
                        "AddToNoText"(NoText, NoTextIndex, PrintExponent, OnesText[TempCurrencyPointInterger[1]]);

                end;
            END;

        END
    end;

    /// <summary> 
    /// Description for AddToNoText.
    /// </summary>
    /// <param name="VAR NoText">Parameter of type ARRAY[2] OF Text[80].</param>
    /// <param name="VAR NoTextIndex">Parameter of type Integer.</param>
    /// <param name="VAR PrintExponent">Parameter of type Boolean.</param>
    /// <param name="AddText">Parameter of type Text[30].</param>
    local procedure "AddToNoText"(VAR NoText: ARRAY[2] OF Text[80]; VAR NoTextIndex: Integer; VAR PrintExponent: Boolean; AddText: Text[30])
    var
        Text029: Label '%1 results in a written number that is too long.';
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    /// <summary> 
    /// Description for SalesInformation.
    /// </summary>
    /// <param name="DocumentType">Parameter of type Enum "Sales Document Type".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    /// <param name="Tab">Parameter of type Option General,Invoicing,Shipping.</param>
    procedure "SalesInformation"(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        SalesHeader: Record "Sales Header";
        Cust: Record Customer;
        Shipto: Record "Ship-to Address";
        CustBranch: Record "Customer & Vendor Branch";
    begin
        SalesHeader.GET(DocumentType, DocumentNo);
        // CASE DocumentType OF
        //     DocumentType::Quote, DocumentType::Order, DocumentType::Invoice,
        //     DocumentType::"Credit Memo", DocumentType::"Blanket Order", DocumentType::"Return Order":
        //         BEGIN
        CASE Tab OF
            Tab::General:
                BEGIN
                    //  if SalesHeader."Head Office" then begin
                    IF NOT Cust.GET(SalesHeader."Sell-to Customer No.") THEN
                        Cust.INIT;
                    Text[1] := SalesHeader."Sell-to Customer Name" + ' ' + SalesHeader."Sell-to Customer Name 2";
                    Text[2] := SalesHeader."Sell-to Address" + ' ';
                    Text[3] := SalesHeader."Sell-to Address 2" + ' ';
                    Text[3] += SalesHeader."Sell-to City" + ' ' + SalesHeader."Sell-to Post Code";
                    Text[4] := Cust."Phone No." + ' ';
                    if SalesHeader."Currency Code" = '' then begin

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                    end else begin

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                    end;
                    Text[5] := SalesHeader."Sell-to Contact";
                    // end else begin
                    if (SalesHeader."Branch Code" <> '') AND (NOT SalesHeader."Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::Customer, SalesHeader."Sell-to Customer No.", SalesHeader."Head Office", SalesHeader."Branch Code") then
                            CustBranch.Init();
                        Text[1] := CustBranch."Name";
                        Text[2] := CustBranch."Address";
                        Text[3] := CustBranch."Province" + ' ' + CustBranch."Post Code";
                        Text[4] := CustBranch."Phone No." + ' ';
                        if SalesHeader."Currency Code" = '' then begin
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('แฟกซ์ : %1', CustBranch."Fax No.");
                        end else begin
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('Fax. : %1', CustBranch."Fax No.");
                        end;
                    end;
                    Text[9] := SalesHeader."Sell-to Customer No.";
                END;
            Tab::Invoicing:
                BEGIN
                    IF NOT Cust.GET(SalesHeader."Bill-to Customer No.") THEN
                        Cust.INIT;
                    Text[1] := SalesHeader."Bill-to Name" + ' ' + SalesHeader."Bill-to Name 2";
                    Text[2] := SalesHeader."Bill-to Address" + ' ';
                    Text[3] := SalesHeader."Bill-to Address 2" + ' ';
                    Text[3] += SalesHeader."Bill-to City" + ' ' + SalesHeader."Bill-to Post Code";
                    Text[4] := Cust."Phone No." + ' ';
                    if SalesHeader."Currency Code" = '' then begin

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                    end else begin

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                    end;
                    Text[5] := SalesHeader."Bill-to Contact";
                    if (SalesHeader."Branch Code" <> '') AND (NOT SalesHeader."Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::Customer, SalesHeader."Sell-to Customer No.", SalesHeader."Head Office", SalesHeader."Branch Code") then
                            CustBranch.Init();
                        Text[1] := CustBranch."Name";
                        Text[2] := CustBranch."Address";
                        Text[3] := CustBranch."Province" + ' ' + CustBranch."Post Code";
                        Text[4] := CustBranch."Phone No." + ' ';
                        if SalesHeader."Currency Code" = '' then begin
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('แฟกซ์ : %1', CustBranch."Fax No.");
                        end else begin
                            IF CustBranch."Fax No." <> '' THEN
                                Text[4] += STRSUBSTNO('Fax. : %1', CustBranch."Fax No.");
                        end;
                    end;
                    Text[9] := SalesHeader."Bill-to Customer No.";
                END;
            Tab::Shipping:
                BEGIN
                    IF NOT Shipto.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") THEN
                        Shipto.INIT;

                    Text[1] := SalesHeader."Ship-to Name" + ' ' + SalesHeader."Ship-to Name 2";
                    Text[2] := SalesHeader."Ship-to Address" + ' ';
                    Text[3] := SalesHeader."Ship-to Address 2" + ' ';
                    Text[3] += SalesHeader."Ship-to City" + ' ' + SalesHeader."Ship-to Post Code";
                    Text[4] := Shipto."Phone No." + ' ';
                    if SalesHeader."Currency Code" = '' then begin

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                    end else begin

                        IF Cust."Fax No." <> '' THEN
                            Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");

                    end;
                    Text[5] := SalesHeader."Ship-to Contact";

                END;
        end;

        //end;
        // end; 
        Text[10] := SalesHeader."VAT Registration No.";
        if (SalesHeader."Branch Code" <> '') AND (NOT SalesHeader."Head Office") then begin
            if not CustBranch.GET(CustBranch."Source Type"::customer, SalesHeader."Sell-to Customer No.", SalesHeader."Head Office", SalesHeader."Branch Code") then
                CustBranch.Init();
            Text[10] := CustBranch."VAT Registration No.";
        end;
        if SalesHeader."Currency Code" = '' then begin

            if SalesHeader."Head Office" then
                Text[10] += ' (สำนักงานใหญ่)'
            else
                Text[10] += ' (' + SalesHeader."Branch Code" + ')';
        end else begin

            if SalesHeader."Head Office" then
                Text[10] += ' (Head Office)'
            else
                Text[10] += ' (' + SalesHeader."Branch Code" + ')';
        end;

    end;

    /// <summary> 
    /// Description for VendInfo.
    /// </summary>
    /// <param name="VendorNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    procedure "VendInfo"(VendorNo: Code[20]; VAR Text: ARRAY[10] OF Text[250])
    var
        Vendor: Record Vendor;
    begin
        IF NOT Vendor.GET(VendorNo) THEN
            Vendor.INIT;
        Text[1] := Vendor.Name + ' ' + Vendor."Name 2";
        Text[2] := Vendor.Address + ' ';
        Text[3] := Vendor."Address 2" + ' ' + Vendor.City + ' ' + Vendor."Post Code";
        Text[4] := Vendor."Phone No." + ' ';
        IF (Vendor."Fax No." <> '') THEN
            Text[4] += STRSUBSTNO('แฟกซ์', Vendor."Fax No.");
        Text[5] := Vendor."E-Mail";
        Text[6] := Vendor.Contact;
        Text[9] := Vendor."No.";
        Text[10] := Vendor."VAT Registration No.";
    end;

    /// <summary> 
    /// Description for CusInfo.
    /// </summary>
    /// <param name="CustNo">Parameter of type Code[20].</param>
    /// <param name="VAR Text">Parameter of type ARRAY[10] OF Text[250].</param>
    procedure "CusInfo"(CustNo: Code[20]; VAR Text: ARRAY[10] OF Text[250])
    var
        Cust: Record Customer;
    begin
        IF NOT Cust.GET(CustNo) THEN
            Cust.INIT;
        Text[1] := Cust.Name + ' ' + Cust."Name 2";
        Text[2] := Cust.Address + ' ';
        Text[3] := Cust."Address 2" + ' ' + Cust.City + ' ' + Cust."Post Code";
        Text[4] := Cust."Phone No." + ' ';
        IF (Cust."Fax No." <> '') THEN
            Text[4] += STRSUBSTNO('แฟกซ์', Cust."Fax No.");
        Text[5] := Cust."E-Mail";
        Text[6] := Cust.Contact;
        Text[9] := Cust."No.";
        Text[10] := Cust."VAT Registration No.";

    end;

    /// <summary> 
    /// Description for JnlFindApplyEntries.
    /// </summary>
    /// <param name="JnlTemplateName">Parameter of type Code[30].</param>
    /// <param name="JnlBatchName">Parameter of type code[30].</param>
    /// <param name="PostingDate">Parameter of type Date.</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR CVLedgEntryBuf">Parameter of type Record "CV Ledger Entry Buffer" TEMPORARY.</param>
    procedure "JnlFindApplyEntries"(JnlTemplateName: Code[30]; JnlBatchName: code[30]; PostingDate: Date; DocumentNo: Code[20]; VAR CVLedgEntryBuf: Record "CV Ledger Entry Buffer" TEMPORARY)
    var
        GenJnlLine: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CvNo: Code[30];
    begin
        GenJnlLine.RESET;
        GenJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Document No.", "Posting Date");
        GenJnlLine.SETRANGE("Journal Template Name", JnlTemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", JnlBatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        GenJnlLine.SETRANGE("Posting Date", PostingDate);
        IF GenJnlLine.FINDFIRST THEN
            REPEAT
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) OR
                   (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor) THEN BEGIN
                    CVNo := GenJnlLine."Bal. Account No.";
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
                        CVNo := GenJnlLine."Account No.";
                    IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                        VendLedgEntry.RESET;
                        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
                        VendLedgEntry.SETRANGE("Vendor No.", CVNo);
                        VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                        //VendLedgEntry.SETRANGE(Open,TRUE);
                        IF VendLedgEntry.FINDFIRST THEN
                            REPEAT
                                VendLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                                //GenPostLine.TransferVendLedgEntry(CVLedgEntryBuf,VendLedgEntry,TRUE);
                                if not CVLedgEntryBuf.INSERT then
                                    CVLedgEntryBuf.Modify();
                            UNTIL VendLedgEntry.NEXT = 0;
                    END ELSE
                        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                            VendLedgEntry.RESET;
                            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Document Type", "Document No.", Open);
                            VendLedgEntry.SETRANGE("Vendor No.", CVNo);
                            VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                            VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                            //VendLedgEntry.SETRANGE(Open,TRUE);
                            IF VendLedgEntry.FINDFIRST THEN BEGIN
                                VendLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                                //TmpGenPostLine.TransferVendLedgEntry(CVLedgEntryBuf,VendLedgEntry,TRUE);
                                //CVLedgEntryBuf."Amount to Apply" := VendLedgEntry."Remaining Amount";
                                if not CVLedgEntryBuf.INSERT then
                                    CVLedgEntryBuf.Modify();
                            END;
                        END;
                END;
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) OR
                   (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) THEN BEGIN
                    CVNo := GenJnlLine."Bal. Account No.";
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
                        CVNo := GenJnlLine."Account No.";
                    IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                        CustLedgEntry.RESET;
                        CustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
                        CustLedgEntry.SETRANGE("Customer No.", CVNo);
                        CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                        //CustLedgEntry.SETRANGE(Open,TRUE);
                        IF CustLedgEntry.FINDFIRST THEN
                            REPEAT
                                CustLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                //TmpGenPostLine.TransferCustLedgEntry(CVLedgEntryBuf,CustLedgEntry,TRUE);
                                CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
                                if not CVLedgEntryBuf.INSERT then
                                    CVLedgEntryBuf.Modify();
                            UNTIL CustLedgEntry.NEXT = 0;
                    END ELSE
                        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                            CustLedgEntry.RESET;
                            CustLedgEntry.SETCURRENTKEY("Customer No.", "Document Type", "Document No.", Open);
                            CustLedgEntry.SETRANGE("Customer No.", CVNo);
                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                            //CustLedgEntry.SETRANGE(Open,TRUE);
                            IF CustLedgEntry.FINDFIRST THEN BEGIN
                                CustLedgEntry.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount",
                                    "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                                //TmpGenPostLine.TransferCustLedgEntry(CVLedgEntryBuf,CustLedgEntry,TRUE);
                                CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
                                //CVLedgEntryBuf."Amount to Apply" := CustLedgEntry."Remaining Amount";
                                if not CVLedgEntryBuf.INSERT then
                                    CVLedgEntryBuf.Modify();
                            END;
                        END;
                END;

            UNTIL GenJnlLine.NEXT = 0;
    end;

    procedure "SalesInvoiceStatistics"(DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR TempVATAmountLine: Record "VAT Amount Line" TEMPORARY)
    var
        CustAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        CostLCY: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        VATPercentage: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        AmountLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        Currency: Record "Currency";
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record "Customer";
        Text000: Label 'VAT Amount';
        Text001: Label 'VAT %1%';



    begin
        SalesInvHeader.SETRANGE("No.", DocumentNo);
        IF SalesInvHeader.FindFirst() THEN BEGIN

            IF SalesInvHeader."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE
                Currency.GET(SalesInvHeader."Currency Code");

            SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");

            IF SalesInvLine.FindSet() THEN
                REPEAT
                    CustAmount := CustAmount + SalesInvLine.Amount;
                    AmountInclVAT := AmountInclVAT + SalesInvLine."Amount Including VAT";
                    IF SalesInvHeader."Prices Including VAT" THEN
                        InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount" / (1 + SalesInvLine."VAT %" / 100)
                    ELSE
                        InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount";
                    CostLCY := CostLCY + (SalesInvLine.Quantity * SalesInvLine."Unit Cost (LCY)");
                    LineQty := LineQty + SalesInvLine.Quantity;
                    TotalNetWeight := TotalNetWeight + (SalesInvLine.Quantity * SalesInvLine."Net Weight");
                    TotalGrossWeight := TotalGrossWeight + (SalesInvLine.Quantity * SalesInvLine."Gross Weight");
                    TotalVolume := TotalVolume + (SalesInvLine.Quantity * SalesInvLine."Unit Volume");
                    IF SalesInvLine."Units per Parcel" > 0 THEN
                        TotalParcels := TotalParcels + ROUND(SalesInvLine.Quantity / SalesInvLine."Units per Parcel", 1, '>');
                    IF SalesInvLine."VAT %" <> VATPercentage THEN
                        IF VATPercentage = 0 THEN
                            VATPercentage := SalesInvLine."VAT %"
                        ELSE
                            VATPercentage := -1;
                UNTIL SalesInvLine.NEXT = 0;


            VATAmount := AmountInclVAT - CustAmount;
            InvDiscAmount := ROUND(InvDiscAmount, Currency."Amount Rounding Precision");

            IF VATPercentage <= 0 THEN
                VATAmountText := Text000
            ELSE
                VATAmountText := STRSUBSTNO(Text001, VATPercentage);

            IF SalesInvHeader."Currency Code" = '' THEN
                AmountLCY := CustAmount
            ELSE
                AmountLCY := CurrExchRate.ExchangeAmtFCYToLCY(
                    WORKDATE, SalesInvHeader."Currency Code", CustAmount, SalesInvHeader."Currency Factor");


            ProfitLCY := AmountLCY - CostLCY;
            IF AmountLCY <> 0 THEN
                ProfitPct := ROUND(100 * ProfitLCY / AmountLCY, 0.1);


            IF Cust.GET(SalesInvHeader."Bill-to Customer No.") THEN
                Cust.CALCFIELDS("Balance (LCY)");

            IF Cust."Credit Limit (LCY)" = 0 THEN
                CreditLimitLCYExpendedPct := 0
            ELSE BEGIN
                IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0 THEN
                    CreditLimitLCYExpendedPct := 0
                ELSE BEGIN
                    IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1 THEN
                        CreditLimitLCYExpendedPct := 10000
                    ELSE
                        CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000, 1);
                END;
            END;
        END;

        SalesInvLine.CalcVATAmountLines(SalesInvHeader, TempVATAmountLine);

        IF NOT SalesInvHeader."Prices Including VAT" THEN BEGIN
            TotalAmt[1] := CustAmount + InvDiscAmount;
            TotalAmt[2] := InvDiscAmount;
            TotalAmt[3] := CustAmount;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := AmountInclVAT;
            TotalAmt[6] := AmountLCY;
            TotalAmt[7] := CostLCY;
            TotalAmt[8] := ProfitLCY;
            TotalAmt[9] := ProfitPct;
            TotalAmt[10] := LineQty;
            TotalAmt[11] := TotalParcels;
            TotalAmt[12] := TotalNetWeight;
            TotalAmt[13] := TotalGrossWeight;
            TotalAmt[14] := TotalVolume;
            TotalAmt[15] := Cust."Balance (LCY)";
            TotalAmt[16] := Cust."Credit Limit (LCY)";
            TotalAmt[17] := VATPercentage;
        END ELSE BEGIN
            TotalAmt[1] := CustAmount + InvDiscAmount;
            TotalAmt[2] := InvDiscAmount;
            TotalAmt[3] := AmountInclVAT;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := CustAmount;
            TotalAmt[6] := AmountLCY;
            TotalAmt[7] := CostLCY;
            TotalAmt[8] := ProfitLCY;
            TotalAmt[9] := ProfitPct;
            TotalAmt[10] := LineQty;
            TotalAmt[11] := TotalParcels;
            TotalAmt[12] := TotalNetWeight;
            TotalAmt[13] := TotalGrossWeight;
            TotalAmt[14] := TotalVolume;
            TotalAmt[15] := Cust."Balance (LCY)";
            TotalAmt[16] := Cust."Credit Limit (LCY)";
            TotalAmt[17] := VATPercentage;
        END;
    end;

    procedure "SalesCrMemoStatistics"(DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR TempVATAmountLine: Record "VAT Amount Line" TEMPORARY)
    var
        CustAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        CostLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        AmountLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        VATpercentage: Decimal;
        VATAmountText: Text[30];
        VATAmount: Decimal;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Currency: Record "Currency";
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record "Customer";
        Text000: Label 'VAT Amount';
        Text001: Label 'VAT %1%';

    begin
        SalesCrMemoHeader.SETRANGE("No.", DocumentNo);
        IF SalesCrMemoHeader.FindFirst() THEN BEGIN
            IF SalesCrMemoHeader."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE
                Currency.GET(SalesCrMemoHeader."Currency Code");

            SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");

            IF SalesCrMemoLine.FindSet() THEN
                REPEAT
                    CustAmount := CustAmount + SalesCrMemoLine.Amount;
                    AmountInclVAT := AmountInclVAT + SalesCrMemoLine."Amount Including VAT";
                    IF SalesCrMemoHeader."Prices Including VAT" THEN
                        InvDiscAmount := InvDiscAmount + SalesCrMemoLine."Inv. Discount Amount" / (1 + SalesCrMemoLine."VAT %" / 100)
                    ELSE
                        InvDiscAmount := InvDiscAmount + SalesCrMemoLine."Inv. Discount Amount";
                    CostLCY := CostLCY + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Cost (LCY)");
                    LineQty := LineQty + SalesCrMemoLine.Quantity;
                    TotalNetWeight := TotalNetWeight + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Net Weight");
                    TotalGrossWeight := TotalGrossWeight + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Gross Weight");
                    TotalVolume := TotalVolume + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Volume");
                    IF SalesCrMemoLine."Units per Parcel" > 0 THEN
                        TotalParcels := TotalParcels + ROUND(SalesCrMemoLine.Quantity / SalesCrMemoLine."Units per Parcel", 1, '>');
                    IF SalesCrMemoLine."VAT %" <> VATpercentage THEN
                        IF VATpercentage = 0 THEN
                            VATpercentage := SalesCrMemoLine."VAT %"
                        ELSE
                            VATpercentage := -1;
                UNTIL SalesCrMemoLine.NEXT = 0;
            VATAmount := AmountInclVAT - CustAmount;
            InvDiscAmount := ROUND(InvDiscAmount, Currency."Amount Rounding Precision");

            IF VATpercentage <= 0 THEN
                VATAmountText := Text000
            ELSE
                VATAmountText := STRSUBSTNO(Text001, VATpercentage);

            IF SalesCrMemoHeader."Currency Code" = '' THEN
                AmountLCY := CustAmount
            ELSE
                AmountLCY :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                    WORKDATE, SalesCrMemoHeader."Currency Code", CustAmount, SalesCrMemoHeader."Currency Factor");
            ProfitLCY := AmountLCY - CostLCY;
            IF AmountLCY <> 0 THEN
                ProfitPct := ROUND(100 * ProfitLCY / AmountLCY, 0.1);

            IF Cust.GET(SalesCrMemoHeader."Bill-to Customer No.") THEN
                Cust.CALCFIELDS("Balance (LCY)")
            ELSE
                CLEAR(Cust);
            IF Cust."Credit Limit (LCY)" = 0 THEN
                CreditLimitLCYExpendedPct := 0
            ELSE
                IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0 THEN
                    CreditLimitLCYExpendedPct := 0
                ELSE
                    IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1 THEN
                        CreditLimitLCYExpendedPct := 10000
                    ELSE
                        CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000, 1);
        END;

        SalesCrMemoLine.CalcVATAmountLines(SalesCrMemoHeader, TempVATAmountLine);
        IF NOT SalesCrMemoHeader."Prices Including VAT" THEN BEGIN
            TotalAmt[1] := CustAmount + InvDiscAmount;
            TotalAmt[2] := InvDiscAmount;
            TotalAmt[3] := CustAmount;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := AmountInclVAT;
            TotalAmt[6] := AmountLCY;
            TotalAmt[7] := CostLCY;
            TotalAmt[8] := ProfitLCY;
            TotalAmt[9] := ProfitPct;
            TotalAmt[10] := LineQty;
            TotalAmt[11] := TotalParcels;
            TotalAmt[12] := TotalNetWeight;
            TotalAmt[13] := TotalGrossWeight;
            TotalAmt[14] := TotalVolume;
            TotalAmt[15] := Cust."Balance (LCY)";
            TotalAmt[16] := Cust."Credit Limit (LCY)";
            TotalAmt[17] := VATpercentage;

        END ELSE BEGIN
            TotalAmt[1] := CustAmount + InvDiscAmount;
            TotalAmt[2] := InvDiscAmount;
            TotalAmt[3] := AmountInclVAT;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := CustAmount;
            TotalAmt[6] := AmountLCY;
            TotalAmt[7] := CostLCY;
            TotalAmt[8] := ProfitLCY;
            TotalAmt[9] := ProfitPct;
            TotalAmt[10] := LineQty;
            TotalAmt[11] := TotalParcels;
            TotalAmt[12] := TotalNetWeight;
            TotalAmt[13] := TotalGrossWeight;
            TotalAmt[14] := TotalVolume;
            TotalAmt[15] := Cust."Balance (LCY)";
            TotalAmt[16] := Cust."Credit Limit (LCY)";
            TotalAmt[17] := VATpercentage;
        END;

    end;
    /// <summary> 
    /// Description for SalesStatistic.
    /// </summary>
    /// <param name="DocumentType">Parameter of type Enum "Sales Document Type".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    /// <param name="VAR TotalAmt">Parameter of type ARRAY[100] OF Decimal.</param>
    /// <param name="VAR VATText">Parameter of type Text[30].</param>
    procedure SalesStatistic(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record "Customer";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        TempSalesLine: Record "Sales Line" temporary;
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        VATAmount: Decimal;
        VATAmountText: Text[30];
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAmount1: Decimal;
        TotalAmount2: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        TotalAdjCostLCY: Decimal;
        TempVATAmountLine: Record "VAT Amount Line" temporary;

    begin
        IF NOT SalesHeader.GET(DocumentType, DocumentNo) THEN
            EXIT;

        SalesSetup.GET;
        AllowInvDisc :=
        NOT (SalesSetup."Calc. Inv. Discount" AND "CustInvDiscRecExists"(SalesHeader."Invoice Disc. Code"));
        AllowVATDifference :=
        SalesSetup."Allow VAT Difference" AND
        NOT (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Quote, SalesHeader."Document Type"::"Blanket Order"]);

        CLEAR(SalesLine);
        CLEAR(TotalSalesLine);
        CLEAR(TotalSalesLineLCY);
        CLEAR(SalesPost);
        CLEAR(TotalAdjCostLCY);

        SalesPost.GetSalesLines(SalesHeader, TempSalesLine, 0);
        CLEAR(SalesPost);
        SalesPost.SumSalesLinesTemp(
        SalesHeader, TempSalesLine, 0, TotalSalesLine, TotalSalesLineLCY,
        VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        IF SalesHeader."Prices Including VAT" THEN BEGIN
            TotalAmount2 := TotalSalesLine.Amount;
            TotalAmount1 := TotalAmount2 + VATAmount;
            TotalSalesLine."Line Amount" := TotalAmount1 + TotalSalesLine."Inv. Discount Amount";
        END ELSE BEGIN
            TotalAmount1 := TotalSalesLine.Amount;
            TotalAmount2 := TotalSalesLine."Amount Including VAT";
        END;

        IF Cust.GET(SalesHeader."Bill-to Customer No.") THEN
            Cust.CALCFIELDS("Balance (LCY)")
        ELSE
            CLEAR(Cust);
        IF Cust."Credit Limit (LCY)" = 0 THEN
            CreditLimitLCYExpendedPct := 0
        ELSE
            IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0 THEN
                CreditLimitLCYExpendedPct := 0
            ELSE
                IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1 THEN
                    CreditLimitLCYExpendedPct := 10000
                ELSE
                    CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000, 1);

        SalesLine.CalcVATAmountLines(1, SalesHeader, TempSalesLine, TempVATAmountLine);
        TempVATAmountLine.MODIFYALL(Modified, FALSE);


        VATText := STRSUBSTNO(Text005, 0);
        IF VATAmount <> 0 THEN
            VATText := STRSUBSTNO(Text005, TotalSalesLine."VAT %");
        IF NOT SalesHeader."Prices Including VAT" THEN BEGIN
            TotalAmt[1] := TotalSalesLine."Line Amount";
            TotalAmt[2] := TotalSalesLine."Inv. Discount Amount";
            TotalAmt[3] := TotalAmount1;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := TotalAmount2;
            TotalAmt[6] := TotalSalesLineLCY.Amount;
            TotalAmt[7] := TotalSalesLineLCY."Unit Cost (LCY)";
            TotalAmt[8] := ProfitLCY;
            TotalAmt[9] := ProfitPct;
            TotalAmt[10] := TotalSalesLine.Quantity;
            TotalAmt[11] := TotalSalesLine."Units per Parcel";
            TotalAmt[12] := TotalSalesLine."Net Weight";
            TotalAmt[13] := TotalSalesLine."Gross Weight";
            TotalAmt[14] := TotalSalesLine."Unit Volume";
            TotalAmt[15] := Cust."Balance (LCY)";
            TotalAmt[16] := Cust."Credit Limit (LCY)";
        END ELSE BEGIN
            TotalAmt[1] := TotalSalesLine."Line Amount";
            TotalAmt[2] := TotalSalesLine."Inv. Discount Amount";
            TotalAmt[3] := TotalAmount2;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := TotalAmount1;
            TotalAmt[6] := TotalSalesLineLCY.Amount;
            TotalAmt[7] := TotalSalesLineLCY."Unit Cost (LCY)";
            TotalAmt[8] := ProfitLCY;
            TotalAmt[9] := ProfitPct;
            TotalAmt[10] := TotalSalesLine.Quantity;
            TotalAmt[11] := TotalSalesLine."Units per Parcel";
            TotalAmt[12] := TotalSalesLine."Net Weight";
            TotalAmt[13] := TotalSalesLine."Gross Weight";
            TotalAmt[14] := TotalSalesLine."Unit Volume";
            TotalAmt[15] := Cust."Balance (LCY)";
            TotalAmt[16] := Cust."Credit Limit (LCY)";
        END;
    end;

    /// <summary> 
    /// Description for SalesBillingReceiptInformation.
    /// </summary>
    /// <param name="MyText">Parameter of type array[10] of text[250].</param>
    /// <param name="DocumentType">Parameter of type Option "Sales Billing","Sales Receipt","Purchase Billing".</param>
    /// <param name="DocumentNo">Parameter of type Code[20].</param>
    procedure "SalesBillingReceiptInformation"(var MyText: array[10] of text[250]; DocumentType: Option "Sales Billing","Sales Receipt","Purchase Billing"; DocumentNo: Code[20])
    var
        BillingReceiptHeader: Record "Billing Receipt Header";
        Cust: Record Customer;
        vendor: Record Vendor;
        Tel: Text[250];
        fax: Text[250];
        VatRegis: Text[250];

    begin
        BillingReceiptHeader.GET(DocumentType, DocumentNo);
        if DocumentType = DocumentType::"Purchase Billing" then begin
            vendor.get(BillingReceiptHeader."Bill/Pay-to Cust/Vend No.");
            Tel := vendor."Phone No." + ' ';
            if Vendor."Currency Code" = '' then begin
                if vendor."Fax No." <> '' then
                    tel += 'แฟกซ์ : ' + vendor."Fax No.";
                VatRegis := BillingReceiptHeader."VAT Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (สำนักงานใหญ่)'
                else
                    VatRegis += ' (' + BillingReceiptHeader."Branch Code" + ')';
            end else begin
                if vendor."Fax No." <> '' then
                    tel += 'Fax : ' + vendor."Fax No.";
                VatRegis := BillingReceiptHeader."VAT Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (Head Office)'
                else
                    VatRegis += ' (' + BillingReceiptHeader."Branch Code" + ')';
            end;
        end else begin
            Cust.get(BillingReceiptHeader."Bill/Pay-to Cust/Vend No.");
            Tel := Cust."Phone No." + ' ';
            if Cust."Currency Code" = '' then begin
                if Cust."Fax No." <> '' then
                    tel += 'แฟกซ์ : ' + Cust."Fax No.";
                VatRegis := BillingReceiptHeader."VAT Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (สำนักงานใหญ่)'
                else
                    VatRegis += ' (' + BillingReceiptHeader."Branch Code" + ')';
            end else begin
                if Cust."Fax No." <> '' then
                    tel += 'Fax : ' + Cust."Fax No.";
                VatRegis := BillingReceiptHeader."Vat Registration No.";
                if BillingReceiptHeader."Head Office" then
                    VatRegis += ' (Head Office)'
                else
                    VatRegis += ' (' + BillingReceiptHeader."Branch Code" + ')';
            end;
        end;


        MyText[1] := BillingReceiptHeader."Bill/Pay-to Cust/Vend Name" + ' ' + BillingReceiptHeader."Bill/Pay-to Cus/Vend Name2";
        MyText[2] := BillingReceiptHeader."Bill/Pay-to Address" + ' ';
        MyText[3] := BillingReceiptHeader."Bill/Pay-to Address 2" + ' ';
        MyText[3] += BillingReceiptHeader."Bill/Pay-to City" + ' ' + BillingReceiptHeader."Bill/Pay-to Post Code";
        MyText[4] := Tel;
        MyText[5] := BillingReceiptHeader."Bill/Pay-to Contact";
        MyText[9] := BillingReceiptHeader."Bill/Pay-to Cust/Vend No.";
        MyText[10] := VatRegis;


    end;

    procedure "PurchStatistic"(DocumentType: Enum "Purchase Document Type"; DocumentNo: Code[20]; VAR TotalAmt: ARRAY[100] OF Decimal; VAR VATText: Text[30])
    var
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        PurchSetup: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Vend: Record "Vendor";
        TempPurchLine: Record "Purchase Line" temporary;
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        PurchPost: Codeunit "Purch.-Post";
        VATAmount: Decimal;
        VATAmountText: Text[30];
        TotalAmount1: Decimal;
        TotalAmount2: Decimal;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
    begin
        IF NOT PurchHeader.GET(DocumentType, DocumentNo) THEN
            EXIT;

        PurchSetup.GET;
        AllowInvDisc :=
        NOT (PurchSetup."Calc. Inv. Discount" AND "VendInvDiscRecExists"(PurchHeader."Invoice Disc. Code"));
        AllowVATDifference :=
        PurchSetup."Allow VAT Difference" AND
        NOT (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Quote, PurchHeader."Document Type"::"Blanket Order"]);

        CLEAR(PurchLine);
        CLEAR(TotalPurchLine);
        CLEAR(TotalPurchLineLCY);
        CLEAR(PurchPost);

        PurchPost.GetPurchLines(PurchHeader, TempPurchLine, 0);
        CLEAR(PurchPost);
        PurchPost.SumPurchLinesTemp(
        PurchHeader, TempPurchLine, 0, TotalPurchLine, TotalPurchLineLCY, VATAmount, VATAmountText);

        IF PurchHeader."Prices Including VAT" THEN BEGIN
            TotalAmount2 := TotalPurchLine.Amount;
            TotalAmount1 := TotalAmount2 + VATAmount;
            TotalPurchLine."Line Amount" := TotalAmount1 + TotalPurchLine."Inv. Discount Amount";
        END ELSE BEGIN
            TotalAmount1 := TotalPurchLine.Amount;
            TotalAmount2 := TotalPurchLine."Amount Including VAT";
        END;

        IF Vend.GET(PurchHeader."Pay-to Vendor No.") THEN
            Vend.CALCFIELDS("Balance (LCY)")
        ELSE
            CLEAR(Vend);

        PurchLine.CalcVATAmountLines(1, PurchHeader, TempPurchLine, TempVATAmountLine);
        TempVATAmountLine.MODIFYALL(Modified, FALSE);

        VATText := STRSUBSTNO(Text005, 0);
        IF VATAmount <> 0 THEN
            VATText := STRSUBSTNO(Text005, TotalPurchLine."VAT %");

        IF NOT PurchHeader."Prices Including VAT" THEN BEGIN
            TotalAmt[1] := TotalPurchLine."Line Amount";
            TotalAmt[2] := TotalPurchLine."Inv. Discount Amount";
            TotalAmt[3] := TotalAmount1;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := TotalAmount2;
            TotalAmt[6] := TotalPurchLineLCY.Amount;
            TotalAmt[7] := TotalPurchLine.Quantity;
            TotalAmt[8] := TotalPurchLine."Units per Parcel";
            TotalAmt[9] := TotalPurchLine."Net Weight";
            TotalAmt[10] := TotalPurchLine."Gross Weight";
            TotalAmt[11] := TotalPurchLine."Unit Volume";
            TotalAmt[12] := Vend."Balance (LCY)";
        END ELSE BEGIN
            TotalAmt[1] := TotalPurchLine."Line Amount";
            TotalAmt[2] := TotalPurchLine."Inv. Discount Amount";
            TotalAmt[3] := TotalAmount2;
            TotalAmt[4] := VATAmount;
            TotalAmt[5] := TotalAmount1;
            TotalAmt[6] := TotalPurchLineLCY.Amount;
            TotalAmt[7] := TotalPurchLine.Quantity;
            TotalAmt[8] := TotalPurchLine."Units per Parcel";
            TotalAmt[9] := TotalPurchLine."Net Weight";
            TotalAmt[10] := TotalPurchLine."Gross Weight";
            TotalAmt[11] := TotalPurchLine."Unit Volume";
            TotalAmt[12] := Vend."Balance (LCY)";

        END;

    end;

    procedure "GetSalesComment"(DocumentType: Enum "Sales Comment Document Type"; DocumentNo: Code[30]; LineNo: Integer; var SalesComment: array[100] of text[250])
    var
        SalesCommentLine: Record "Sales Comment Line";
        i: Integer;

    begin
        i := 0;
        SalesCommentLine.RESET;
        SalesCommentLine.SETRANGE("Document Type", DocumentType);
        SalesCommentLine.SETRANGE("No.", DocumentNo);
        SalesCommentLine.SetRange("Document Line No.", LineNo);
        SalesCommentLine.SETFILTER(Comment, '<>%1', '');
        IF SalesCommentLine.FINDSET THEN
            REPEAT
                i += 1;
                SalesComment[i] := SalesCommentLine.Comment;
            UNTIL SalesCommentLine.NEXT = 0;


    end;

    procedure "GetPurchaseComment"(DocumentType: Enum "Purchase Comment Document Type"; DocumentNo: Code[30]; LineNo: Integer; var PurchCommentLine: array[100] of text[250])
    var
        PurchaseCommentLine: Record "Purch. Comment Line";
        i: Integer;
    begin
        i := 0;
        PurchaseCommentLine.RESET;
        PurchaseCommentLine.SETRANGE("Document Type", DocumentType);
        PurchaseCommentLine.SETRANGE("No.", DocumentNo);
        PurchaseCommentLine.SetRange("Document Line No.", LineNo);
        PurchaseCommentLine.SETFILTER(Comment, '<>%1', '');
        IF PurchaseCommentLine.FINDSET THEN
            REPEAT
                i += 1;
                PurchCommentLine[i] := PurchaseCommentLine.Comment;
            UNTIL PurchaseCommentLine.NEXT = 0;

    end;

    procedure "PurchasePostedVendorInformation"(DocumentType: Option Receipt,"Return Shipment","Posted Invoice","Posted Credit Memo"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        Vend: Record Vendor;
        CUst: Record Customer;
        ReturnShptHeader: Record "Return Shipment Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        VendBranch: Record "Customer & Vendor Branch";
    begin
        CASE DocumentType OF
            DocumentType::Receipt:
                BEGIN
                    PurchRcptHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                // if PurchRcptHeader."Head Office" then begin
                                IF NOT Vend.GET(PurchRcptHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := PurchRcptHeader."Buy-from Vendor Name" + ' ' + PurchRcptHeader."Buy-from Vendor Name 2";
                                Text[2] := PurchRcptHeader."Buy-from Address" + ' ';
                                Text[3] := PurchRcptHeader."Buy-from Address 2" + ' ';
                                Text[3] += PurchRcptHeader."Buy-from City" + ' ' + PurchRcptHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchRcptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := PurchRcptHeader."Buy-from Contact";

                                //end else begin
                                if (PurchRcptHeader."Branch Code" <> '') AND (NOT PurchRcptHeader."Head Office") then begin
                                    if not VendBranch.GET(VendBranch."Source Type"::Vendor, PurchRcptHeader."Buy-from Vendor No.", PurchRcptHeader."Head Office", PurchRcptHeader."Branch Code") then
                                        VendBranch.Init();
                                    Text[1] := VendBranch."Name";
                                    Text[2] := VendBranch."Address";
                                    Text[3] := VendBranch."Province" + ' ' + VendBranch."Post Code";
                                    Text[4] := VendBranch."Phone No." + ' ';
                                    if PurchRcptHeader."Currency Code" = '' then begin
                                        IF VendBranch."Fax No." <> '' THEN
                                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', VendBranch."Fax No.");
                                    end else begin
                                        IF VendBranch."Fax No." <> '' THEN
                                            Text[4] += STRSUBSTNO('Fax. : %1', VendBranch."Fax No.");
                                    end;

                                end;
                                Text[9] := PurchRcptHeader."Buy-from Vendor No.";
                            end;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(PurchRcptHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := PurchRcptHeader."Pay-to Name" + ' ' + PurchRcptHeader."Pay-to Name 2";
                                Text[2] := PurchRcptHeader."Pay-to Address" + ' ';
                                Text[3] := PurchRcptHeader."Pay-to Address 2" + ' ';
                                Text[3] += PurchRcptHeader."Pay-to City" + ' ' + PurchRcptHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchRcptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := PurchRcptHeader."Pay-to Contact";
                                Text[9] := PurchRcptHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(PurchRcptHeader."Sell-to Customer No.") THEN
                                    Cust.init;
                                Text[1] := PurchRcptHeader."Ship-to Name" + ' ' + PurchRcptHeader."Ship-to Name 2";
                                Text[2] := PurchRcptHeader."Ship-to Address" + ' ';
                                Text[3] := PurchRcptHeader."Ship-to Address 2" + ' ';
                                Text[3] += PurchRcptHeader."Ship-to City" + ' ' + PurchRcptHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if PurchRcptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := PurchRcptHeader."Ship-to Contact";

                            END;
                    end;

                    //  if PurchRcptHeader."Head Office" then
                    Text[10] := PurchRcptHeader."VAT Registration No.";
                    if (PurchRcptHeader."Branch Code" <> '') AND (NOT PurchRcptHeader."Head Office") then begin
                        if not VendBranch.GET(VendBranch."Source Type"::Vendor, PurchRcptHeader."Buy-from Vendor No.", PurchRcptHeader."Head Office", PurchRcptHeader."Branch Code") then
                            VendBranch.Init();
                        Text[10] := VendBranch."VAT Registration No.";
                    end;
                    if PurchRcptHeader."Currency Code" = '' then begin
                        if PurchRcptHeader."Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            Text[10] += ' (' + PurchRcptHeader."Branch Code" + ')';
                    end else begin
                        if PurchRcptHeader."Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            Text[10] += ' (' + PurchRcptHeader."Branch Code" + ')';
                    END;
                END;
            DocumentType::"Return Shipment":
                BEGIN
                    ReturnShptHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Vend.GET(ReturnShptHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := ReturnShptHeader."Buy-from Vendor Name" + ' ' + ReturnShptHeader."Buy-from Vendor Name 2";
                                Text[2] := ReturnShptHeader."Buy-from Address" + ' ';
                                Text[3] := ReturnShptHeader."Buy-from Address 2" + ' ';
                                Text[3] += ReturnShptHeader."Buy-from City" + ' ' + ReturnShptHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if ReturnShptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := ReturnShptHeader."Buy-from Contact";
                                Text[9] := ReturnShptHeader."Buy-from Vendor No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(ReturnShptHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := ReturnShptHeader."Pay-to Name" + ' ' + ReturnShptHeader."Pay-to Name 2";
                                Text[2] := ReturnShptHeader."Pay-to Address" + ' ';
                                Text[3] := ReturnShptHeader."Pay-to Address 2" + ' ';
                                Text[3] += ReturnShptHeader."Pay-to City" + ' ' + ReturnShptHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if ReturnShptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := ReturnShptHeader."Pay-to Contact";
                                Text[9] := ReturnShptHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(ReturnShptHeader."Sell-to Customer No.") THEN
                                    Cust.init;
                                Text[1] := ReturnShptHeader."Ship-to Name" + ' ' + ReturnShptHeader."Ship-to Name 2";
                                Text[2] := ReturnShptHeader."Ship-to Address" + ' ';
                                Text[3] := ReturnShptHeader."Ship-to Address 2" + ' ';
                                Text[3] += ReturnShptHeader."Ship-to City" + ' ' + ReturnShptHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if ReturnShptHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := ReturnShptHeader."Ship-to Contact";

                            END;
                    end;
                END;
            DocumentType::"Posted Invoice":
                BEGIN
                    PurchInvHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Vend.GET(PurchInvHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := PurchInvHeader."Buy-from Vendor Name" + ' ' + PurchInvHeader."Buy-from Vendor Name 2";
                                Text[2] := PurchInvHeader."Buy-from Address" + ' ';
                                Text[3] := PurchInvHeader."Buy-from Address 2" + ' ';
                                Text[3] += PurchInvHeader."Buy-from City" + ' ' + PurchInvHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchInvHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := PurchInvHeader."Buy-from Contact";
                                Text[9] := PurchInvHeader."Buy-from Vendor No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(PurchInvHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := PurchInvHeader."Pay-to Name" + ' ' + PurchInvHeader."Pay-to Name 2";
                                Text[2] := PurchInvHeader."Pay-to Address" + ' ';
                                Text[3] := PurchInvHeader."Pay-to Address 2" + ' ';
                                Text[3] += PurchInvHeader."Pay-to City" + ' ' + PurchInvHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchInvHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := PurchInvHeader."Pay-to Contact";
                                Text[9] := PurchInvHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(PurchInvHeader."Sell-to Customer No.") THEN
                                    Cust.init;
                                Text[1] := PurchInvHeader."Ship-to Name" + ' ' + PurchInvHeader."Ship-to Name 2";
                                Text[2] := PurchInvHeader."Ship-to Address" + ' ';
                                Text[3] := PurchInvHeader."Ship-to Address 2" + ' ';
                                Text[3] += PurchInvHeader."Ship-to City" + ' ' + PurchInvHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if PurchInvHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := PurchInvHeader."Ship-to Contact";

                            END;
                    end;
                END;
            DocumentType::"Posted Credit Memo":
                BEGIN
                    PurchCrMemoHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Vend.GET(PurchCrMemoHeader."Buy-from Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := PurchCrMemoHeader."Buy-from Vendor Name" + ' ' + PurchCrMemoHeader."Buy-from Vendor Name 2";
                                Text[2] := PurchCrMemoHeader."Buy-from Address" + ' ';
                                Text[3] := PurchCrMemoHeader."Buy-from Address 2" + ' ';
                                Text[3] += PurchCrMemoHeader."Buy-from City" + ' ' + PurchCrMemoHeader."Buy-from Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchCrMemoHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := PurchCrMemoHeader."Buy-from Contact";
                                Text[9] := PurchCrMemoHeader."Buy-from Vendor No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Vend.GET(PurchCrMemoHeader."Pay-to Vendor No.") THEN
                                    Vend.INIT;
                                Text[1] := PurchCrMemoHeader."Pay-to Name" + ' ' + PurchCrMemoHeader."Pay-to Name 2";
                                Text[2] := PurchCrMemoHeader."Pay-to Address" + ' ';
                                Text[3] := PurchCrMemoHeader."Pay-to Address 2" + ' ';
                                Text[3] += PurchCrMemoHeader."Pay-to City" + ' ' + PurchCrMemoHeader."Pay-to Post Code";
                                Text[4] := Vend."Phone No." + ' ';
                                if PurchCrMemoHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Vend."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Vend."Fax No.");

                                end;
                                Text[5] := PurchCrMemoHeader."Pay-to Contact";
                                Text[9] := PurchCrMemoHeader."Pay-to Vendor No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Cust.GET(PurchCrMemoHeader."Sell-to Customer No.") THEN
                                    Cust.init;
                                Text[1] := PurchCrMemoHeader."Ship-to Name" + ' ' + PurchCrMemoHeader."Ship-to Name 2";
                                Text[2] := PurchCrMemoHeader."Ship-to Address" + ' ';
                                Text[3] := PurchCrMemoHeader."Ship-to Address 2" + ' ';
                                Text[3] += PurchCrMemoHeader."Ship-to City" + ' ' + PurchCrMemoHeader."Ship-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if PurchCrMemoHeader."Currency Code" = '' then begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Vend."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := PurchCrMemoHeader."Ship-to Contact";

                            END;
                    END;

                end;

        END;
    end;


    procedure SalesPostedCustomerInformation(DocumentType: Option Shipment,"Return Receipt","Posted Invoice","Posted Credit Memo"; DocumentNo: Code[20]; VAR Text: ARRAY[10] OF Text[250]; Tab: Option General,Invoicing,Shipping)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Shipto: Record "Ship-to Address";
        Cust: Record Customer;
        CustBranch: Record "Customer & Vendor Branch";

    begin

        CASE DocumentType OF
            DocumentType::Shipment:
                BEGIN
                    SalesShptHeader.GET(DocumentNo);
                    CASE Tab OF

                        Tab::General:
                            BEGIN
                                //  if SalesShptHeader."Head Office" then begin
                                IF NOT Cust.GET(SalesShptHeader."Sell-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := SalesShptHeader."Sell-to Customer Name" + ' ' + SalesShptHeader."Sell-to Customer Name 2";
                                Text[2] := SalesShptHeader."Sell-to Address" + ' ';
                                Text[3] := SalesShptHeader."Sell-to Address 2" + ' ';
                                Text[3] += SalesShptHeader."Sell-to City" + ' ' + SalesShptHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesShptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := SalesShptHeader."Sell-to Contact";

                                if (SalesShptHeader."Branch Code" <> '') AND (NOT SalesShptHeader."Head Office") then begin
                                    if not CustBranch.GET(CustBranch."Source Type"::customer, SalesShptHeader."Sell-to Customer No.", SalesShptHeader."Head Office", SalesShptHeader."Branch Code") then
                                        CustBranch.Init();
                                    Text[1] := CustBranch."Name";
                                    Text[2] := CustBranch."Address";
                                    Text[3] := CustBranch."Province" + ' ' + CustBranch."Post Code";
                                    Text[4] := CustBranch."Phone No." + ' ';
                                    if SalesShptHeader."Currency Code" = '' then begin
                                        IF CustBranch."Fax No." <> '' THEN
                                            Text[4] += STRSUBSTNO('แฟกซ์ : %1', CustBranch."Fax No.");
                                    end else begin
                                        IF CustBranch."Fax No." <> '' THEN
                                            Text[4] += STRSUBSTNO('Fax. : %1', CustBranch."Fax No.");
                                    end;

                                end;

                                Text[9] := SalesShptHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(SalesShptHeader."Bill-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := SalesShptHeader."Bill-to Name" + ' ' + SalesShptHeader."Bill-to Name 2";
                                Text[2] := SalesShptHeader."Bill-to Address" + ' ';
                                Text[3] := SalesShptHeader."Bill-to Address 2" + ' ';
                                Text[3] += SalesShptHeader."Bill-to City" + ' ' + SalesShptHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesShptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := SalesShptHeader."Bill-to Contact";
                                Text[9] := SalesShptHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(SalesShptHeader."Sell-to Customer No.", SalesShptHeader."Ship-to Code") THEN
                                    Shipto.INIT;

                                Text[1] := SalesShptHeader."Ship-to Name" + ' ' + SalesShptHeader."Ship-to Name 2";
                                Text[2] := SalesShptHeader."Ship-to Address" + ' ';
                                Text[3] := SalesShptHeader."Ship-to Address 2" + ' ';
                                Text[3] += SalesShptHeader."Ship-to City" + ' ' + SalesShptHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if SalesShptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");

                                end;
                                Text[5] := SalesShptHeader."Ship-to Contact";

                            END;
                    end;
                    //  if SalesShptHeader."Head Office" then
                    Text[10] := SalesShptHeader."VAT Registration No.";
                    if (SalesShptHeader."Branch Code" <> '') AND (NOT SalesShptHeader."Head Office") then begin
                        if not CustBranch.GET(CustBranch."Source Type"::customer, SalesShptHeader."Sell-to Customer No.", SalesShptHeader."Head Office", SalesShptHeader."Branch Code") then
                            CustBranch.Init();
                        Text[10] := CustBranch."VAT Registration No.";
                    end;
                    if SalesShptHeader."Currency Code" = '' then begin
                        if SalesShptHeader."Head Office" then
                            Text[10] += ' (สำนักงานใหญ่)'
                        else
                            Text[10] += ' (' + SalesShptHeader."Branch Code" + ')';
                    end else begin
                        if SalesShptHeader."Head Office" then
                            Text[10] += ' (Head Office)'
                        else
                            Text[10] += ' (' + SalesShptHeader."Branch Code" + ')';
                    END;
                end;
            DocumentType::"Return Receipt":
                BEGIN
                    ReturnRcptHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Cust.GET(ReturnRcptHeader."Sell-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := ReturnRcptHeader."Sell-to Customer Name" + ' ' + ReturnRcptHeader."Sell-to Customer Name 2";
                                Text[2] := ReturnRcptHeader."Sell-to Address" + ' ';
                                Text[3] := ReturnRcptHeader."Sell-to Address 2" + ' ';
                                Text[3] += ReturnRcptHeader."Sell-to City" + ' ' + ReturnRcptHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if ReturnRcptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := ReturnRcptHeader."Sell-to Contact";
                                Text[9] := ReturnRcptHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(ReturnRcptHeader."Bill-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := ReturnRcptHeader."Bill-to Name" + ' ' + ReturnRcptHeader."Bill-to Name 2";
                                Text[2] := ReturnRcptHeader."Bill-to Address" + ' ';
                                Text[3] := ReturnRcptHeader."Bill-to Address 2" + ' ';
                                Text[3] += ReturnRcptHeader."Bill-to City" + ' ' + ReturnRcptHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if ReturnRcptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := ReturnRcptHeader."Bill-to Contact";
                                Text[9] := ReturnRcptHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(ReturnRcptHeader."Sell-to Customer No.", ReturnRcptHeader."Ship-to Code") THEN
                                    Shipto.INIT;

                                Text[1] := ReturnRcptHeader."Ship-to Name" + ' ' + ReturnRcptHeader."Ship-to Name 2";
                                Text[2] := ReturnRcptHeader."Ship-to Address" + ' ';
                                Text[3] := ReturnRcptHeader."Ship-to Address 2" + ' ';
                                Text[3] += ReturnRcptHeader."Ship-to City" + ' ' + ReturnRcptHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if ReturnRcptHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");

                                end;
                                Text[5] := ReturnRcptHeader."Ship-to Contact";

                            END;
                    end;
                end;
            DocumentType::"Posted Invoice":
                BEGIN
                    SalesInvHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Cust.GET(SalesInvHeader."Sell-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := SalesInvHeader."Sell-to Customer Name" + ' ' + SalesInvHeader."Sell-to Customer Name 2";
                                Text[2] := SalesInvHeader."Sell-to Address" + ' ';
                                Text[3] := SalesInvHeader."Sell-to Address 2" + ' ';
                                Text[3] += SalesInvHeader."Sell-to City" + ' ' + SalesInvHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesInvHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := SalesInvHeader."Sell-to Contact";
                                Text[9] := SalesInvHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(SalesInvHeader."Bill-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := SalesInvHeader."Bill-to Name" + ' ' + SalesInvHeader."Bill-to Name 2";
                                Text[2] := SalesInvHeader."Bill-to Address" + ' ';
                                Text[3] := SalesInvHeader."Bill-to Address 2" + ' ';
                                Text[3] += SalesInvHeader."Bill-to City" + ' ' + SalesInvHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesInvHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := SalesInvHeader."Bill-to Contact";
                                Text[9] := SalesInvHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(SalesInvHeader."Sell-to Customer No.", SalesInvHeader."Ship-to Code") THEN
                                    Shipto.INIT;

                                Text[1] := SalesInvHeader."Ship-to Name" + ' ' + SalesInvHeader."Ship-to Name 2";
                                Text[2] := SalesInvHeader."Ship-to Address" + ' ';
                                Text[3] := SalesInvHeader."Ship-to Address 2" + ' ';
                                Text[3] += SalesInvHeader."Ship-to City" + ' ' + SalesInvHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if SalesInvHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");

                                end;
                                Text[5] := SalesInvHeader."Ship-to Contact";

                            END;
                    end;
                end;
            DocumentType::"Posted Credit Memo":
                BEGIN
                    SalesCrMemoHeader.GET(DocumentNo);
                    CASE Tab OF
                        Tab::General:
                            BEGIN
                                IF NOT Cust.GET(SalesCrMemoHeader."Sell-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := SalesCrMemoHeader."Sell-to Customer Name" + ' ' + SalesCrMemoHeader."Sell-to Customer Name 2";
                                Text[2] := SalesCrMemoHeader."Sell-to Address" + ' ';
                                Text[3] := SalesCrMemoHeader."Sell-to Address 2" + ' ';
                                Text[3] += SalesCrMemoHeader."Sell-to City" + ' ' + SalesCrMemoHeader."Sell-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesCrMemoHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := SalesCrMemoHeader."Sell-to Contact";
                                Text[9] := SalesCrMemoHeader."Sell-to Customer No.";
                            END;
                        Tab::Invoicing:
                            BEGIN
                                IF NOT Cust.GET(SalesCrMemoHeader."Bill-to Customer No.") THEN
                                    Cust.INIT;
                                Text[1] := SalesCrMemoHeader."Bill-to Name" + ' ' + SalesCrMemoHeader."Bill-to Name 2";
                                Text[2] := SalesCrMemoHeader."Bill-to Address" + ' ';
                                Text[3] := SalesCrMemoHeader."Bill-to Address 2" + ' ';
                                Text[3] += SalesCrMemoHeader."Bill-to City" + ' ' + SalesCrMemoHeader."Bill-to Post Code";
                                Text[4] := Cust."Phone No." + ' ';
                                if SalesCrMemoHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Cust."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Cust."Fax No.");

                                end;
                                Text[5] := SalesCrMemoHeader."Bill-to Contact";
                                Text[9] := SalesCrMemoHeader."Bill-to Customer No.";
                            END;
                        Tab::Shipping:
                            BEGIN
                                IF NOT Shipto.GET(SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."Ship-to Code") THEN
                                    Shipto.INIT;

                                Text[1] := SalesCrMemoHeader."Ship-to Name" + ' ' + SalesCrMemoHeader."Ship-to Name 2";
                                Text[2] := SalesCrMemoHeader."Ship-to Address" + ' ';
                                Text[3] := SalesCrMemoHeader."Ship-to Address 2" + ' ';
                                Text[3] += SalesCrMemoHeader."Ship-to City" + ' ' + SalesCrMemoHeader."Ship-to Post Code";
                                Text[4] := Shipto."Phone No." + ' ';
                                if SalesCrMemoHeader."Currency Code" = '' then begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('แฟกซ์ : %1', Shipto."Fax No.");

                                end else begin

                                    IF Cust."Fax No." <> '' THEN
                                        Text[4] += STRSUBSTNO('Fax. : %1', Shipto."Fax No.");

                                end;
                                Text[5] := SalesCrMemoHeader."Ship-to Contact";

                            END;
                    end;
                end;
        end;


    end;

    /// <summary> 
    /// Description for GetSignature.
    /// </summary>
    /// <param name="DocumentType">Parameter of type Integer.</param>
    /// <param name="DocNo">Parameter of type Code[30].</param>
    /// <param name="MyStorage">Parameter of type array[10] of Record "Image Storage" temporary.</param>
    procedure "GetSignature"(DocumentType: Integer; DocNo: Code[30]; var MyStorage: array[10] of Record "Image Storage" temporary)
    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        LineNO: Integer;
    begin
        Clear(MyStorage);
        ApprovalEntry.reset;
        ApprovalEntry.SetRange("Document Type", DocumentType);
        ApprovalEntry.SetRange("Document No.", DocNo);
        if ApprovalEntry.FindFirst() then begin
            UserSetup.reset;
            UserSetup.SetRange("User ID", ApprovalEntry."Sender ID");
            if UserSetup.FindFirst() then begin
                UserSetup.CalcFields("Signature");
                if UserSetup."Signature".HasValue then begin
                    LineNO += 1;
                    MyStorage[1]."Line No." := LineNO;
                    MyStorage[1]."Type" := MyStorage[1]."Type"::IMAGE;
                    MyStorage[1]."No." := DocNo;
                    MyStorage[1]."Image" := UserSetup."Signature";
                    MyStorage[1]."Date Time" := ApprovalEntry."Last Date-Time Modified";
                    MyStorage[1].Insert();
                end;
            end;
        end;
        LineNO := 1;
        ApprovalEntry.reset;
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document Type", DocumentType);
        ApprovalEntry.SetRange("Document No.", DocNo);
        ApprovalEntry.SetFilter("Pending Approvals", '<>%1', 0);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindFirst() then begin
            repeat
                UserSetup.reset;
                UserSetup.SetRange("User ID", ApprovalEntry."Approver ID");
                if UserSetup.FindFirst() then begin
                    UserSetup.CalcFields("Signature");
                    if UserSetup."Signature".HasValue then begin
                        LineNO += 1;
                        MyStorage[LineNO]."Line No." := LineNO;
                        MyStorage[LineNO]."Type" := MyStorage[LineNO]."Type"::IMAGE;
                        MyStorage[LineNO]."No." := DocNo;
                        MyStorage[LineNO]."Image" := UserSetup."Signature";
                        MyStorage[LineNO]."Date Time" := ApprovalEntry."Last Date-Time Modified";
                        MyStorage[LineNO].Insert();
                    end;
                end;
            until ApprovalEntry.next = 0;
        end;

        LineNO := 0;
        ApprovalEntry.reset;
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document Type", DocumentType);
        ApprovalEntry.SetRange("Document No.", DocNo);
        ApprovalEntry.SetFilter("Pending Approvals", '%1', 0);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindLast() then begin
            UserSetup.reset;
            UserSetup.SetRange("User ID", ApprovalEntry."Approver ID");
            if UserSetup.FindFirst() then begin
                UserSetup.CalcFields("Signature");
                if UserSetup."Signature".HasValue then begin
                    LineNO += 1;
                    MyStorage[10]."Line No." := LineNO;
                    MyStorage[10]."Type" := MyStorage[10]."Type"::IMAGE;
                    MyStorage[10]."No." := DocNo;
                    MyStorage[10]."Image" := UserSetup."Signature";
                    MyStorage[10]."Date Time" := ApprovalEntry."Last Date-Time Modified";
                    MyStorage[10].Insert();
                end;
            end;
        end;



    end;

    procedure "GetName"(VAR Var_Name: Text[250]) Name: Text[250]
    var
        Pos: Integer;
    begin
        Name := Var_Name;
        Pos := STRPOS(Name, '\');
        WHILE Pos > 0 DO BEGIN
            Name := COPYSTR(Name, Pos + 1);
            Pos := STRPOS(Name, '\')
        END;
    end;

    procedure "GetNameFAClass"(pCode: Code[10]): Text[50]
    var
        FaClass: Record "FA Class";
    begin
        IF FAClass.GET(pCode) THEN
            EXIT(FAClass.Name)
        ELSE
            EXIT('*****');
    end;

    procedure "GetNameFASubClass"(pCode: Code[10]): Text[50]
    var
        FASubclass: Record "FA Subclass";
    begin
        IF FASubclass.GET(pCode) THEN
            EXIT(FASubclass.Name)
        ELSE
            EXIT('*****');
    end;

    procedure "GetNameFALocation"(pCode: Code[10]): Text[50]
    var
        FALocation: Record "FA Location";
    begin
        IF FALocation.GET(pCode) THEN
            EXIT(FALocation.Name)
        ELSE
            EXIT('*****');
    end;

    local procedure "CustInvDiscRecExists"(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SETRANGE(Code, InvDiscCode);
        EXIT(CustInvDisc.FindFirst());
    end;

    local procedure "VendInvDiscRecExists"(InvDiscCode: Code[20]): Boolean
    var
        VendInvDisc: Record "Vendor Invoice Disc.";
    begin
        VendInvDisc.SETRANGE(Code, InvDiscCode);
        EXIT(VendInvDisc.FindFirst());
    end;


    /// <summary> 
    /// Description for InsertDimensionEntry.
    /// </summary>
    /// <param name="DimensionSetID">Parameter of type Integer.</param>
    procedure "InsertDimensionEntry"(var DimensionSetID: Integer; DimCode: code[30]; Dimvalue: code[30])
    var
        DimMgt: Codeunit DimensionManagement;
        DimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(DimSetEntry, DimensionSetID);
        IF NOT DimSetEntry.GET(DimensionSetID, DimCode) then begin
            DimSetEntry.init;
            DimSetEntry."Dimension Set ID" := DimensionSetID;
            DimSetEntry.validate("Dimension Code", DimCode);
            DimSetEntry.Insert(true);
            DimSetEntry.Validate("Dimension Value Code", Dimvalue);
            DimSetEntry.Modify();
        end else begin
            if DimCode <> '' then begin
                DimSetEntry.Validate("Dimension Value Code", Dimvalue);
                DimSetEntry.Modify();
            end else
                DimSetEntry.Delete();
        end;
        DimSetEntry.reset;
        DimensionSetID := DimSetEntry.GetDimensionSetID(DimSetEntry);

    end;

    procedure "SaveDimensionDefault"(TableID: Integer; MyNo: Code[30]; DimCode: Code[30]; DimValue: Code[30])
    var
        DimensionDefault: record "Default Dimension";
    begin
        if NOT DimensionDefault.GET(TableID, MyNo, DimCode) then begin
            DimensionDefault.init;
            DimensionDefault.validate("Table ID", TableID);
            DimensionDefault.Validate("No.", MyNo);
            DimensionDefault.Validate("Dimension Code", DimCode);
            DimensionDefault.Insert(true);
            DimensionDefault.Validate("Dimension Value Code", DimValue);
            DimensionDefault.Modify();
        end else begin
            if DimValue <> '' then begin
                DimensionDefault.Validate("Dimension Value Code", DimValue);
                DimensionDefault.Modify();
            end else begin
                DimensionDefault.Delete();
            end;
        end;
    end;

    procedure "GetMonthNameEng"(MonthNumber: Integer): Text[50];
    begin
        case MonthNumber of
            1:
                exit('Jan');
            2:
                exit('Feb');
            3:
                exit('Mar');
            4:
                exit('Apr');
            5:
                exit('May');
            6:
                exit('Jun');
            7:
                exit('Jul');
            8:
                exit('Aug');
            9:
                exit('Sep');
            10:
                exit('Oct');
            11:
                exit('Nov');
            12:
                exit('Dec');
            else
                exit('');
        end;
    end;

    procedure "GetMonthFullNameEng"(MonthNumber: Integer): Text[50];
    begin
        case MonthNumber of
            1:
                exit('January');
            2:
                exit('February');
            3:
                exit('March');
            4:
                exit('April');
            5:
                exit('May');
            6:
                exit('June');
            7:
                exit('July');
            8:
                exit('August');
            9:
                exit('September');
            10:
                exit('October');
            11:
                exit('November');
            12:
                exit('December');
            else
                exit('');
        end;
    end;

    procedure "GetCustBranchDate"(PCustNo: Code[20]; PCustBranch: Code[20]; var PCustInfo: array[10] of Text[250])
    var
        LRecCust: Record Customer;
        LRecCustBranch: Record "Customer & Vendor Branch";
    begin
        Clear(LRecCust);
        LRecCust.reset;
        if LRecCust.Get(PCustNo) then begin
            PCustInfo[1] := LRecCust."No.";
            PCustInfo[2] := LRecCust.Name + LRecCust."Name 2";
            PCustInfo[3] := LRecCust.Address + LRecCust."Address 2" + ' ' + LRecCust.City + LRecCust."Post Code";
            PCustInfo[4] := 'โทร : ' + LRecCust."Phone No.";
            PCustInfo[5] := 'แฟกซ์ : ' + LRecCust."Fax No.";
            PCustInfo[6] := 'เลขประจำตัวผู้เสียภาษี : ' + LRecCust."VAT Registration No.";
            PCustInfo[7] := '(สำนักงานใหญ่)';
        end;
    end;




    procedure "RereleaseBilling"(BillingHeader: Record "Billing Receipt Header")
    begin
        IF BillingHeader."Status" = BillingHeader."Status"::Released THEN
            EXIT;

        BillingHeader.TESTFIELD("Bill/Pay-to Cust/Vend No.");

        BillingLine.RESET;
        BillingLine.SETRANGE("Document Type", BillingHeader."Document Type");
        BillingLine.SETRANGE("Document No.", BillingHeader."No.");
        IF NOT BillingLine.FindFirst() THEN
            ERROR(Text001, BillingHeader."Document Type", BillingHeader."No.");

        BillingHeader."Status" := BillingHeader."Status"::Released;
        BillingHeader.MODIFY;
    end;

    procedure "ReopenBilling"(BillingHeader: Record "Billing Receipt Header")
    begin
        //  WITH BillingHeader DO BEGIN
        IF BillingHeader."Status" = BillingHeader."Status"::Open THEN
            EXIT;
        BillingHeader."Status" := BillingHeader."Status"::Open;
        BillingHeader.MODIFY;
        //   END;
    end;

    var
        BillingLine: Record "Billing Receipt Line";
        Text001: Label 'There is nothing to release for %1 %2.';

        Text005: Label 'VAT %1%', MaxLength = 1024, Locked = true;
        OnesText: array[20] of text[50];
        TensText: array[10] of Text[50];
        ExponentText: array[5] of text[50];
        TempCurrencyPoint: array[20] of Text[20];
        TempCurrencyPointInterger: array[20] of Integer;

}