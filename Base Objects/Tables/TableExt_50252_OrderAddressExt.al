tableextension 50252 OrderAddressExtB2B extends "Order Address"
{
    fields
    {
        field(50100; "Contact Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Mail Alert"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}