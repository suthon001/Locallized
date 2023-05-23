/// <summary>
/// Page Posted Item Journal Lines (ID 50036).
/// </summary>
page 50036 "Posted Item Journal Lines"
{
    Caption = 'Posted ItemJournal Lines';
    SourceTable = "Posted ItemJournal Lines";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = History;
    PromotedActionCategories = 'Process,Report';
    PageType = List;
    ApplicationArea = all;
    layout
    {
        area(Content)
        {
            repeater("General")
            {
                Caption = 'Lines';
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Location Code field.';
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (ACY)"; Rec."Amount (ACY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount (ACY) field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bin Code field.';
                }
                field("New Bin Code"; Rec."New Bin Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Bin Code field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
        }
    }

}