page 50184 TechnicalSpecificationOpList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = TechnicalSpecOption;
    Caption = 'Technical Specification Options List';


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
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("SNo."; Rec."SNo.")
                {
                    Caption = 'Priority';
                    ApplicationArea = All;
                }
            }
        }
    }
}