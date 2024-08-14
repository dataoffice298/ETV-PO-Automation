page 50199 PoSpecificationOptionList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = POSpecificationOption;
    Caption = 'Po Specification Options List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; REC.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
            }
        }
    }
}