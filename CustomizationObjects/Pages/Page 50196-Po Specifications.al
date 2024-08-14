page 50198 "Po Specifications"
{

    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = ListPart;
    SourceTable = "PO Specifications";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    //SourceTableView = WHERE(DocumentType = FILTER(Order));

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
                /*field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }*/
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
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

    var
        myInt: Integer;
}