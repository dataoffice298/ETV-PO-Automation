table 50235 POSpecificationOption
{
    DataClassification = CustomerContent;
    Caption = 'Po Specification Option';
    LookupPageId = PoSpecificationOptionList;

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
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        TechSpecOp: Record POSpecificationOption;
    begin
        TechSpecOp.Reset();
        if TechSpecOp.FindLast() then
            EntryNo := TechSpecOp.EntryNo + 1
        else
            EntryNo := 1;
    end;
}