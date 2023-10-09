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
        field(50101; Stores; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Stores';
        }
        field(50102; Specifications; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Specifications';
        }
        field(50103; "Accept/Reject"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accept/Reject';
        }
       /* field(50104; "FA Class"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "FA Sub Class"; Boolean)
        {
            DataClassification = ToBeClassified;
        }*/
        field(50106; "QR Code"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        


    }
}