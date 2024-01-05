pageextension 50124 PurchaseInvoice extends "Purchase Invoice"
{
    layout
    {
        Addafter(Status)
        {
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies The Value of Your Reference';
                Editable = false;
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