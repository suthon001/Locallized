report 50048 "Payment Cheque"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_50048_PaymentCheque.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.") where("Require Screen Detail" = filter('CHEQUE'));
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Document No.";
            column(var_ChequeAmount; var_ChequeAmount)
            {
            }
            column(var_ChequeAmountTextENG; var_ChequeAmountText)
            {
            }
            column(CQChequeNo_GenJournalLine; "Gen. Journal Line"."Cheque No.")
            {
            }
            column(DocumentNo_GenJournalLine; "Gen. Journal Line"."Document No.")
            {
            }
            column(var_DateInCheque; var_DateInCheque)
            {
            }
            column(var_Payto; Payto)
            {
            }
            column(var_ShowPayee; var_ShowPayee)
            {
            }
            column(D1; varDateInChequeDay[1])
            {
            }
            column(D2; varDateInChequeDay[2])
            {
            }
            column(M1; varDateInChequeMonth[1])
            {
            }
            column(M2; varDateInChequeMonth[2])
            {
            }
            column(Y1; varDateInChequeYear[1])
            {
            }
            column(Y2; varDateInChequeYear[2])
            {
            }
            column(Y3; varDateInChequeYear[3])
            {
            }
            column(Y4; varDateInChequeYear[4])
            {
            }
            column(ChequeFormatOfBank; ChequeFormatOfBank)
            {
            }
            column(var_ACPayee; "var_A/CPayee")
            {
            }
            column(Var_CO; Var_CO) { }

            trigger OnAfterGetRecord()
            begin
                var_ChequeDate := "Cheque Date";
                var_ChequeAmount := ABS(Amount);
                var_ChequeVendor := Description;

                IF NOT var_Thai THEN BEGIN
                    IF ("Currency Code" = '') THEN
                        var_ChequeAmountText := CodeUnitFunction."NumberThaiToText"(ABS(Amount))
                    ELSE
                        var_ChequeAmountText := CodeUnitFunction."NumberEngToText"(ABS(Amount), "Currency Code");
                END
                ELSE
                    var_ChequeAmountText := CodeUnitFunction."NumberThaiToText"(ABS(Amount));

                // Assign Value Of Month Thai Or ENG
                GenJnlLineDesc.RESET();
                GenJnlLineDesc.SETRANGE("Journal Template Name", "Journal Template Name");
                GenJnlLineDesc.SETRANGE("Journal Batch Name", "Journal Batch Name");
                GenJnlLineDesc.SETRANGE("Document No.", "Document No.");
                GenJnlLineDesc.SETFILTER("Cheque Date", '<>%1', 0D);
                IF NOT GenJnlLineDesc.FIND('-') THEN
                    ERROR('Check Date in Document %1 cannot be blank.', "Document No.")
                ELSE BEGIN
                    var_DateInCheque := GenJnlLineDesc."Cheque Date";

                    GetDateInCheque(GenJnlLineDesc."Cheque Date");


                END;
                // End


                GenJnlLineVen.RESET();
                GenJnlLineVen.SETFILTER("Journal Template Name", '%1', "Journal Template Name");
                GenJnlLineVen.SETFILTER("Journal Batch Name", '%1', "Journal Batch Name");
                GenJnlLineVen.SETFILTER("Document No.", '%1', "Document No.");
                GenJnlLineVen.SETFILTER("Account Type", '%1|%2', "Account Type"::Vendor, "Account Type"::"Bank Account");
                GenJnlLineVen.SETFILTER("Require Screen Detail", '%1', "Require Screen Detail"::CHEQUE);
                IF GenJnlLineVen.FIND('-') THEN
                    Payto := GenJnlLineVen."Pay Name"
                ELSE BEGIN
                    GenJnlLineVen.RESET();
                    GenJnlLineVen.SETFILTER("Journal Template Name", '%1', "Journal Template Name");
                    GenJnlLineVen.SETFILTER("Journal Batch Name", '%1', "Journal Batch Name");
                    GenJnlLineVen.SETFILTER("Document No.", '%1', "Document No.");
                    IF GenJnlLineVen.FIND('-') THEN
                        Payto := GenJnlLineDesc.Description;
                END;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ChequeFormatOfBank; ChequeFormatOfBank)
                    {
                        Caption = 'Bank Type';
                        ToolTip = 'Specifies the value of the Bank Type field.';
                        ApplicationArea = All;
                    }
                    group("A/C PAYEE ONLY")
                    {
                        field("var_A/CPayee"; "var_A/CPayee")
                        {
                            Caption = 'A/C PAYEE ONLY';
                            ToolTip = 'Specifies the value of the A/C PAYEE ONLY field.';
                            ApplicationArea = All;
                            trigger OnValidate()
                            begin
                                if "var_A/CPayee" then
                                    Var_CO := false;
                            end;
                        }
                        field(Var_CO; Var_CO)
                        {
                            Caption = '& CO';
                            ToolTip = 'Specifies the value of the & CO field.';
                            ApplicationArea = All;
                            trigger OnValidate()
                            begin
                                if Var_CO then
                                    "var_A/CPayee" := false;
                            end;
                        }
                    }
                    field(var_Thai; var_Thai)
                    {
                        Caption = 'Amount text in thai';
                        ToolTip = 'Specifies the value of the Amount text in thai field.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            "var_A/CPayee" := TRUE;
            var_Thai := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF "var_A/CPayee" THEN
            var_ShowPayee := 'Show'
        ELSE
            var_ShowPayee := 'Hide';
    end;

    var
        var_ChequeDate: Date;
        var_ChequeAmount: Decimal;
        var_ChequeVendor: Text[250];
        var_ChequeAmountText: Text[250];
        ChequeFormatOfBank: Option BBL,KB,TMB,SCB,BAY,CASH;
        "var_A/CPayee", Var_CO : Boolean;
        var_ShowPayee: Text[5];
        var_Thai: Boolean;

        CodeUnitFunction: Codeunit "Function Center";
        GenJnlLineDesc: Record "Gen. Journal Line";
        var_DateInCheque: Date;
        Payto: Text[250];
        GenJnlLineVen: Record "Gen. Journal Line";
        varDateInChequeDay: array[2] of Text[1];
        varDateInChequeMonth: array[2] of Text[1];
        varDateInChequeYear: array[4] of Text[1];

    procedure GetDateInCheque(dateInCheque: Date)
    begin
        //Get Day
        varDateInChequeDay[1] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 1, 1);
        varDateInChequeDay[2] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 2, 1);

        //Get Month
        varDateInChequeMonth[1] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 3, 1);
        varDateInChequeMonth[2] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 4, 1);

        //Get Year
        varDateInChequeYear[1] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 5, 1);
        varDateInChequeYear[2] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 6, 1);
        varDateInChequeYear[3] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 7, 1);
        varDateInChequeYear[4] := COPYSTR(FORMAT(dateInCheque, 0, '<Day,2><Month,2><Year4>'), 8, 1);
    end;
}

