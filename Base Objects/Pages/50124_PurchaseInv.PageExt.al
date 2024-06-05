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
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; "Vendor Invoice Date")
            {
                ApplicationArea = All;
            }
        }
    }

}