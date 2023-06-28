pageextension 50116 UserSetUpExt extends "User Setup"
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
        }
    }
}