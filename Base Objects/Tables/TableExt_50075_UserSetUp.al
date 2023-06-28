tableextension 50075 UserSetUp extends "User Setup"//B2BSSD20MAR2023
{
    fields
    {
        field(50100; "User Location"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'User Location';
            TableRelation = Location;
        }
    }
}