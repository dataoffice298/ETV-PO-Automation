pageextension 50183 OrderAddressExtB2B extends "Order Address"
{
    layout
    {
        addbefore("Phone No.")
        {
            field("Contact Name"; Rec."Contact Name")
            {
                ApplicationArea = All;
            }
            field("Mail Alert"; Rec."Mail Alert")
            {
                ApplicationArea = All;
            }
        }
    }

}