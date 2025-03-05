table 50234 QuoteSpecifications
{
    //B2BVCOn07Aug2024
    DataClassification = CustomerContent;
    Caption = 'Quote Specifications';
    

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Document No." <> '' then
                    "Document Type" := "Document Type"::Quote;
            end;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ',Quote';
            OptionMembers = "",Quote;
        }
        field(3; "Doc Line No."; Integer)
        {
            Caption = 'Doc Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(5; "S.No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'S.No.';

        }
        field(6; "Product Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Name';
        }
        field(7; Description; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(8; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Total Amount" := Quantity * "Unit Price";
            end;

        }
        field(9; Units; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Units';
            TableRelation = "Item Unit of Measure".Code;
        }
        field(10; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Uint Price';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Total Amount" := Quantity * "Unit Price";
            end;
        }
        field(11; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount';

        }
        field(12; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; Description2; Code[250])
        {
            DataClassification = CustomerContent;
        }
        field(14; Description3; Code[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.", "Document Type", "Item No.", "S.No.", "Doc Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        QuoteSpec: Record QuoteSpecifications;
    begin
        QuoteSpec.Reset();
        if QuoteSpec.FindLast() then
            "S.No." := QuoteSpec."S.No." + 1
        else
            "S.No." := 1
    end;
}