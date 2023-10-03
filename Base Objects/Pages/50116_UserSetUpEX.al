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
           field(Stores;Rec.Stores)
           {
            ApplicationArea = all;
           }
        }
    }
}