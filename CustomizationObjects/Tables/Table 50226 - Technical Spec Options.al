table 50226 TechnicalSpecOption
{
    DataClassification = CustomerContent;
    Caption = 'Technical Spec Option';
    LookupPageId = TechnicalSpecificationOpList;

    fields
    {
        field(5001; Code; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'code';
        }
        field(50002; Description; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50003; EntryNo; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50004; Type; Option) //B2BVCOn26Aug2024
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Terms & Conditions,Specifications';
            OptionMembers = " ","Terms & Conditions",Specifications;
        }
        field(50005; "SNo."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description, Type)
        { }
    }
    trigger OnInsert()
    var
        TechSpecOp: Record TechnicalSpecOption;
    begin
        TechSpecOp.Reset();
        if TechSpecOp.FindLast() then
            EntryNo := TechSpecOp.EntryNo + 1
        else
            EntryNo := 1;
    end;
}