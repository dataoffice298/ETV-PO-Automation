pageextension 50116 UserSetUpExt_B2B extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field(UserLocation; Rec."User Location")
            {
                ApplicationArea = All;
                Caption = 'User Location';
                TableRelation = Location;
            }
            field(Stores; Rec.Stores)
            {
                ApplicationArea = all;
            }
            field(Specifications; Specifications)
            {
                ApplicationArea = all;
            }
            field("Accept/Reject"; "Accept/Reject")
            {
                ApplicationArea = all;
            }
          /*  field("FA Class"; "FA Class")
            {
                ApplicationArea = all;
            }
            field("FA Sub Class"; "FA Sub Class")
            {
                ApplicationArea = all;
            }*/

        }
    }
}