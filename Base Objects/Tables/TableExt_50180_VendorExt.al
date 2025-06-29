tableextension 50180 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50100; "Document Type"; Enum "Purchase Document Type")
        {
            DataClassification = ToBeClassified;

        }
        field(50111; Selected; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50112; "Approval Status"; Option)
        {
            OptionMembers = Open,"Pending Approval",Released;
            OptionCaption = 'Open,Pending Approval,Released';
        }




    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }



    var
        myInt: Integer;
}