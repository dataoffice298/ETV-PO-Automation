tableextension 50055 tableextension70000016 extends "Purchase Line Archive"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO

    fields
    {


        //Unsupported feature: Deletion on ""KK Cess%"(Field 16542)". Please convert manually.


        //Unsupported feature: Deletion on ""KK Cess Amount"(Field 16543)". Please convert manually.

        field(50200; "Indent No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "Indent Header" WHERE("Released Status" = FILTER(Released));
        }
        field(50201; "Indent Line No."; Integer)
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

    //Unsupported feature: PropertyChange. Please convert manually.

}

