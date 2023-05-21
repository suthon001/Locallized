page 50035 "Signature"
{
    PageType = Card;
    SourceTable = "User Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'Signature';
    DataCaptionFields = "User ID";
    layout
    {
        area(Content)
        {
            group("Signature Group")
            {
                Caption = 'Signature';
                field("Signature"; Rec."Signature")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}