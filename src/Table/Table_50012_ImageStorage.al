table 50012 "Image Storage"
{
    Caption = 'Image Storage';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Type"; Option)
        {
            OptionMembers = IMAGE,QRCODE,BARCODE;
            OptionCaption = 'IMAGE,QRCODE,BARCODE';
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(3; "No."; Code[250])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(5; "Image"; Blob)
        {
            Caption = 'Image';
            Subtype = Bitmap;
            DataClassification = CustomerContent;


        }
        field(6; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(7; "Date Time"; DateTime)
        {
            Caption = 'Date Time';
            DataClassification = CustomerContent;
        }
        field(8; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK1; "Table ID", "Type", "No.", "Line No.")
        {
            Clustered = true;
        }
    }
}