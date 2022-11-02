pageextension 50110 PurchaseOrderSubform1 extends "Purchase Order Subform"
{
    //B2BVCOn03Oct22>>>
    layout
    {
        addafter(Description)
        {
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Shortcut Dimension 1 Code")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Line No."; Rec."Indent Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Req No"; Rec."Indent Req No")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Req Line No"; Rec."Indent Req Line No")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }


    actions
    {
        //B2BMSOn28Oct2022>>
        addafter("Item Tracking Lines")
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import Item Tracking';
                Image = Import;

                trigger OnAction()
                var
                    TrackImport: Report "Purchase Line Tracking Import";
                begin
                    Clear(TrackImport);
                    TrackImport.GetValues(Rec);
                    TrackImport.Run();
                    Commit();
                    Rec.OpenItemTrackingLines;
                end;
            }
        }
        //B2BMSOn28Oct2022<<
    }

    var
        myInt: Integer;
    //B2BVCOn03Oct22<<<
}