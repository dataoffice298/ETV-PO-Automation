table 50240 "Specification Worksheet"
{
    DataClassification = ToBeClassified;
    Caption = 'Specification Worksheet';

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            TableRelation = "RFQ Numbers";
        }
        field(2; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
        }
        field(3; "Spec ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = TechnicalSpecOption where(Type = filter(Specifications));

            trigger OnValidate()
            var
                TechSpecOpt: Record TechnicalSpecOption;
            begin
                if TechSpecOpt.Get("Spec ID") then
                    Description := TechSpecOpt.Description;
            end;
        }
        field(4; Description; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Specifications';
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(6; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
    }

    keys
    {
        key(PK; Code, "Spec ID", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Code, "Vendor No.")
        { }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}