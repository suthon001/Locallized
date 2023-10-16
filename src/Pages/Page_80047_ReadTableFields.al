/// <summary>
/// Page NCT Read Table Fields (ID 80047).
/// </summary>
page 80047 "NCT Read Table Fields"
{
    Caption = 'Read Table Fields';
    PageType = Worksheet;
    SourceTable = "NCT Read Table Field";
    UsageCategory = Lists;
    ApplicationArea = all;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            field(TableID; TableID)
            {
                ApplicationArea = all;
                Caption = 'Table ID';
                ToolTip = 'Specifies the value of the Table ID field.';
                trigger OnValidate()
                begin
                    if TableID = 0 then
                        TableNames := ''
                    else
                        GetfieldbyTable(TableID);
                end;

                trigger OnAssistEdit()
                begin
                    SelectTable();
                end;
            }
            field(TableNames; TableNames)
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Table Name';
                ToolTip = 'Specifies the value of the Table Name field.';
            }
            repeater(General)
            {
                field("Field ID"; Rec."Field ID")
                {
                    ToolTip = 'Specifies the value of the Field ID field.';
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.';
                    ApplicationArea = All;
                }
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.';
                    ApplicationArea = All;
                }
                field(Remark; Rec.Remark)
                {
                    ToolTip = 'Specifies the value of the Remark field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    /// <summary>
    /// GetfieldbyTable.
    /// </summary>
    /// <param name="pTableID">Integer.</param>
    local procedure GetfieldbyTable(pTableID: Integer)
    var
        ltField: Record Field;
    begin
        rec.reset();
        rec.DeleteAll();
        Commit();
        ltField.reset();
        ltField.SetRange(TableNo, pTableID);
        ltField.SetFilter("No.", '<>%1', 0);
        if ltField.FindSet() then
            repeat
                rec.Init();
                rec."Table ID" := ltField.TableNo;
                rec."Field ID" := ltField."No.";
                rec."Field Name" := ltField.FieldName;
                rec."Data Type" := Format(ltField.Type);
                if rec."Data Type" in ['Code', 'Text', 'Boolean', 'Option'] then
                    if ltField.Type = ltField.Type::Option then
                        rec.Remark := Format(ltField.OptionString)
                    else
                        if ltField.Type = ltField.Type::Boolean then
                            rec.Remark := 'Yes,No'
                        else
                            if ltField.Len <> 0 then
                                rec.Remark := Format(ltField.Len);

                rec.Insert();
            until ltField.Next() = 0;
        Commit();
        rec.reset();
        rec.SetCurrentKey("Table ID", "Field ID");
        CurrPage.Update(false);
    end;

    local procedure SelectTable()
    var
        allobject: Record AllObjWithCaption;
        selectObject: Page "NCT Select Table Object";
    begin
        CLEAR(selectObject);
        allobject.reset();
        allobject.SetRange("Object Type", allobject."Object Type"::Table);
        selectObject.SetTableView(allobject);
        selectObject.LookupMode := true;
        selectObject.Editable := false;
        if selectObject.RunModal() = Action::LookupOK then begin
            selectObject.GetRecord(allobject);
            TableNames := allobject."Object Name";
            TableID := allobject."Object ID";
            GetfieldbyTable(TableID);
        end;
        CLEAR(selectObject);
    end;

    var
        TableID: Integer;
        TableNames: Text;
}
