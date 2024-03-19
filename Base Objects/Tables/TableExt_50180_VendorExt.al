tableextension 50180 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50100; "Document Type"; Enum "Purchase Document Type")
        {
            DataClassification = ToBeClassified;

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