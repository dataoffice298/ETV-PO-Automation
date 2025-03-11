table 50235 "PO Specifications"
{
    DataClassification = CustomerContent;
    Caption = 'PO Specifications';

    fields
    {
        field(1; DocumentType; Enum "Purchase Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(2; DocumentNo; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; LineNo; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; LineType; Code[50])
        {
            DataClassification = CustomerContent;
        }
        Field(5; Description; Text[500])
        {
            DataClassification = CustomerContent;
        }
        field(9; Type; Option) //B2BVCOn26Aug2024
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Specifications';
            OptionMembers = " ",Specifications;
        }
    }

    keys
    {
        key(Pk; DocumentNo, DocumentType, Type, LineNo)
        {
            Clustered = true;
        }

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