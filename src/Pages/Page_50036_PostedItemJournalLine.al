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
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    ApplicationArea = all;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = all;
                }
                field("Amount (ACY)"; Rec."Amount (ACY)")
                {
                    ApplicationArea = all;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = all;
                }
                field("New Bin Code"; Rec."New Bin Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}