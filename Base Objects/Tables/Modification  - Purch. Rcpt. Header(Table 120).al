tableextension 50051 tableextension70000002 extends "Purch. Rcpt. Header"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO

    fields
    {
        field(33002900; "RFQ No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "RFQ Numbers"."RFQ No." WHERE(Completed = FILTER(false));

            trigger OnValidate();
            var
                RFQNumbers: Record "RFQ Numbers";
            begin
            end;
        }
        field(33002901; "Quotation No."; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002902; "ICN No."; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
            TableRelation = "Quotation Comparison";
        }
        field(50003; "LC No."; Code[20])
        {
            Caption = 'LC No.';
            Editable = false;
        }
        field(50004; "Bill of Entry No"; Code[20])
        {
            Caption = 'Bill of Entry No.';
            Editable = false;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

