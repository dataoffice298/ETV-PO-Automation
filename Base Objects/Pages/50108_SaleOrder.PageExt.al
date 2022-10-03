pageextension 50108 SalesOrderPageExtB2B extends "Sales Order"
{
    layout
    {
        addlast("Shipping and Billing")
        {
            field("LC No."; Rec."LC No.")
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