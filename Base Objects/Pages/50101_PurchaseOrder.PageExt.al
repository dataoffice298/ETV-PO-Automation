pageextension 50101 PostedOrderPageExt extends "Purchase Order"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
            }
            field("EPCG No."; Rec."EPCG No.")
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {
        //B2BVCOn03Oct2022>>
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                GateEntry.Reset();
                GateEntry.SetRange("Source No.", PurchLine."Document No.");
                if GateEntry.FindFirst() then begin
                    PurchLine.Reset();
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            if (PurchLine."Ref. Posted Gate Entry" = '') then
                                Error('Gate entry available for the purchase document. Hence, It must be filled in Line No. %1.', PurchLine."Line No.");
                        until PurchLine.Next = 0;
                end;

            end;
        }
        //B2BVCOn03Oct2022<<
        //B2BVCOn04Oct2022>>>
        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                if (Rec."LC No." = '') then begin
                    LCDetails.Reset();
                    LCDetails.SetRange("Issued To/Received From", Rec."Buy-from Vendor No.");
                    LCDetails.SetRange("Transaction Type", LCDetails."Transaction Type"::Purchase);
                    LCDetails.SetRange(Released, true);
                    if LCDetails.FindFirst() then
                        Error('There is a Released LC document against this Vendor. To proceed, please provide LC No. in Purchase Order');
                end;
            end;
        }
        //B2BVCOn04Oct2022<<<
    }
    var
        cu90: Codeunit "Purch.-Post";
        GateEntry: Record "Posted Gate Entry Line_B2B";
        PurchLine: Record "Purchase Line";
        LCDetails: Record "LC Details";

    /*   actions
       {
           // Add changes to page actions here
       }

       var
           myInt: Integer;*/
}