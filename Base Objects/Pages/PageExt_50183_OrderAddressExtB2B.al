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
        addafter("E-Mail")
        {
            field(Email2; Rec.Email2)
            {
                ApplicationArea = All;
                Caption = 'E-Mail2';
            }
        }
    }

}