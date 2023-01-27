page 50180 TermsAndConditionsSetup
{
    PageType = List;
    Caption = 'Terms & condition SetUp';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Terms&ConditionSetUp";
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;


                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}