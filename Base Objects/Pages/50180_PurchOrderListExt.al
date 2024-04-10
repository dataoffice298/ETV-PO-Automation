pageextension 50180 PurchOrderListExt extends "Purchase Order List"
{
    layout
    {
        addafter(Status)
        {
            field(ShortClosed; Rec.ShortClosed)
            {
                ApplicationArea = All;
                Caption = 'ShortClosed';
            }
            field("Cancelled Order"; Rec."Cancelled Order")
            {
                ApplicationArea = All;
                Caption = 'CancelOrder';
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