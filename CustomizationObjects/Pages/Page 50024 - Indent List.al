page 50024 "Indent List"
{
    // version PH1.0,PO1.0

    CardPageID = "Indent Header";
    Editable = false;
    PageType = List;
    SourceTable = "Indent Header";
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTableView = where("Indent Transfer" = const(false), "Closed Indent" = const(false), "Released Status" = filter(<> Released));//BaluOn19Oct2022>>

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
                field(ShortClose; Rec.ShortClose)
                {
                    ApplicationArea = All;
                }
                field(Cancel; Cancel)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        PAGE.RUN(PAGE::"Indent Header", Rec);
                    end;
                }
            }
        }
    }
    //B2BSCM23AUG2023>>
    trigger OnOpenPage()
    var
        LocationWiseUser: Record "Location Wise User";
        CompanyInfo: Record "Company Information";
        Error001: Label 'User doesnot have permissions to accesss indent page';

    begin
        CompanyInfo.get();
        if LocationWiseUser.Get(CompanyInfo."Location Code", UserId) then begin
            if not LocationWiseUser.Indent then
                Error(Error001);
        end

    end;
    //B2BSCM23AUG2023<<
}

