pageextension 50110 PurchaseOrderSubform1 extends "Purchase Order Subform"
{
    //B2BVCOn03Oct22>>>
    layout
    {
        addafter(Description)
        {
            field(Select; Rec.Select)
            {
                ApplicationArea = all;
            }
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Location Code")
        {
            field("Sub Location Code"; Rec."Sub Location Code")
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
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
            }

            //B2BMSOn03Nov2022>>
            field("QC Enabled B2B"; Rec."QC Enabled B2B")
            {
                ApplicationArea = All;
            }
            field("Qty. to Accept B2B"; Rec."Qty. to Accept B2B")
            {
                ApplicationArea = All;
            }
            field("Qty. to Reject B2B"; Rec."Qty. to Reject B2B")
            {
                ApplicationArea = All;
            }
            field("Rejection Comments B2B"; rec."Rejection Comments B2B")
            {
                Caption = 'Rejection Comments';
                ApplicationArea = all;
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = All;
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                ApplicationArea = All;
            }
            //B2BMSOn03Nov2022<<
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

        //B2BMSOn03Nov2022>>
        addlast("F&unctions")
        {
            group(RGP)
            {
                group(RGPInward)
                {
                    Caption = 'RGP Inward';
                    action(CreateRGPInward)
                    {
                        Caption = 'Create RGP Inward';
                        ApplicationArea = All;
                        Image = CreateDocument;
                        trigger OnAction()
                        var
                            PurChaseHeader: Record "Purchase Header";//B2BSSDJan2023
                        begin
                            //B2BSSDJan2023<<
                            PurChaseHeader.Reset();
                            PurChaseHeader.SetRange("No.", Rec."Document No.");
                            if PurChaseHeader.FindFirst() then begin
                                PurChaseHeader.TestField("Import Type");
                            end;
                            //B2BSSDJan2023>>
                            CreateGateEntries(GateEntryType::Inward, GateEntryDocType::RGP)
                        end;
                    }

                    action(CreateNRGPInward)
                    {
                        Caption = 'Create NRGP Inward';
                        ApplicationArea = All;
                        Image = Create;

                        trigger OnAction()
                        begin
                            CreateGateEntries(GateEntryType::Inward, GateEntryDocType::NRGP)
                        end;
                    }
                }
                group(RGPOutward)
                {
                    Caption = 'RGP Outward';
                    action(CreateRGPOutward)
                    {
                        Caption = 'Create RGP Outward';
                        ApplicationArea = All;
                        Image = CreateDocument;

                        trigger OnAction()
                        begin
                            CreateGateEntries(GateEntryType::Outward, GateEntryDocType::RGP)
                        end;
                    }

                    action(CreateNRGPOutward)
                    {
                        Caption = 'Create NRGP Outward';
                        ApplicationArea = All;
                        Image = Create;

                        trigger OnAction()
                        begin
                            CreateGateEntries(GateEntryType::Outward, GateEntryDocType::NRGP)
                        end;
                    }
                }
                group(Navigate)
                {
                    action(OpenGateEntries)
                    {
                        ApplicationArea = All;
                        Image = Open;
                        Caption = 'Inward/Outward Entries';

                        trigger OnAction()
                        var
                            GateEntryHdr: Record "Gate Entry Header_B2B";
                        begin
                            GateEntryHdr.Reset();
                            GateEntryHdr.FilterGroup(2);
                            GateEntryHdr.SetRange("Purchase Order No.", Rec."Document No.");
                            GateEntryHdr.SetRange("Purchase Order Line No.", Rec."Line No.");
                            GateEntryHdr.FilterGroup(0);
                            Page.RunModal(Page::"Gate Entry List", GateEntryHdr);
                        end;
                    }
                    action(OpenPostedGateEntries)
                    {
                        ApplicationArea = All;
                        Image = History;
                        Caption = 'Posted Inward/Outward Entries';

                        trigger OnAction()
                        var
                            PostedGateEntryHdr: Record "Posted Gate Entry Header_B2B";
                        begin
                            PostedGateEntryHdr.Reset();
                            PostedGateEntryHdr.FilterGroup(2);
                            PostedGateEntryHdr.SetRange("Purchase Order No.", Rec."Document No.");
                            PostedGateEntryHdr.SetRange("Purchase Order Line No.", Rec."Line No.");
                            PostedGateEntryHdr.FilterGroup(0);
                            Page.RunModal(Page::"Posted Gate Entries List", PostedGateEntryHdr);
                        end;
                    }
                }
            }
            //B2BMSOn03Nov2022<<
        }
    }

    procedure CreateGateEntries(EntryType: Option Inward,Outward; DocType: Option RGP,NRGP)
    var
        GateEntryHeader: Record "Gate Entry Header_B2B";
        GateEntryLine: Record "Gate Entry Line_B2B";
        OpenText: Label 'An Gate Entry document - %1 is created. \Do you want to open the document?';
        PurchLine: Record "Purchase Line";
        SelErr: Label 'No line selected.';
        ItemLRec: Record Item;
        FALRec: Record "Fixed Asset";
        ReservationEntry: Record "Reservation Entry";
        LineNo: Integer;
    begin
        Clear(ReservationEntry);
        LineNo := 10000;
        PurchLine.Reset();
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange(Select, true);
        if PurchLine.FindSet() then
            repeat
                Rec.CheckTracking(PurchLine);
            until PurchLine.Next() = 0;

        PurchLine.Reset();
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange(Select, true);
        if PurchLine.FindSet() then begin
            if EntryType = EntryType::Inward then
                Rec.TestField("Qty. to Receive")
            else
                if EntryType = EntryType::Outward then
                    Rec.TestField("Qty. to Reject B2B");

            GateEntryHeader.Init();
            if EntryType = EntryType::Inward then
                GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Inward
            else
                if EntryType = EntryType::Outward then
                    GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Outward;

            if DocType = DocType::RGP then
                GateEntryHeader.Type := GateEntryHeader.Type::RGP
            else
                if DocType = DocType::NRGP then
                    GateEntryHeader.Type := GateEntryHeader.Type::NRGP;

            GateEntryHeader.Validate("Location Code", Rec."Location Code");
            GateEntryHeader."Purchase Order No." := Rec."Document No.";
            GateEntryHeader."Purchase Order Line No." := Rec."Line No.";
            GateEntryHeader.Insert(true);

            repeat
                if PurchLine.Type = PurchLine.Type::Item then begin
                    ReservationEntry.Reset();
                    ReservationEntry.SetRange("Item No.", PurchLine."No.");
                    ReservationEntry.SetRange("Source Type", 39);
                    ReservationEntry.SetRange("Source Subtype", 1);
                    ReservationEntry.SetRange("Location Code", PurchLine."Location Code");
                    ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
                    ReservationEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
                    ReservationEntry.SetRange(Positive, true);
                    if ReservationEntry.Findset() then
                        repeat
                            GateEntryLine.Init();
                            GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                            GateEntryLine.Type := GateEntryHeader.Type;
                            GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                            GateEntryLine."Line No." := LineNo;
                            GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
                            GateEntryLine.Validate("Source No.", PurchLine."No.");
                            ItemLRec.Get(PurchLine."No.");
                            GateEntryLine."Source Name" := ItemLRec.Description;
                            GateEntryLine.Description := ItemLRec.Description;
                            GateEntryLine.Variant := PurchLine."Variant Code";//B2BSSDOn13Dec2022
                            GateEntryLine."Unit of Measure" := Rec."Unit of Measure Code";
                            if EntryType = EntryType::Inward then
                                GateEntryLine.Validate(Quantity, ReservationEntry.Quantity)
                            else
                                if EntryType = EntryType::Outward then
                                    GateEntryLine.Validate(Quantity, Rec."Qty. to Reject B2B");

                            GateEntryLine.ModelNo := ReservationEntry."Lot No.";
                            GateEntryLine.SerialNo := ReservationEntry."Serial No.";
                            GateEntryLine.Make := ReservationEntry."Variant Code";
                            GateEntryLine.Insert(true);
                            LineNo += 10000;
                        until ReservationEntry.Next() = 0;
                end else
                    if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
                        GateEntryLine.Init();
                        GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                        GateEntryLine.Type := GateEntryHeader.Type;
                        GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                        GateEntryLine."Line No." := LineNo;
                        GateEntryLine."Source Type" := GateEntryLine."Source Type"::"Fixed Asset";
                        GateEntryLine.Validate("Source No.", PurchLine."No.");
                        FALRec.Get(PurchLine."No.");
                        GateEntryLine."Source Name" := FALRec.Description;
                        GateEntryLine.Description := FALRec.Description;
                        GateEntryLine."Unit of Measure" := Rec."Unit of Measure Code";
                        if EntryType = EntryType::Inward then
                            GateEntryLine.Validate(Quantity, PurchLine."Qty. to Accept B2B")
                        else
                            if EntryType = EntryType::Outward then
                                GateEntryLine.Validate(Quantity, Rec."Qty. to Reject B2B");
                        GateEntryLine.ModelNo := FALRec."Model No.";
                        GateEntryLine.SerialNo := FALRec."Serial No.";
                        GateEntryLine.Make := FALRec.Make_B2B;
                        GateEntryLine.Insert(true);
                        LineNo += 10000;
                    end;
                PurchLine.Select := false;
                if EntryType = EntryType::Outward then begin
                    PurchLine."Quantity Rejected B2B" += PurchLine."Qty. to Reject B2B";
                    PurchLine."Qty. to Reject B2B" := 0;
                end else
                    if EntryType = EntryType::Inward then begin
                        PurchLine."Quantity Accepted B2B" += PurchLine."Qty. to Accept B2B";
                        PurchLine."Qty. to Accept B2B" := 0;
                    end;
                PurchLine.Modify();
            until PurchLine.Next() = 0;

            if Confirm(OpenText, false, GateEntryHeader."No.") then
                if (EntryType = EntryType::Inward) and (DocType = DocType::RGP) then
                    Page.Run(Page::"Inward Gate Entry-RGP", GateEntryHeader)
                else
                    if (EntryType = EntryType::Inward) and (DocType = DocType::NRGP) then
                        Page.Run(Page::"Inward Gate Entry-NRGP", GateEntryHeader)
                    else
                        if (EntryType = EntryType::Outward) and (DocType = DocType::RGP) then
                            Page.Run(Page::"Outward Gate Entry - RGP", GateEntryHeader)
                        else
                            if (EntryType = EntryType::Outward) and (DocType = DocType::NRGP) then
                                Page.Run(Page::"Outward Gate Entry - NRGP", GateEntryHeader);
        end else
            Error(SelErr);
    end;

    var
        GateEntryType: Option Inward,Outward;
        GateEntryDocType: Option RGP,NRGP;
}