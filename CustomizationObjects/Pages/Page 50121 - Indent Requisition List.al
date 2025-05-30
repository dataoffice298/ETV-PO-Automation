page 50121 "Indent Requisition List"
{
    // version PO1.0

    CardPageID = "Indent Requisition Document";
    PageType = List;
    SourceTable = "Indent Req Header";
    SourceTableView = where(Status = filter(Open | "Pending Approval")); //B2BMS

    UsageCategory = Lists;
    ApplicationArea = all;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Resposibility Center"; Rec."Resposibility Center")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Cancel; Rec.Cancel)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange(Cancel, false);
    end;
}

