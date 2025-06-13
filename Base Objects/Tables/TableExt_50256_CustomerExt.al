tableextension 50256 CustomertbExt extends Customer
{
    fields
    {
        // Add changes to table fields here
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