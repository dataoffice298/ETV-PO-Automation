page 50199 "Complete CentralIndentReq List"
{
    Caption = 'Complete Central Indent Requisition List';
    CardPageID = "Indent Requisition Document";
    PageType = List;
    SourceTable = "Indent Req Header";
    SourceTableView = sorting("Document Date") order(descending) where("Resposibility Center" = const('CENTRL REQ'), Status = const(Release), "Req Status" = filter(Completed));
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
                field("Indent No."; "Indent No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Req Status"; Rec."Req Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
            }
        }
    }

    actions
    {
    }

    var
        StyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
    end;
    
}