pageextension 50114 PurchQuoteSubformExtB2B extends "Purchase Quote Subform"
{
    layout
    {
        addbefore("Shortcut Dimension 1 Code")
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
            field("Indent Req No"; Rec."Indent Req No")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Req Line No"; Rec."Indent Req Line No")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
            }
            field("Indentor Description"; Rec."Indentor Description")//B2BSSD03Feb2023
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