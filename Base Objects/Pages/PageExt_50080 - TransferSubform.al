pageextension 50080 TransferSubform extends "Transfer Order Subform"
{  //B2BPG11OCT2022
    layout
    {
        addlast(Control1)
        {
            field("Indent No."; Rec."Indent No.")
            {
                Caption = 'Indent No.';
                ApplicationArea = All;
            }

            field("Indent Date"; Rec."Indent Date")
            {
                Caption = 'Indent Date';
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")//B2BSSD21MAR2023
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = All;
                Caption = 'Shortcut Dimension 9 Code';
            }
        }
    }


}