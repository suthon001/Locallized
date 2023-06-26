/// <summary>
/// Page NCT WHT Certificate Subform (ID 80009).
/// </summary>
page 80009 "NCT WHT Certificate Subform"
{
    PageType = ListPart;
    SourceTable = "NCT WHT Line";
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
                    ToolTip = 'Specifies the value of the WHT Product Posting Group field.';
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT % field.';
                }
                field("WHT Base"; Rec."WHT Base")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Base field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }

            }
        }
    }

}