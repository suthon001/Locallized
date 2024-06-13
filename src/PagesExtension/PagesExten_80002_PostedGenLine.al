/// <summary>
/// PageExtension ExtenPostPostedGenLine (ID 80002) extends Record Posted General Journal.
/// </summary>
pageextension 80002 "NCT ExtenPostPostedGenLine" extends "Posted General Journal"
{
    PromotedActionCategories = 'New,Process,Print,Navigate,Show Detail';
    layout
    {
        addafter(Description)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("Require Screen Detail"; Rec."NCT Require Screen Detail")
            {
                ApplicationArea = all;
                Caption = 'Require Screen Detail';
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
            }
        }
    }
    actions
    {

        addlast(Reporting)
        {
            action("Posted Voucher")
            {
                Caption = 'Posted Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Posted Voucher action.';
                trigger OnAction()
                var
                    PostedGenLine: Record "Posted Gen. Journal Line";
                    GenjournalTemp: Record "Gen. Journal Template";
                    JournalVoucher: Report "NCT Journal Voucher";
                    PaymentVoucher: Report "NCT Payment Voucher";
                    ReceiveVoucher: Report "NCT Receive Voucher";
                    FAJournalVoucher: Report "NCT FA G/L Journal Voucher";
                begin
                    GenjournalTemp.GET(rec."Journal Template Name");
                    PostedGenLine.reset();
                    PostedGenLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    PostedGenLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    PostedGenLine.SetRange("Document No.", rec."Document No.");
                    if PostedGenLine.FindFirst() then begin
                        if GenjournalTemp.Type = GenjournalTemp.Type::Payments then begin
                            CLEAR(PaymentVoucher);
                            PaymentVoucher.SetDataTable(PostedGenLine);
                            PaymentVoucher.RunModal();
                            CLEAR(PaymentVoucher);
                        end;
                        if GenjournalTemp.Type = GenjournalTemp.Type::General then begin
                            CLEAR(JournalVoucher);
                            JournalVoucher.SetDataTable(PostedGenLine);
                            JournalVoucher.RunModal();
                            CLEAR(JournalVoucher);
                        end;
                        if GenjournalTemp.Type = GenjournalTemp.Type::"Cash Receipts" then begin
                            CLEAR(ReceiveVoucher);
                            ReceiveVoucher.SetDataTable(PostedGenLine);
                            ReceiveVoucher.RunModal();
                            CLEAR(ReceiveVoucher);
                        end;
                        if GenjournalTemp.Type = GenjournalTemp.Type::Assets then begin
                            CLEAR(FAJournalVoucher);
                            FAJournalVoucher.SetDataTable(PostedGenLine);
                            FAJournalVoucher.RunModal();
                            CLEAR(FAJournalVoucher);
                        end;
                    end;
                end;
            }
        }
        addafter(CopySelected)
        {
            action("Show Detail")
            {
                Caption = 'Show Details';
                Image = LineDescription;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Executes the Show Details action.';
                trigger OnAction()
                var
                    ShowDetailCheque: Page "NCT Posted ShowDetail Cheque";
                    ShowDetailVAT: Page "NCT Posted ShowDetail Vat";
                    ShowDetailWHT: Page "NCT PostedShowDetailWHT";
                    GenLineDetail: Record "Posted Gen. Journal Line";
                    WHTCertificates: Page "NCT WHT Certificate";
                    WHTCertificate: Record "NCT WHT Header";

                begin
                    Rec.TestField("NCT Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    CLEAR(WHTCertificates);
                    if Rec."NCT Require Screen Detail" IN [Rec."NCT Require Screen Detail"::VAT, Rec."NCT Require Screen Detail"::CHEQUE] then begin
                        GenLineDetail.reset();
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        if Rec."NCT Require Screen Detail" = Rec."NCT Require Screen Detail"::CHEQUE then begin
                            ShowDetailCheque.SetTableView(GenLineDetail);
                            ShowDetailCheque.RunModal();
                            CLEAR(ShowDetailCheque);
                        end else
                            if Rec."NCT Require Screen Detail" = Rec."NCT Require Screen Detail"::VAT then begin
                                ShowDetailVAT.SetTableView(GenLineDetail);
                                ShowDetailVAT.RunModal();
                                CLEAR(ShowDetailVAT);
                            end;
                    end else
                        if Rec."NCT Require Screen Detail" = Rec."NCT Require Screen Detail"::WHT then begin
                            if rec."NCT Template Source Type" = rec."NCT Template Source Type"::"Cash Receipts" then begin
                                ShowDetailWHT.SetTableView(GenLineDetail);
                                ShowDetailWHT.RunModal();
                                Clear(ShowDetailWHT);
                            end else begin
                                WHTCertificate.reset();
                                WHTCertificate.SetRange("WHT No.", Rec."NCT WHT Document No.");
                                WHTCertificate.SetRange("Posted", true);
                                WHTCertificates.SetTableView(WHTCertificate);
                                WHTCertificates.Editable := false;
                                WHTCertificates.RunModal();
                                CLEAR(WHTCertificates);
                            end;
                        end else
                            MESSAGE('Nothing to Show Detail');
                end;
            }

        }
    }
}