tableextension 50057 tableextension70000012 extends "Purchases & Payables Setup"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO,CS1.0

    fields
    {
        field(50100; "Cons. Receipt Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50101; "Posted Cons. Rcpt. Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50102; "Quote Comparision"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(33002191; "Vendor Approved Required"; Boolean)
        {
            Description = 'PO1.0';
        }
        field(33002900; "ICN Nos."; Code[10])
        {
            Description = 'PO1.0';
            TableRelation = "No. Series";
        }
        field(33002901; "RFQ Nos."; Code[10])
        {
            Description = 'PO1.0';
            TableRelation = "No. Series";
        }
        field(33002902; "Manufacturer Nos."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "No. Series";
        }
        field(33002903; "Enquiry Nos."; Code[10])
        {
            Description = 'PO1.0';
            TableRelation = "No. Series";
        }
        field(33002904; "Indent Nos."; Code[20])
        {
            Caption = 'Purchase Indent Nos.';
            Description = 'PO1.0';
            TableRelation = "No. Series";
        }
        field(33002905; "Price Required"; Boolean)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Price Weightage", 0);
            end;
        }
        field(33002906; "Price Weightage"; Decimal)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Price Required");
            end;
        }
        field(33002907; "Quality Required"; Boolean)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Quality Weightage", 0);
            end;
        }
        field(33002908; "Quality Weightage"; Decimal)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Quality Required");
            end;
        }
        field(33002909; "Delivery Required"; Boolean)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Delivery Weightage", 0);
            end;
        }
        field(33002910; "Delivery Weightage"; Decimal)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Delivery Required");
            end;
        }
        field(33002911; "Payment Terms Required"; Boolean)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Payment Terms Weightage", 0);
            end;
        }
        field(33002912; "Payment Terms Weightage"; Decimal)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                TESTFIELD("Payment Terms Required");
            end;
        }
        field(33002913; "Default Quality Rating"; Decimal)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                //TESTFIELD("Default Quality Required");
            end;
        }
        field(33002914; "Default Delivery Rating"; Decimal)
        {
            Description = 'PO1.0';

            trigger OnValidate();
            begin
                //TESTFIELD("Default Delivery Required");
            end;
        }
        field(33002915; "Cumulation of Indents"; Boolean)
        {
            Description = 'PO1.0';
        }
        field(33002916; "Indent Req No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "No. Series";
        }
        field(50103; "Quotation Comparision Nos."; Code[20])
        {
            Caption = 'Quotation Comparision Nos.';
            TableRelation = "No. Series";
        }
        field(50104; "Purchase Enquiry Nos."; Code[20])
        {
            Caption = 'Purchase Enquiry Nos.';
            TableRelation = "No. Series";
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

