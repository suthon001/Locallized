/// <summary>
/// Page NCT Clean Transaction Entry (ID 80043).
/// </summary>
page 80043 "NCT Clean Transaction Entry"
{
    InsertAllowed = True;
    PageType = List;
    Editable = True;
    SourceTable = "NCT Record Deletion Table";
    UsageCategory = Tasks;
    AccessByPermission = tabledata "NCT Record Deletion Table" = RIMD;
    ApplicationArea = All;
    Caption = 'Clean Transection';
    layout
    {
        area(content)
        {
            group("Select Company")
            {
                Caption = 'Select company';
                field(company; company)
                {
                    Caption = 'company';
                    TableRelation = Company.Name;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the company field.';
                }
                field(ClearTransaction; ClearTransaction)
                {
                    Caption = 'Suggest Transaction';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Clean Transaction field.';
                }
                field(ClearMaster; ClearMaster)
                {
                    Caption = 'Suggest Master';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Clean Master field.';
                }
                field(cleardetailNoseries; cleardetailNoseries)
                {
                    Caption = 'Set Defualt No. series';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Set Defualt No. series field.';
                }
            }
            repeater(Group)
            {
                field("Delete Records"; rec."Delete Records")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Delete Records field.';
                }
                field("Table ID"; rec."Table ID")
                {
                    ApplicationArea = All;
                    Caption = 'Table ID';
                    ToolTip = 'Insert table no. to Delete';
                }
                field("Table Name"; rec."Table Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table Name field.';
                }
                field("Last Time Clean Transection"; rec."LastTime Clean Transection")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the LastTime Clean Transection field.';
                }
                field("Last Time Clean By"; rec."LastTime Clean By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Time Clean By field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("START DELETE RECORDS")
            {
                Caption = 'START DELETE RECORDS';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Image = DeleteRow;
                ToolTip = 'Executes the START DELETE RECORDS action.';
                trigger OnAction()
                var
                    RecordDeletionMgt: Codeunit "NCT Clean Transactions";
                begin
                    if not Confirm(StrSubstNo('Do you want clear transactions companyname %1', company)) then
                        exit;
                    if company = '' then
                        Message('Please select company!')
                    else
                        RecordDeletionMgt.DeleteRecords(company, cleardetailNoseries, ClearTransaction, ClearMaster); //START DELETE RECORDS
                end;

            }
            action("Generate Table Transection")
            {
                Caption = 'Generate Table';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Image = GetEntries;
                ToolTip = 'Executes the Generate Table action.';
                trigger OnAction()
                var
                    RecordDeletionMgt: Codeunit "NCT Clean Transactions";
                begin
                    Commit();
                    if ClearTransaction then
                        RecordDeletionMgt."Generate TableTansaction"();
                    if ClearMaster then
                        RecordDeletionMgt."Generate TableMaster"();
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        AccessControl: Record "Access Control";
    begin
        company := CompanyName;
        AccessControl.reset();
        AccessControl.SetRange("User Name", UserId);
        AccessControl.SetRange("Role ID", 'CLEARTRANS');
        if AccessControl.IsEmpty then
            Error(ErrrPermission);
    end;

    var
        company: Text;
        cleardetailNoseries, ClearTransaction, ClearMaster : Boolean;
        ErrrPermission: Label 'You don have to permission';
}