/// <summary>
/// PageExtension ExtenPostGenJournalLine (ID 80002) extends Record Posted General Journal.
/// </summary>
pageextension 80002 "ExtenPostGenJournalLine" extends "Posted General Journal"
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
            field("Require Screen Detail"; Rec."Require Screen Detail")
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
                    PostedVoucher: Report "Posted Voucher";
                    PostedGenLine: Record "Posted Gen. Journal Line";
                    GLEntry: Record "G/L Entry";
                begin
                    PostedGenLine.reset();
                    PostedGenLine.copy(rec);
                    GLEntry.reset();
                    GLEntry.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GLEntry.SetRange("Document No.", rec."Document No.");
                    GLEntry.SetRange("Posting Date", rec."Posting Date");
                    PostedVoucher.SetTableView(GLEntry);
                    PostedVoucher.SetDataPosting(PostedGenLine);
                    PostedVoucher.RunModal();
                end;
            }
        }

        //addafter()
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
                    ShowDetailCheque: Page "Posted ShowDetail Cheque";
                    ShowDetailVAT: Page "Posted ShowDetail Vat";
                    ShowDetailWHT: Page "PostedShowDetailWHT";
                    GenLineDetail: Record "Posted Gen. Journal Line";
                    WHTCertificates: Page "WHT Certificate";
                    WHTCertificate: Record "WHT Header";

                begin
                    Rec.TestField("Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    CLEAR(WHTCertificates);
                    if Rec."Require Screen Detail" IN [Rec."Require Screen Detail"::VAT, Rec."Require Screen Detail"::CHEQUE] then begin
                        GenLineDetail.reset();
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        if Rec."Require Screen Detail" = Rec."Require Screen Detail"::CHEQUE then begin
                            ShowDetailCheque.SetTableView(GenLineDetail);
                            ShowDetailCheque.RunModal();
                            CLEAR(ShowDetailCheque);
                        end else
                            if Rec."Require Screen Detail" = Rec."Require Screen Detail"::VAT then begin
                                ShowDetailVAT.SetTableView(GenLineDetail);
                                ShowDetailVAT.RunModal();
                                CLEAR(ShowDetailVAT);
                            end;
                    end else
                        if Rec."Require Screen Detail" = Rec."Require Screen Detail"::WHT then begin
                            if rec."Template Source Type" = rec."Template Source Type"::"Cash Receipts" then begin
                                ShowDetailWHT.SetTableView(GenLineDetail);
                                ShowDetailWHT.RunModal();
                                Clear(ShowDetailWHT);
                            end else begin
                                WHTCertificate.reset();
                                WHTCertificate.SetRange("WHT No.", Rec."WHT Document No.");
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