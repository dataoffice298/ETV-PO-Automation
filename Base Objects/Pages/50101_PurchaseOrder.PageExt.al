pageextension 50101 PostedOrderPageExt extends "Purchase Order"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
            }
            field("EPCG No.";Rec."EPCG No.")
            {
                ApplicationArea = all;
            }
        
        }
    }
    var
        cu90: Codeunit "Purch.-Post";

    /*   actions
       {
           // Add changes to page actions here
       }

       var
           myInt: Integer;*/
}