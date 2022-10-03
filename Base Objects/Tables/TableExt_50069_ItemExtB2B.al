tableextension 50069 ItemExtB2B extends Item
{
    fields
    {
        // Add changes to table fields here
    }

    //B2BMSOn30Sep2022>> Added for report sorting
    keys
    {
        key(Key20; "Item Category Code")
        {
        }
    }
    //B2BMSOn30Sep2022<<
}