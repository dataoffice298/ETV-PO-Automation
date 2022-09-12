pageextension 50101 PostedOrderPageExt extends "Purchase Order"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("LC No."; "LC No.")
            {
                ApplicationArea = All;
            }
            field("Bill of Entry No"; "Bill of Entry No")
            {
                ApplicationArea = All;
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