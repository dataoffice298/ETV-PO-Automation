pageextension 50079 postedPurchInvExt extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Tax Area Code")
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("EPCG No."; Rec."EPCG No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("EPCG Scheme"; rec."EPCG Scheme")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Import Type"; rec."Import Type")
            {
                ApplicationArea = all;
                Editable = false;
            }

        }
        //B2BSSD23MAR2023<<
        addafter("Vendor Order No.")
        {
            field(ProgrammeName; Rec."Programme Name")
            {
                ApplicationArea = All;
                Caption = 'Programme Name';
                Editable = false;
            }
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = All;
                Caption = 'Purpose';
                Editable = false;
            }
            field("PO Narration"; "PO Narration")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of your Reference';
                Editable = false;
            }
        }
        //B2BSSD23MAR2023>>
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}