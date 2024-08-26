pageextension 50180 PurchOrderListExt extends "Purchase Order List"
{

    layout
    {
        addafter(Status)
        {
            field("Purchase order"; Rec."Purchase order") //B2B30APR2024
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortClosed; Rec.ShortClosed)
            {
                ApplicationArea = All;
                Caption = 'ShortClosed';
            }
            field("Cancelled Order"; Rec."Cancelled Order")
            {
                ApplicationArea = All;
                Caption = 'CancelOrder';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    //B2B30APR2024 <<
    trigger OnOpenPage()
    var
        PurchaseOrderList: page "Purchase Order List";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Purchase order", false);
        Rec.SetRange("Posted Invioce",false); //B2BSSD
        Rec.FilterGroup(0);
    end;
    //B2B30APR2024 >>
}