pageextension 50100 PosPurchReceipt extends "Posted Purchase Receipt"
{
    layout
    {
        addlast(Invoicing)
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
            }
            field("EPCG No."; Rec."EPCG No.")
            {
                ApplicationArea = all;
            }


        }

        /*     actions
             {

             }

             var
                 myInt: Integer;*/
    }
}