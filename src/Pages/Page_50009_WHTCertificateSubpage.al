page 50009 "WHT Certificate Subform"
{
    PageType = ListPart;
    SourceTable = "WHT Lines";
    MultipleNewLines = false;
    AutoSplitKey = true;
    RefreshOnActivate = true;
    Caption = 'WHT Certificate Subform';
    layout
    {
        area(content)
        {
            repeater("Group")
            {
                Caption = 'Lines';
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = all;
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = all;
                }
                field("WHT Base"; Rec."WHT Base")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

}