pageextension 50100 PosPurchReceipt extends "Posted Purchase Receipt"
{
    layout
    {
        addlast(Invoicing)
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

        /*     actions
             {

             }

             var
                 myInt: Integer;*/
    }
}