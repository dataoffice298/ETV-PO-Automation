table 50223 "Terms&ConditionSetUp"
{
    DataClassification = CustomerContent;
    Caption = 'Terms & Condition SetUp';

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line Type"; Code[50])
        {
            TableRelation = TechnicalSpecOption;
            Caption = 'Type';
        }
        field(3; Description; Text[500])
        {

        }
        field(5; Sequence; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Pk; "Line No.")
        {
            Clustered = true;
        }
    }

    var
        TermsConditionSetup: Record "Terms&ConditionSetUp";

    trigger OnInsert()
    begin
        TermsConditionSetup.Reset();
        if TermsConditionSetup.FindLast() then
            "Line No." := TermsConditionSetup."Line No." + 1
        else
            "Line No." := 1;
    end;
}