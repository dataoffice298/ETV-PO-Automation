page 50221 "Closed Indent List"
{
    CardPageID = "Indent Header";
    Editable = false;
    PageType = List;
    SourceTable = "Indent Header";
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTableView = where("Indent Transfer" = const(false), "Closed Indent" = const(true));
    Caption = 'Closed Indent List';

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = all;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field(Indentor; rec.Indentor)
                {
                    ApplicationArea = all;
                }
                field("Closed Indent"; Rec."Closed Indent")
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