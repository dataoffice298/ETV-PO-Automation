page 50220 "PO Terms and Specifications"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = ListPart;
    SourceTable = "PO Specifications";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    SourceTableView = WHERE(Type = filter(Specifications));
    Caption = 'PO Specifications';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(LineType; rec.LineType)
                {
                    ApplicationArea = All;
                }

                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type) //B2BVCOn30Aug2024
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DocumentNo; Rec.DocumentNo)
                {
                    ApplicationArea = All;
                    Editable = False;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}