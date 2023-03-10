pageextension 50113 ItemJournalsB2B extends "Item Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Line No."; Rec."Indent Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Shortcut Dimension 2 Code")//B2BSSD01MAR2023
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}