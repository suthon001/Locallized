/// <summary>
/// Codeunit NCT FA Jnl.-Post Line (ID 80014).
/// </summary>
codeunit 80014 "NCT FA Jnl.-Post Line"
{
    Permissions = TableData "FA Ledger Entry" = r,
                  TableData "FA Register" = rm,
                  TableData "Maintenance Ledger Entry" = r,
                  TableData "Ins. Coverage Ledger Entry" = r;

    trigger OnRun()
    begin
    end;

    var
        FA: Record "Fixed Asset";
        FA2: Record "Fixed Asset";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        FAInsertLedgEntry: Codeunit "FA Insert Ledger Entry";
        FAJnlCheckLine: Codeunit "FA Jnl.-Check Line";
        DuplicateDeprBook: Codeunit "Duplicate Depr. Book";
        CalculateDisposal: Codeunit "Calculate Disposal";
        CalculateDepr: Codeunit "NCT Calculate Depreciation";
        CalculateAcqCostDepr: Codeunit "Calculate Acq. Cost Depr.";
        MakeFALedgEntry: Codeunit "Make FA Ledger Entry";
        MakeMaintenanceLedgEntry: Codeunit "Make Maintenance Ledger Entry";
        FANo: Code[20];
        BudgetNo: Code[20];
        DeprBookCode: Code[10];
        FAPostingType: Enum "FA Journal Line FA Posting Type";
        FAPostingDate: Date;
        Amount2: Decimal;
        SalvageValue: Decimal;
        DeprUntilDate: Boolean;
        DeprAcqCost: Boolean;
        ErrorEntryNo: Integer;
        ResultOnDisposal: Integer;

        Text000: Label '%2 must not be %3 in %4 %5 = %6 for %1.';
        Text001: Label '%2 = %3 must be canceled first for %1.';
        Text002: Label '%1 is not a %2.';
        Text003: Label '%1 = %2 already exists for %5 (%3 = %4).';

    /// <summary>
    /// FAJnlPostLine.
    /// </summary>
    /// <param name="FAJnlLine">Record "FA Journal Line".</param>
    /// <param name="CheckLine">Boolean.</param>
    procedure FAJnlPostLine(FAJnlLine: Record "FA Journal Line"; CheckLine: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFAJnlPostLine(FAJnlLine, FAInsertLedgEntry, CheckLine, IsHandled);
        if not IsHandled then begin
            FAInsertLedgEntry.SetGLRegisterNo(0);
            if FAJnlLine."FA No." = '' then
                exit;
            if FAJnlLine."Posting Date" = 0D then
                FAJnlLine."Posting Date" := FAJnlLine."FA Posting Date";
            if CheckLine then
                FAJnlCheckLine.CheckFAJnlLine(FAJnlLine);
            DuplicateDeprBook.DuplicateFAJnlLine(FAJnlLine);
            FANo := FAJnlLine."FA No.";
            BudgetNo := FAJnlLine."Budgeted FA No.";
            DeprBookCode := FAJnlLine."Depreciation Book Code";
            FAPostingType := FAJnlLine."FA Posting Type";
            FAPostingDate := FAJnlLine."FA Posting Date";
            Amount2 := FAJnlLine.Amount;
            SalvageValue := FAJnlLine."Salvage Value";
            DeprUntilDate := FAJnlLine."Depr. until FA Posting Date";
            DeprAcqCost := FAJnlLine."Depr. Acquisition Cost";
            ErrorEntryNo := FAJnlLine."FA Error Entry No.";
            if FAJnlLine."FA Posting Type" = FAJnlLine."FA Posting Type"::Maintenance then begin
                MakeMaintenanceLedgEntry.CopyFromFAJnlLine(MaintenanceLedgEntry, FAJnlLine);
                PostMaintenance();
            end else begin
                MakeFALedgEntry.CopyFromFAJnlLine(FALedgEntry, FAJnlLine);
                PostFixedAsset();
            end;
        end;

        OnAfterFAJnlPostLine(FAJnlLine);
    end;

    /// <summary>
    /// GenJnlPostLine.
    /// </summary>
    /// <param name="GenJnlLine">Record "Gen. Journal Line".</param>
    /// <param name="FAAmount">Decimal.</param>
    /// <param name="VATAmount">Decimal.</param>
    /// <param name="NextTransactionNo">Integer.</param>
    /// <param name="NextGLEntryNo">Integer.</param>
    /// <param name="GLRegisterNo">Integer.</param>
    procedure GenJnlPostLine(GenJnlLine: Record "Gen. Journal Line"; FAAmount: Decimal; VATAmount: Decimal; NextTransactionNo: Integer; NextGLEntryNo: Integer; GLRegisterNo: Integer)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGenJnlPostLine(GenJnlLine, FAInsertLedgEntry, FAAmount, VATAmount, NextTransactionNo, NextGLEntryNo, GLRegisterNo, IsHandled);
        if not IsHandled then begin
            FAInsertLedgEntry.SetGLRegisterNo(GLRegisterNo);
            FAInsertLedgEntry.DeleteAllGLAcc();
            if GenJnlLine."Account No." = '' then
                exit;
            if GenJnlLine."FA Posting Date" = 0D then
                GenJnlLine."FA Posting Date" := GenJnlLine."Posting Date";
            if GenJnlLine."Journal Template Name" = '' then
                GenJnlLine.Quantity := 0;
            DuplicateDeprBook.DuplicateGenJnlLine(GenJnlLine, FAAmount);
            FANo := GenJnlLine."Account No.";
            BudgetNo := GenJnlLine."Budgeted FA No.";
            DeprBookCode := GenJnlLine."Depreciation Book Code";
            FAPostingType := "FA Journal Line FA Posting Type".FromInteger(GenJnlLine."FA Posting Type".AsInteger() - 1);
            FAPostingDate := GenJnlLine."FA Posting Date";
            Amount2 := FAAmount;
            SalvageValue := GenJnlLine.ConvertAmtFCYToLCYForSourceCurrency(GenJnlLine."Salvage Value");
            DeprUntilDate := GenJnlLine."Depr. until FA Posting Date";
            DeprAcqCost := GenJnlLine."Depr. Acquisition Cost";
            ErrorEntryNo := GenJnlLine."FA Error Entry No.";
            if GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Maintenance then begin
                MakeMaintenanceLedgEntry.CopyFromGenJnlLine(MaintenanceLedgEntry, GenJnlLine);
                MaintenanceLedgEntry.Amount := FAAmount;
                MaintenanceLedgEntry."VAT Amount" := VATAmount;
                MaintenanceLedgEntry."Transaction No." := NextTransactionNo;
                MaintenanceLedgEntry."G/L Entry No." := NextGLEntryNo;
                PostMaintenance();
            end else begin
                MakeFALedgEntry.CopyFromGenJnlLine(FALedgEntry, GenJnlLine);
                FALedgEntry.Amount := FAAmount;
                FALedgEntry."VAT Amount" := VATAmount;
                FALedgEntry."Transaction No." := NextTransactionNo;
                FALedgEntry."G/L Entry No." := NextGLEntryNo;
                OnBeforePostFixedAssetFromGenJnlLine(GenJnlLine, FALedgEntry, FAAmount, VATAmount, GLRegisterNo);
                PostFixedAsset();
            end;

            FAInsertLedgEntry.CopyRecordLinksToFALedgEntry(GenJnlLine);
        end;

        OnAfterGenJnlPostLine(GenJnlLine);
    end;

    local procedure PostFixedAsset()
    begin
        FA.LockTable();
        DeprBook.Get(DeprBookCode);
        FA.Get(FANo);
        FA.TestField(Blocked, false);
        FA.TestField(Inactive, false);
        FADeprBook.Get(FANo, DeprBookCode);
        MakeFALedgEntry.CopyFromFACard(FALedgEntry, FA, FADeprBook);
        FAInsertLedgEntry.SetLastEntryNo(true);
        if (FALedgEntry."FA Posting Group" = '') and (FALedgEntry."G/L Entry No." > 0) then begin
            FADeprBook.TestField("FA Posting Group");
            FALedgEntry."FA Posting Group" := FADeprBook."FA Posting Group";
        end;
        if DeprUntilDate then
            PostDeprUntilDate(FALedgEntry, 0);
        if FAPostingType = FAPostingType::Disposal then
            PostDisposalEntry(FALedgEntry)
        else begin
            if PostBudget() then
                SetBudgetAssetNo();
            if not DeprLine() then begin
                OnPostFixedAssetOnBeforeInsertEntry(FALedgEntry);
                FAInsertLedgEntry.SetOrgGenJnlLine(true);
                FAInsertLedgEntry.InsertFA(FALedgEntry);
                FAInsertLedgEntry.SetOrgGenJnlLine(false);
            end;
            PostSalvageValue(FALedgEntry);
        end;
        if DeprAcqCost then
            PostDeprUntilDate(FALedgEntry, 1);
        FAInsertLedgEntry.SetLastEntryNo(false);
        if PostBudget() then
            PostBudgetAsset();

        OnAfterPostFixedAsset(FA, FALedgEntry);
    end;

    local procedure PostMaintenance()
    begin
        FA.LockTable();
        DeprBook.Get(DeprBookCode);
        FA.Get(FANo);
        FADeprBook.Get(FANo, DeprBookCode);
        MakeMaintenanceLedgEntry.CopyFromFACard(MaintenanceLedgEntry, FA, FADeprBook);
        if not DeprBook."Allow Identical Document No." and (MaintenanceLedgEntry."Journal Batch Name" <> '') then
            CheckMaintDocNo(MaintenanceLedgEntry);
        if (MaintenanceLedgEntry."FA Posting Group" = '') and (MaintenanceLedgEntry."G/L Entry No." > 0) then begin
            FADeprBook.TestField("FA Posting Group");
            MaintenanceLedgEntry."FA Posting Group" := FADeprBook."FA Posting Group";
        end;
        if PostBudget() then
            SetBudgetAssetNo();
        OnPostMaintenanceOnBeforeInsertEntry(MaintenanceLedgEntry);
        FAInsertLedgEntry.SetOrgGenJnlLine(true);
        FAInsertLedgEntry.InsertMaintenance(MaintenanceLedgEntry);
        FAInsertLedgEntry.SetOrgGenJnlLine(false);
        if PostBudget() then
            PostBudgetAsset();
    end;

    local procedure PostDisposalEntry(var pFALedgEntry: Record "FA Ledger Entry")
    var
        MaxDisposalNo: Integer;
        SalesEntryNo: Integer;
        DisposalType: Option FirstDisposal,SecondDisposal,ErrorDisposal,LastErrorDisposal;
        OldDisposalMethod: Option " ",Net,Gross;
        EntryAmounts: array[14] of Decimal;
        EntryNumbers: array[14] of Integer;
        i: Integer;
        j: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePostDisposalEntry(pFALedgEntry, DeprBook, FANo, ErrorEntryNo, IsHandled, FAInsertLedgEntry);
        if IsHandled then
            exit;

        pFALedgEntry."Disposal Calculation Method" := DeprBook."Disposal Calculation Method" + 1;
        CalculateDisposal.GetDisposalType(
          FANo, DeprBookCode, ErrorEntryNo, DisposalType,
          OldDisposalMethod, MaxDisposalNo, SalesEntryNo);
        if (MaxDisposalNo > 0) and
           (pFALedgEntry."Disposal Calculation Method" <> OldDisposalMethod)
        then
            Error(
              Text000,
              FAName(), DeprBook.FieldCaption("Disposal Calculation Method"), pFALedgEntry."Disposal Calculation Method",
              DeprBook.TableCaption(), DeprBook.FieldCaption(Code), DeprBook.Code);
        if ErrorEntryNo = 0 then
            pFALedgEntry."Disposal Entry No." := MaxDisposalNo + 1
        else
            if SalesEntryNo <> ErrorEntryNo then
                Error(Text001,
                  FAName(), pFALedgEntry.FieldCaption("Disposal Entry No."), MaxDisposalNo);
        if DisposalType = DisposalType::FirstDisposal then
            PostReverseType(pFALedgEntry);
        if DeprBook."Disposal Calculation Method" = DeprBook."Disposal Calculation Method"::Gross then
            FAInsertLedgEntry.SetOrgGenJnlLine(true);
        FAInsertLedgEntry.InsertFA(pFALedgEntry);
        FAInsertLedgEntry.SetOrgGenJnlLine(false);
        pFALedgEntry."Automatic Entry" := true;
        FAInsertLedgEntry.SetNetdisposal(false);
        if (DeprBook."Disposal Calculation Method" =
            DeprBook."Disposal Calculation Method"::Net) and
           DeprBook."VAT on Net Disposal Entries"
        then
            FAInsertLedgEntry.SetNetdisposal(true);

        if DisposalType = DisposalType::FirstDisposal then begin
            CalculateDisposal.CalcGainLoss(FANo, DeprBookCode, EntryAmounts);
            for i := 1 to 14 do
                if EntryAmounts[i] <> 0 then begin
                    pFALedgEntry."FA Posting Category" := CalculateDisposal.SetFAPostingCategory(i);
                    pFALedgEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetFAPostingType(i));
                    pFALedgEntry.Amount := EntryAmounts[i];
                    if i = 1 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Gain;
                    if i = 2 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Loss;
                    if i > 2 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::" ";
                    if i = 10 then
                        SetResultOnDisposal(pFALedgEntry);
                    FAInsertLedgEntry.InsertFA(pFALedgEntry);
                    PostAllocation(pFALedgEntry);
                end;
        end;
        if DisposalType = DisposalType::SecondDisposal then begin
            CalculateDisposal.CalcSecondGainLoss(FANo, DeprBookCode, pFALedgEntry.Amount, EntryAmounts);
            for i := 1 to 2 do
                if EntryAmounts[i] <> 0 then begin
                    pFALedgEntry."FA Posting Category" := CalculateDisposal.SetFAPostingCategory(i);
                    pFALedgEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetFAPostingType(i));
                    pFALedgEntry.Amount := EntryAmounts[i];
                    if i = 1 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Gain;
                    if i = 2 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Loss;
                    FAInsertLedgEntry.InsertFA(FALedgEntry);
                    PostAllocation(FALedgEntry);
                end;
        end;
        if DisposalType in
           [DisposalType::ErrorDisposal, DisposalType::LastErrorDisposal]
        then begin
            CalculateDisposal.GetErrorDisposal(
              FANo, DeprBookCode, DisposalType = DisposalType::ErrorDisposal, MaxDisposalNo,
              EntryAmounts, EntryNumbers);
            if DisposalType = DisposalType::ErrorDisposal then
                j := 2
            else begin
                j := 14;
                ResultOnDisposal := CalcResultOnDisposal(FANo, DeprBookCode);
            end;
            for i := 1 to j do
                if EntryNumbers[i] <> 0 then begin
                    pFALedgEntry.Amount := EntryAmounts[i];
                    pFALedgEntry."Entry No." := EntryNumbers[i];
                    pFALedgEntry."FA Posting Category" := CalculateDisposal.SetFAPostingCategory(i);
                    pFALedgEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetFAPostingType(i));
                    if i = 1 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Gain;
                    if i = 2 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Loss;
                    if i > 2 then
                        pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::" ";
                    if i = 10 then
                        pFALedgEntry."Result on Disposal" := ResultOnDisposal;
                    FAInsertLedgEntry.InsertFA(FALedgEntry);
                    PostAllocation(FALedgEntry);
                end;
        end;
        FAInsertLedgEntry.CorrectEntries();
        FAInsertLedgEntry.SetNetdisposal(false);

        OnAfterPostDisposalEntry(FALedgEntry, DeprBook, FANo, FAInsertLedgEntry);
    end;

    local procedure PostDeprUntilDate(pFALedgEntry: Record "FA Ledger Entry"; Type: Option UntilDate,AcqCost)
    var
        DepreciationAmount: Decimal;
        Custom1Amount: Decimal;
        NumberOfDays: Integer;
        Custom1NumberOfDays: Integer;
        DummyEntryAmounts: array[4] of Decimal;
    begin
        OnBeforePostDeprUntilDate(pFALedgEntry, FAPostingDate);
        pFALedgEntry."Automatic Entry" := true;
        pFALedgEntry."FA No./Budgeted FA No." := '';
        pFALedgEntry."FA Posting Category" := pFALedgEntry."FA Posting Category"::" ";
        pFALedgEntry."No. of Depreciation Days" := 0;
        if Type = Type::UntilDate then
            CalculateDepr."NCT Calculate"(
              DepreciationAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
              FANo, DeprBookCode, FAPostingDate, DummyEntryAmounts, 0D, 0)
        else
            CalculateAcqCostDepr.DeprCalc(
              DepreciationAmount, Custom1Amount, FANo, DeprBookCode,
              Amount2 + SalvageValue, Amount2);
        if Custom1Amount <> 0 then begin
            pFALedgEntry."FA Posting Type" := pFALedgEntry."FA Posting Type"::"Custom 1";
            pFALedgEntry.Amount := Custom1Amount;
            pFALedgEntry."No. of Depreciation Days" := Custom1NumberOfDays;
            FAInsertLedgEntry.InsertFA(pFALedgEntry);
            if pFALedgEntry."G/L Entry No." > 0 then
                FAInsertLedgEntry.InsertBalAcc(pFALedgEntry);
        end;
        if DepreciationAmount <> 0 then begin
            pFALedgEntry."FA Posting Type" := pFALedgEntry."FA Posting Type"::Depreciation;
            pFALedgEntry.Amount := DepreciationAmount;
            pFALedgEntry."No. of Depreciation Days" := NumberOfDays;
            FAInsertLedgEntry.InsertFA(pFALedgEntry);
            if pFALedgEntry."G/L Entry No." > 0 then
                FAInsertLedgEntry.InsertBalAcc(pFALedgEntry);
        end;
    end;

    local procedure PostSalvageValue(pFALedgEntry: Record "FA Ledger Entry")
    begin
        if (SalvageValue = 0) or (FAPostingType <> FAPostingType::"Acquisition Cost") then
            exit;
        pFALedgEntry."Entry No." := 0;
        pFALedgEntry."Automatic Entry" := true;
        pFALedgEntry.Amount := SalvageValue;
        pFALedgEntry."FA Posting Type" := pFALedgEntry."FA Posting Type"::"Salvage Value";
        OnPostSalvageValueOnBeforeInsertEntry(pFALedgEntry);
        FAInsertLedgEntry.InsertFA(pFALedgEntry);
    end;

    local procedure PostBudget(): Boolean
    begin
        exit(BudgetNo <> '');
    end;

    local procedure SetBudgetAssetNo()
    begin
        FA2.Get(BudgetNo);
        if not FA2."Budgeted Asset" then begin
            FA."No." := FA2."No.";
            DeprBookCode := '';
            Error(Text002, FAName(), FA.FieldCaption("Budgeted Asset"));
        end;
        if FAPostingType = FAPostingType::Maintenance then
            MaintenanceLedgEntry."FA No./Budgeted FA No." := BudgetNo
        else
            FALedgEntry."FA No./Budgeted FA No." := BudgetNo;
    end;

    local procedure PostBudgetAsset()
    var
        ltFixedAsset: Record "Fixed Asset";
        FAPostingType2: Enum "FA Ledger Entry FA Posting Type";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePostBudgetAsset(FALedgEntry, BudgetNo, IsHandled);
        if IsHandled then
            exit;

        ltFixedAsset.Get(BudgetNo);
        ltFixedAsset.TestField(Blocked, false);
        ltFixedAsset.TestField(Inactive, false);
        if FAPostingType = FAPostingType::Maintenance then begin
            MaintenanceLedgEntry."Automatic Entry" := true;
            MaintenanceLedgEntry."G/L Entry No." := 0;
            MaintenanceLedgEntry."FA No./Budgeted FA No." := MaintenanceLedgEntry."FA No.";
            MaintenanceLedgEntry."FA No." := BudgetNo;
            MaintenanceLedgEntry.Amount := -Amount2;
            OnPostBudgetAssetOnBeforeInsertMaintenanceLedgEntry(MaintenanceLedgEntry);
            FAInsertLedgEntry.InsertMaintenance(MaintenanceLedgEntry);
        end else begin
            FALedgEntry."Automatic Entry" := true;
            FALedgEntry."G/L Entry No." := 0;
            FALedgEntry."FA No./Budgeted FA No." := FALedgEntry."FA No.";
            FALedgEntry."FA No." := BudgetNo;
            if SalvageValue <> 0 then begin
                FALedgEntry.Amount := -SalvageValue;
                FAPostingType2 := FALedgEntry."FA Posting Type";
                FALedgEntry."FA Posting Type" := FALedgEntry."FA Posting Type"::"Salvage Value";
                FAInsertLedgEntry.InsertFA(FALedgEntry);
                FALedgEntry."FA Posting Type" := FAPostingType2;
            end;
            FALedgEntry.Amount := -Amount2;
            OnPostBudgetAssetOnBeforeInsertFAEntry(FALedgEntry);
            FAInsertLedgEntry.InsertFA(FALedgEntry);
        end;
    end;

    /// <summary>
    /// PostReverseType.
    /// </summary>
    /// <param name="pFALedgEntry">Record "FA Ledger Entry".</param>
    procedure PostReverseType(pFALedgEntry: Record "FA Ledger Entry")
    var
        EntryAmounts: array[4] of Decimal;
        i: Integer;
    begin
        OnBeforePostReverseType(pFALedgEntry);
        CalculateDisposal.CalcReverseAmounts(FANo, DeprBookCode, EntryAmounts);
        pFALedgEntry."FA Posting Category" := pFALedgEntry."FA Posting Category"::" ";
        pFALedgEntry."Automatic Entry" := true;
        for i := 1 to 4 do
            if EntryAmounts[i] <> 0 then begin
                pFALedgEntry.Amount := EntryAmounts[i];
                pFALedgEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetReverseType(i));
                FAInsertLedgEntry.InsertFA(pFALedgEntry);
                if pFALedgEntry."G/L Entry No." > 0 then
                    FAInsertLedgEntry.InsertBalAcc(pFALedgEntry);
            end;
    end;

    /// <summary>
    /// PostGLBalAcc.
    /// </summary>
    /// <param name="pFALedgEntry">Record "FA Ledger Entry".</param>
    /// <param name="AllocatedPct">Decimal.</param>
    procedure PostGLBalAcc(pFALedgEntry: Record "FA Ledger Entry"; AllocatedPct: Decimal)
    begin
        if AllocatedPct > 0 then begin
            pFALedgEntry."Entry No." := 0;
            pFALedgEntry."Automatic Entry" := true;
            pFALedgEntry.Amount := -FALedgEntry.Amount;
            pFALedgEntry.Correction := not pFALedgEntry.Correction;
            FAInsertLedgEntry.InsertBalDisposalAcc(pFALedgEntry);
            pFALedgEntry.Correction := not pFALedgEntry.Correction;
            FAInsertLedgEntry.InsertBalAcc(pFALedgEntry);
        end;
    end;

    local procedure PostAllocation(var pFALedgEntry: Record "FA Ledger Entry")
    var
        FAPostingGr: Record "FA Posting Group";
    begin
        if pFALedgEntry."G/L Entry No." = 0 then
            exit;
        case pFALedgEntry."FA Posting Type" of
            pFALedgEntry."FA Posting Type"::"Gain/Loss":
                if DeprBook."Disposal Calculation Method" = DeprBook."Disposal Calculation Method"::Net then begin
                    FAPostingGr.GetPostingGroup(pFALedgEntry."FA Posting Group", DeprBook.Code);
                    FAPostingGr.CalcFields("Allocated Gain %", "Allocated Loss %");
                    if pFALedgEntry."Result on Disposal" = pFALedgEntry."Result on Disposal"::Gain then
                        PostGLBalAcc(pFALedgEntry, FAPostingGr."Allocated Gain %")
                    else
                        PostGLBalAcc(pFALedgEntry, FAPostingGr."Allocated Loss %");
                end;
            pFALedgEntry."FA Posting Type"::"Book Value on Disposal":
                begin
                    FAPostingGr.GetPostingGroup(pFALedgEntry."FA Posting Group", DeprBook.Code);
                    FAPostingGr.CalcFields("Allocated Book Value % (Gain)", "Allocated Book Value % (Loss)");
                    if pFALedgEntry."Result on Disposal" = pFALedgEntry."Result on Disposal"::Gain then
                        PostGLBalAcc(pFALedgEntry, FAPostingGr."Allocated Book Value % (Gain)")
                    else
                        PostGLBalAcc(pFALedgEntry, FAPostingGr."Allocated Book Value % (Loss)");
                end;
        end;
    end;

    local procedure DeprLine(): Boolean
    begin
        exit((Amount2 = 0) and (FAPostingType = FAPostingType::Depreciation) and DeprUntilDate);
    end;

    /// <summary>
    /// FindFirstGLAcc.
    /// </summary>
    /// <param name="FAGLPostBuf">VAR Record "FA G/L Posting Buffer".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure FindFirstGLAcc(var FAGLPostBuf: Record "FA G/L Posting Buffer"): Boolean
    begin
        exit(FAInsertLedgEntry.FindFirstGLAcc(FAGLPostBuf));
    end;

    /// <summary>
    /// GetNextGLAcc.
    /// </summary>
    /// <param name="FAGLPostBuf">VAR Record "FA G/L Posting Buffer".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetNextGLAcc(var FAGLPostBuf: Record "FA G/L Posting Buffer"): Integer
    begin
        exit(FAInsertLedgEntry.GetNextGLAcc(FAGLPostBuf));
    end;

    local procedure FAName(): Text[200]
    var
        DepreciationCalc: Codeunit "Depreciation Calculation";
    begin
        exit(DepreciationCalc.FAName(FA, DeprBookCode));
    end;

    /// <summary>
    /// SetResultOnDisposal.
    /// </summary>
    /// <param name="pFALedgEntry">VAR Record "FA Ledger Entry".</param>
    procedure SetResultOnDisposal(var pFALedgEntry: Record "FA Ledger Entry")
    var
        ltFADeprBook: Record "FA Depreciation Book";
    begin
        ltFADeprBook."FA No." := FALedgEntry."FA No.";
        ltFADeprBook."Depreciation Book Code" := FALedgEntry."Depreciation Book Code";
        ltFADeprBook.CalcFields("Gain/Loss");
        if ltFADeprBook."Gain/Loss" <= 0 then
            pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Gain
        else
            pFALedgEntry."Result on Disposal" := pFALedgEntry."Result on Disposal"::Loss;
    end;

    local procedure CalcResultOnDisposal(pFANo: Code[20]; pDeprBookCode: Code[10]): Integer
    var
        ltFADeprBook: Record "FA Depreciation Book";
        ltFALedgEntry: Record "FA Ledger Entry";
    begin
        ltFADeprBook."FA No." := pFANo;
        ltFADeprBook."Depreciation Book Code" := pDeprBookCode;
        ltFADeprBook.CalcFields("Gain/Loss");
        if ltFADeprBook."Gain/Loss" <= 0 then
            exit(ltFALedgEntry."Result on Disposal"::Gain);

        exit(ltFALedgEntry."Result on Disposal"::Loss);
    end;

    local procedure CheckMaintDocNo(pMaintenanceLedgEntry: Record "Maintenance Ledger Entry")
    var
        OldMaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        FAJnlLine2: Record "FA Journal Line";
    begin
        OldMaintenanceLedgEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "Document No.");
        OldMaintenanceLedgEntry.SetRange("FA No.", pMaintenanceLedgEntry."FA No.");
        OldMaintenanceLedgEntry.SetRange("Depreciation Book Code", pMaintenanceLedgEntry."Depreciation Book Code");
        OldMaintenanceLedgEntry.SetRange("Document No.", pMaintenanceLedgEntry."Document No.");
        if OldMaintenanceLedgEntry.FindFirst() then begin
            FAJnlLine2."FA Posting Type" := FAJnlLine2."FA Posting Type"::Maintenance;
            Error(
              Text003,
              OldMaintenanceLedgEntry.FieldCaption("Document No."),
              OldMaintenanceLedgEntry."Document No.",
              FAJnlLine2.FieldCaption("FA Posting Type"),
              FAJnlLine2."FA Posting Type",
              FAName());
        end;
    end;

    /// <summary>
    /// UpdateRegNo.
    /// </summary>
    /// <param name="GLRegNo">Integer.</param>
    procedure UpdateRegNo(GLRegNo: Integer)
    var
        FAReg: Record "FA Register";
    begin
        if FAReg.FindLast() then begin
            FAReg."G/L Register No." := GLRegNo;
            FAReg.Modify();
        end;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterFAJnlPostLine(var FAJournalLine: Record "FA Journal Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterGenJnlPostLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterPostDisposalEntry(var FALedgEntry: Record "FA Ledger Entry"; DeprBook: Record "Depreciation Book"; FANo: Code[20]; var FAInsertLedgEntry: Codeunit "FA Insert Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostFixedAsset(var FA: Record "Fixed Asset"; FALedgEntry: Record "FA Ledger Entry")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeFAJnlPostLine(var FAJournalLine: Record "FA Journal Line"; var FAInsertLedgerEntry: Codeunit "FA Insert Ledger Entry"; CheckLine: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeGenJnlPostLine(var GenJournalLine: Record "Gen. Journal Line"; var FAInsertLedgerEntry: Codeunit "FA Insert Ledger Entry"; FAAmount: Decimal; VATAmount: Decimal; NextTransactionNo: Integer; NextGLEntryNo: Integer; GLRegisterNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostBudgetAsset(var FALedgerEntry: Record "FA Ledger Entry"; BudgetNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostReverseType(var FALedgEntry: Record "FA Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostDeprUntilDate(var FALedgEntry: Record "FA Ledger Entry"; var FAPostingDate: Date)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostDisposalEntry(var FALedgEntry: Record "FA Ledger Entry"; DeprBook: Record "Depreciation Book"; FANo: Code[20]; ErrorEntryNo: Integer; var IsHandled: Boolean; var FAInsertLedgEntry: Codeunit "FA Insert Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostFixedAssetFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var FALedgerEntry: Record "FA Ledger Entry"; FAAmount: Decimal; VATAmount: Decimal; GLRegisterNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostFixedAssetOnBeforeInsertEntry(var FALedgEntry: Record "FA Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostSalvageValueOnBeforeInsertEntry(var FALedgEntry: Record "FA Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostMaintenanceOnBeforeInsertEntry(var MaintenanceLedgEntry: Record "Maintenance Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostBudgetAssetOnBeforeInsertMaintenanceLedgEntry(var MaintenanceLedgEntry: Record "Maintenance Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostBudgetAssetOnBeforeInsertFAEntry(var FALedgEntry: Record "FA Ledger Entry")
    begin
    end;
}

