tableextension 50050 tableextension70000007 extends "Purch. Inv. Line"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO

    fields
    {

        //Unsupported feature: Deletion on ""KK Cess%"(Field 16542)". Please convert manually.


        //Unsupported feature: Deletion on ""KK Cess Amount"(Field 16543)". Please convert manually.

        field(50101; "Free Item Type"; Option)
        {
            Description = 'B2B1.0 13Dec2016';
            OptionCaption = '" ,Same Item,Different Item"';
            OptionMembers = " ","Same Item","Different Item";
        }
        field(50102; "Free Item No."; Code[20])
        {
            Description = 'B2B1.0 13Dec2016';
            TableRelation = Item;
        }
        field(50103; "Free Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Free Unit of Measure Code',
                        ENN = 'Unit of Measure Code';
            Description = 'B2B1.0 13Dec2016';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Free Item No."));
        }
        field(50104; "Free Quantity"; Decimal)
        {
            CaptionML = ENU = 'Free Quantity',
                        ENN = 'Minimum Quantity';
            Description = 'B2B1.0 13Dec2016';
            MinValue = 0;
        }
        field(50105; "Parent Line No."; Integer)
        {
            Description = 'B2B1.0 13Dec2016';
            Editable = false;
        }
        field(50052; Free; Boolean)
        {
            Description = 'B2B1.0 13Dec2016';
            Editable = false;
        }
        field(50053; "Approved Vendor"; Boolean)
        {
            Description = 'B2B1.0 05 Dec2016';
        }
        field(50054; "Agreement No."; Code[20])
        {
            Description = 'B2B1.0 06 Dec2016';
        }
        field(33002900; "Indent No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "Indent Header" WHERE("Released Status" = FILTER(Released));
        }
        field(33002901; "Indent Line No."; Integer)
        {
            Description = 'PO1.0';
        }
        field(33002902; "Quotation No."; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002904; "Indent Req No"; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
        }
        field(33002905; "Indent Req Line No"; Integer)
        {
            Description = 'PO1.0';
            Editable = false;
        }
    }
    keys
    {
        /*//Balu
        key(Key1;"Buy-from Vendor No.","No.",Type)
        {
            SumIndexFields = Quantity;
        }*/
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

