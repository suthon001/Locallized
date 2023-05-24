/// <summary>
/// Page Signature (ID 50035).
/// </summary>
page 50035 "Signature"
{
    Caption = 'Signature';
    PageType = CardPart;
    SourceTable = "user setup";
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Signature; Rec.Signature)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Signature field.';
                }
            }

        }

    }
    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';
                trigger OnAction()
                begin
                    ImportSignature();
                end;
            }
            action(DeleteSignatureAction)
            {
                ApplicationArea = All;
                Caption = 'Delete Signature';
                Image = Import;
                ToolTip = 'Delete a picture file.';
                trigger OnAction()
                begin
                    DeleteSignature();
                end;
            }
        }
    }
    /// <summary>
    /// ImportFromDevice.
    /// </summary>
    procedure ImportSignature()
    var
        ltFileName: Text;
        ltInstream: InStream;
    begin
        rec.Find();
        rec.TestField("User ID");
        UploadIntoStream('Select Picture', '', '', ltFileName, ltInstream);
        if ltFileName = '' then
            exit;
        rec.Signature.ImportStream(ltInstream, ltFileName);
        rec.Modify();
    end;

    /// <summary>
    /// DeleteSignature.
    /// </summary>
    procedure DeleteSignature()
    var
        DeleteImageQst: Label 'Are you sure you want to delete the Signature?';
    begin

        Rec.TestField("User ID");

        if not Confirm(DeleteImageQst) then
            exit;

        Clear(Rec.Signature);
        Rec.Modify();

    end;
}
