page 50198 "Completed Purchase Order lists"
{
    //B2BSSD >>
    Caption = 'Completed Purchase Order lists';
    PageType = List;
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    SourceTable = "Purchase Header";
    CardPageId = "Purchase Order";
    SourceTableView = WHERE("Document Type" = CONST(Order), "Posted Invioce" = const(true));
    RefreshOnActivate = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Completed Purchase Order lists")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Posted Invioce"; Rec."Posted Invioce")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    //B2BSSD <<
}