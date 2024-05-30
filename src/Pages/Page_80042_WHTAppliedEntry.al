
/// <summary>
/// Page NCT WHT Applied Entry (ID 80042).
/// </summary>
page 80042 "NCT WHT Applied Entry"
{

    Caption = 'WHT Applied Entry';
    PageType = List;
    SourceTable = "NCT WHT Applied Entry";
    SourceTableTemporary = true;
    UsageCategory = None;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entryr Type field.';
                }
                field("WHT Bus. Posting Group"; Rec."WHT Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Bus. Posting Group field.';
                }
                field("WHT Prod. Posting Group"; Rec."WHT Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Prod. Posting Group field.';
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
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }
                field("WHT Name"; Rec."WHT Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Name field.';
                }
                field("WHT Name 2"; Rec."WHT Name 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Name 2 field.';
                }
                field("WHT Address"; Rec."WHT Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Address field.';
                }
                field("WHT Address 2"; Rec."WHT Address 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Address 2 field.';
                }
                field("WHT Address 3"; Rec."WHT Address 3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Address 3 field.';
                }
                field("WHT City"; Rec."WHT City")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("WHT Post Code"; Rec."WHT Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("WHT Option"; Rec."WHT Option")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Option field.';
                }
            }
        }
    }
    /// <summary>
    /// SetWhtApply.
    /// </summary>
    /// <param name="TempWhtAppliedEntry">Temporary VAR Record "NCT WHT Applied Entry".</param>
    procedure SetWhtApply(var TempWhtAppliedEntry: Record "NCT WHT Applied Entry" temporary)
    begin
        if TempWhtAppliedEntry.FindSet() then
            repeat
                Rec := TempWhtAppliedEntry;
                rec.Insert();
            until TempWhtAppliedEntry.Next() = 0;
    end;
}
