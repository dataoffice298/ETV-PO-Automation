pageextension 50181 PostedPurchCreditMemoExt extends "Posted Purchase Credit Memo"
{
    layout
    {

    }

    actions
    {
        addafter(AttachAsPDF)
        {
            action("Create RGP Outward") //B2BVCOn03April2024
            {
                ApplicationArea = All;
                Caption = 'Create RGP Outward';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    CreateRGPOutWard();
                end;
            }
        }
    }

    //B2BVCOn03April2024 >>
    local procedure CreateRGPOutWard()
    var
        GateEntryHeader: Record "Gate Entry Header_B2B";
        GateEntryLine: Record "Gate Entry Line_B2B";
        PurchCrditMemoLine: Record "Purch. Cr. Memo Line";
        PurchLine: Record "Purchase Line";
        LineNo: Integer;
    begin
        PurchCrditMemoLine.Reset();
        PurchCrditMemoLine.SetRange("Document No.", Rec."No.");
        PurchCrditMemoLine.SetFilter(Type, '<>%1', PurchCrditMemoLine.Type::"G/L Account");
        if PurchCrditMemoLine.FindSet() then begin
            GateEntryHeader.Init();
            GateEntryHeader.Type := GateEntryHeader.Type::RGP;
            GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Outward;
            GateEntryHeader.Validate("Location Code", Rec."Location Code");
            GateEntryHeader."Document Date" := WorkDate;
            GateEntryHeader."Document Time" := Time;
            GateEntryHeader."Purch Cr.Memo No." := Rec."No.";
            GateEntryHeader.Insert(true);
            LineNo := 10000;
            repeat
                if PurchCrditMemoLine."No." <> '' then begin
                    GateEntryLine.Init();
                    GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                    GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                    GateEntryLine.Type := GateEntryHeader.Type;
                    GateEntryLine."Line No." := LineNo;
                    if PurchCrditMemoLine.Type = PurchCrditMemoLine.Type::Item then
                        GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
                    if PurchCrditMemoLine.Type = PurchCrditMemoLine.Type::"Fixed Asset" then
                        GateEntryLine."Source Type" := GateEntryLine."Source Type"::"Fixed Asset";
                    GateEntryLine.Validate("Source No.", PurchCrditMemoLine."No.");
                    GateEntryLine."Source Name" := PurchCrditMemoLine.Description;
                    GateEntryLine.Description := PurchCrditMemoLine."Description 2";
                    GateEntryLine.Validate(Quantity, PurchCrditMemoLine.Quantity);
                    GateEntryLine."Unit of Measure" := PurchCrditMemoLine."Unit of Measure";
                    GateEntryLine.Variant := PurchCrditMemoLine."Variant Code";
                    PurchLine.Reset();
                    PurchLine.SetRange("Document No.", PurchCrditMemoLine."Order No.");
                    PurchLine.SetRange("Line No.", PurchCrditMemoLine."Order Line No.");
                    if PurchLine.FindFirst() then
                        GateEntryLine."InWard Gate Entry No." := PurchLine."Posted Gate Entry No.";
                    GateEntryLine."Purch Cr. Memo No." := PurchCrditMemoLine."Document No.";
                    GateEntryLine."Purch Cr. Memo Line No." := PurchCrditMemoLine."Line No.";
                    GateEntryLine."Purchase Order No." := PurchCrditMemoLine."Order No.";
                    GateEntryLine."Purchase Order Line No." := PurchCrditMemoLine."Order Line No.";
                    GateEntryLine.Insert(true);
                    LineNo += 10000;
                end;
            until PurchCrditMemoLine.Next = 0;
            Message('RGP OutWard Created');
        end;
    end;
    //B2BVCOn03April2024 <<
}