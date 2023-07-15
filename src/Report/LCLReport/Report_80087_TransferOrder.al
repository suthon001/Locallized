report 80087 "NCT Transfer Order"
{
    Caption = 'Transfer Order';
    RDLCLayout = './LayoutReport/LCLReport/Report_80087_TransferOrder.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(CompName; ComInfo.Name + ComInfo."Name 2") { }
            column(CompPicture; ComInfo.Picture) { }
            Column(CompAdd; ComInfo.Address) { }
            Column(CompAdd2; ComInfo."Address 2" + ' ' + ComInfo.City + ' ' + ComInfo."Post Code") { }
            Column(CompPhone; ComInfo."Phone No.") { }
            Column(CompFax; ComInfo."Fax No.") { }
            Column(CompTaxID; ComInfo."VAT Registration No.") { }
            Column(DocumentNo; "No.") { }
            Column(ExtDocumentNo; "External Document No.") { }
            Column(DocumentDate; "Posting Date") { }
            Column(LineLocation; FromLocation) { }
            Column(LineNewLocation; ToLocation) { }
            Column(LineIntransit; IntransitLocation) { }
            Column(TransferComment; TransferComment) { }
            column(SetServiceType; SetServiceType) { }

            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") where("Derived From Line No." = const(0));
                DataItemLink = "Document No." = field("No.");
                Column(LineNo; LineNo) { }
                Column(No; "Item No.") { }
                Column(LineDescription; Description + ' ' + "Description 2") { }
                Column(LineDescription2; "Description 2") { }
                Column(LineQty; Quantity) { }
                Column(LineUnit; "Unit of Measure Code") { }
                Column(LineQtyShipped; "Quantity Shipped") { }
                Column(FromBin; "Transfer-from Bin Code") { }
                Column(ToBin; "Transfer-To Bin Code") { }

                dataitem("Reservation Entry"; "Reservation Entry")
                {
                    DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                    DataItemTableView = where(Positive = const(false));
                    column(Quantity__Base_; "Quantity (Base)") { }
                    column(LotSeriesNoDesc; LotSeriesNoDesc) { }
                    column(LotSeriesNo; LotSeriesNo) { }
                    trigger OnAfterGetRecord()
                    begin
                        LotSeriesNoDesc := '';
                        LotSeriesNo := '';
                        IF ("Lot No." <> '') or ("Serial No." <> '') THEN
                            if "Lot No." <> '' then begin
                                LotSeriesNo := "Lot No.";
                                LotSeriesNoDesc := 'Lot No. : ' + LotSeriesNo;
                            end else begin
                                LotSeriesNo := "Serial No.";
                                LotSeriesNoDesc := 'Serial No. : ' + LotSeriesNo;
                            end;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    LineNo += 1;
                    LotSeriesNoDesc := '';
                    LotSeriesNo := '';
                end;

            }


            trigger OnAfterGetRecord()
            var
                LF: Char;
                CR: Char;
                ltmax: Integer;
            begin
                SetServiceType := 'ใบโอนย้ายสินค้า';
                if not Location.GET("Transfer-from Code") then
                    Location.Init();
                FromLocation := Location.Name;


                if not Location.GET("Transfer-to Code") then
                    Location.Init();
                ToLocation := Location.Name;


                if not Location.GET("In-Transit Code") then
                    Location.Init();
                IntransitLocation := Location.Name;

                LF := 10;
                CR := 13;
                CommentHeader.RESET();
                CommentHeader.SETRANGE("Document Type", CommentHeader."Document Type"::"Transfer Order");
                CommentHeader.SETRANGE("No.", "No.");
                CommentHeader.SETFILTER(Comment, '<>%1', '');
                IF CommentHeader.FINDSET() THEN
                    REPEAT
                        ltmax += 1;
                        IF ltmax <= 3 THEN
                            TransferComment += CommentHeader.Comment + FORMAT(CR, 0, '<CHAR>') + FORMAT(LF, 0, '<CHAR>');
                    UNTIL CommentHeader.NEXT() = 0;
                TransferComment := DELCHR(TransferComment, '>', FORMAT(LF, 0, '<CHAR>'));


            end;

        }
    }
    trigger OnPreReport()
    begin
        ComInfo.GET();
        ComInfo.CALCFIELDS(Picture);
    end;

    var
        ComInfo: Record "Company Information";

        CommentHeader: Record "Inventory Comment Line";
        TransferComment: Text;

        Location: Record "Location";
        FromLocation: Text;
        ToLocation: Text;
        IntransitLocation: Text;
        SetServiceType, LotSeriesNo, LotSeriesNoDesc : Text;
        LineNo: Integer;

}


