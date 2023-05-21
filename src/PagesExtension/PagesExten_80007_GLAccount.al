pageextension 80007 "ExtenGLAccount" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Require Screen Detail"; Rec."Require Screen Detail")
            {
                ApplicationArea = all;
            }

        }
        modify("Direct Posting")
        {
            Visible = true;
        }
        moveafter(Name; "Direct Posting")


    }
}