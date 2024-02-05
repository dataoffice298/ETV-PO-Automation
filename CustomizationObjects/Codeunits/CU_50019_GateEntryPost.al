codeunit 50019 "Gate Entry- Post"
{
    // version NAVIN7.00

    TableNo = "Gate Entry Header_B2B";
    //Permissions = tabledata "E-mail Log" = rimd;

    trigger OnRun();
    var
        InvSetUp: Record "Inventory Setup";
        Location: Record Location;
        FixedAsset: Record "Fixed Asset";
        ERRORmsg1: Label 'Fixed Assets is Not Available for Transfer';
        GateEntryLine1: Record "Gate Entry Line_B2B"; //B2BSCM30AUG2023
    begin
        GateEntryHeader := Rec;
        GateEntryHeader.TESTFIELD("Posting Date");
        GateEntryHeader.TESTFIELD("Document Date");
        GateEntryHeader.TestField("Approval Status", GateEntryHeader."Approval Status"::Released);

        GateEntryLine.RESET;
        GateEntryLine.SETRANGE("Entry Type", GateEntryHeader."Entry Type");
        GateEntryLine.SETRANGE("Gate Entry No.", GateEntryHeader."No.");
        if not GateEntryLine.FIND('-') then
            ERROR(Text16500);
        if GateEntryLine.FINDSET then
            repeat

                //B2BSSD07JUN2023>>
                GateEntryLine1.Reset(); //B2BSCM30AUG2023
                GateEntryLine1.SetRange("Gate Entry No.", GateEntryHeader."No."); //B2BSCM30AUG2023
                if GateEntryLine1.FindSet() then //B2BSCM30AUG2023
                    if GateEntryLine1."Avail/UnAvail" = true then begin //B2BSCM30AUG2023
                        Error(ERRORmsg1);
                    end;
                //B2BSSD07JUN2023<<

                //B2BSSD07JUN2023>>
                if GateEntryLine1."Entry Type" = GateEntryLine."Entry Type"::Outward then begin//B2BSCM30AUG2023
                    if GateEntryLine1."Source Type" = GateEntryLine."Source Type"::"Fixed Asset" then begin//B2BSCM30AUG2023
                        FixedAsset.Reset();
                        FixedAsset.SetRange("No.", GateEntryLine."Source No.");
                        if FixedAsset.FindSet() then begin
                            FixedAsset."available/Unavailable" := true;
                            FixedAsset.Modify();
                        end;
                    end;
                end;
                //B2BSSD07JUN2023<<

                //B2BSSD17APR2023>>
                if GateEntryLine1."Entry Type" = GateEntryLine1."Entry Type"::Inward then begin //B2BSCM30AUG2023
                    if GateEntryLine1."Source Type" = GateEntryLine1."Source Type"::"Fixed Asset" then begin //B2BSCM30AUG2023
                        FixedAsset.Reset();
                        FixedAsset.SetRange("No.", GateEntryLine1."Source No."); //B2BSCM30AUG2023
                        if FixedAsset.FindFirst() then begin
                            FixedAsset."available/Unavailable" := false;
                            FixedAsset.Modify();
                        end;
                    end;
                end;
                //B2BSSD17APR2023<<

                /*if GateEntryLine."Source Type" = GateEntryLine."Source Type"::Description then
                    GateEntryLine."Source Type" := GateEntryLine."Source Type"::Description;*/
                if GateEntryLine1."Source Type" = GateEntryLine1."Source Type"::Item then begin //B2BSCM30AUG2023
                    if GateEntryLine1."Source Type" <> 0 then //B2BSCM30AUG2023
                        GateEntryLine1.TESTFIELD("Source No."); //B2BSCM30AUG2023
                    if GateEntryLine1."Source Type" = 0 then //B2BSCM30AUG2023
                        GateEntryLine1.TESTFIELD(Description); //B2BSCM30AUG2023
                end;
            until GateEntryLine.NEXT() = 0;

        if GUIALLOWED then
            Window.OPEN(
              '#1###########################\\' +
              Text16501);
        if GUIALLOWED then
            Window.UPDATE(1, STRSUBSTNO('%1 %2', Text16502, GateEntryHeader."No."));

        if GateEntryHeader."Posting No. Series" = '' then begin
            IF GateEntryLocSetup.GET(GateEntryHeader."Entry Type", GateEntryHeader."Type", GateEntryHeader."Location Code") and (GateEntryLocSetup."Posting No. Series" <> '') then begin
                GateEntryHeader."Posting No. Series" := GateEntryLocSetup."Posting No. Series";
                GateEntryHeader.MODIFY;
                COMMIT;
                //B2B FIX 19Apr2021>>
            end else begin
                Location.Get(GateEntryHeader."Location Code");
                if GateEntryHeader."Entry Type" = GateEntryHeader."Entry Type"::Inward then
                    if GateEntryHeader.Type = GateEntryHeader.Type::RGP then begin
                        Location.TestField("Inward RGP No. Series_B2B");
                        GateEntryHeader."Posting No. Series" := Location."Inward RGP No. Series_B2B";
                    end else
                        if GateEntryHeader.Type = GateEntryHeader.Type::NRGP then begin
                            Location.TestField("Inward NRGP No. Series_B2B");
                            GateEntryHeader."Posting No. Series" := Location."Inward NRGP No. Series_B2B";
                        end;
                if GateEntryHeader."Entry Type" = GateEntryHeader."Entry Type"::Outward then
                    if GateEntryHeader.Type = GateEntryHeader.Type::RGP then begin
                        Location.TestField("Outward RGP No. Series_B2B");
                        GateEntryHeader."Posting No. Series" := Location."Outward RGP No. Series_B2B";
                    end else
                        if GateEntryHeader.Type = GateEntryHeader.Type::NRGP then begin
                            Location.TestField("Outward NRGP No. Series_B2B");
                            GateEntryHeader."Posting No. Series" := Location."Outward NRGP No. Series_B2B";
                        end;
                GateEntryHeader.MODIFY;
                COMMIT;
            end;
            //B2B FIX 19Apr2021<<
        end;
        if GateEntryHeader."Posting No." = '' then begin
            GateEntryHeader."Posting No." := NoSeriesMgt.GetNextNo(GateEntryHeader."Posting No. Series", GateEntryHeader."Posting Date", true);
            ModifyHeader := true;
        end;
        if ModifyHeader then begin
            GateEntryHeader.MODIFY;
            COMMIT;
        end;

        GateEntryLine.LOCKTABLE;

        PostedGateEntryHeader.INIT;
        PostedGateEntryHeader.TRANSFERFIELDS(GateEntryHeader);
        PostedGateEntryHeader."Entry Type" := GateEntryHeader."Entry Type";
        PostedGateEntryHeader.Type := GateEntryHeader.Type;
        PostedGateEntryHeader."No." := GateEntryHeader."Posting No.";
        PostedGateEntryHeader."No. Series" := GateEntryHeader."Posting No. Series";
        PostedGateEntryHeader."Gate Entry No." := GateEntryHeader."No.";

        if GUIALLOWED then
            Window.UPDATE(1, STRSUBSTNO(Text16503, GateEntryHeader."No.", PostedGateEntryHeader."No."));
        PostedGateEntryHeader.INSERT;

        // Posting Comments to posted tables.
        //CopyCommentLines("Entry Type", "Entry Type", "No.", PostedGateEntryHeader."No.");

        Clear(PostdLoadSlpNoGVar);

        GateEntryLine.RESET;
        GateEntryLine.SETRANGE("Entry Type", GateEntryHeader."Entry Type");
        GateEntryLine.SetRange(Type, GateEntryHeader.Type);
        GateEntryLine.SETRANGE("Gate Entry No.", GateEntryHeader."No.");
        LineCount := 0;
        GateEntType := GateEntryLine."Source Type";
        PostdLoadSlpNoGVar := GateEntryLine."Source No.";
        if GateEntryLine.FINDSET then
            repeat
                LineCount += 1;
                if GUIALLOWED then
                    Window.UPDATE(2, LineCount);
                PostedGateEntryLine.INIT;
                PostedGateEntryLine.TRANSFERFIELDS(GateEntryLine);
                PostedGateEntryLine."Entry Type" := PostedGateEntryHeader."Entry Type";
                PostedGateEntryLine.Type := PostedGateEntryHeader.Type;
                PostedGateEntryLine."Gate Entry No." := PostedGateEntryHeader."No.";
                PostedGateEntryLine.INSERT;

                //B2BVCOn09Nov2023 >>
                PurchLineGRec.Reset();
                PurchLineGRec.SetRange("Document No.", PostedGateEntryLine."Purchase Order No.");
                PurchLineGRec.SetRange("Line No.", PostedGateEntryLine."Purchase Order Line No.");
                if PurchLineGRec.FindFirst() then begin
                    PurchLineGRec."Posted Gate Entry No." := PostedGateEntryLine."Gate Entry No.";
                    PurchLineGRec."Posted Gate Entry Line No." := PostedGateEntryLine."Line No.";
                    PurchLineGRec.validate("Qty. to Receive", (PostedGateEntryLine.Quantity + PurchLineGRec."Inward Qty") - PurchLineGRec."Quantity Received"); //B2BVCOn01Feb2024

                    PurchLineGRec.Validate("Qty. to Invoice", (PostedGateEntryLine.Quantity + PurchLineGRec."Inward Qty") - PurchLineGRec."Quantity Invoiced"); //B2BVCOn01Feb2024
                    PurchLineGRec."Inward Qty" += PurchLineGRec."Qty. to Receive"; //B2BVCOn01Feb2024
                    PurchLineGRec.Modify();
                end;
            //B2BVCOn09Nov2023 <<
            until GateEntryLine.NEXT = 0;


        //B2BMSOn04Nov2022>>
        PurchLine.Reset();
        PurchLine.SetRange("Ref. Posted Gate Entry", GateEntryHeader."No.");
        if PurchLine.FindFirst() then begin
            PurchLine."Ref. Posted Gate Entry" := PostedGateEntryHeader."No.";
            PurchLine.Modify();
        end;
        //B2BMSOn04Nov2022<<

        //PostGate();
        Message('Posted GateEntry No is %1', PostedGateEntryHeader."No.");

        //PK Identified
        GateEntryHeader.DELETE;
        GateEntryLine.DELETEALL;
        if GUIALLOWED then
            Window.CLOSE;
        Rec := GateEntryHeader;
        Commit();//PK-Added
                 //SendMailAlerts(GateEntryHeader);//PK-Added                       
    end;

    var
        QtyRECIVEvAR: Decimal;
        QtyRECIVEvAR1: Decimal;
        QtyRECIVEvAR2: Decimal;

        PostdLoadSlpNoGVar: Code[20];
        GateEntType: integer;
        GateEntryHeader: Record "Gate Entry Header_B2B";
        GateEntryLine: Record "Gate Entry Line_B2B";
        GateEntryLineGvar: Record "Gate Entry Line_B2B";
        PostedGateEntryHeader: Record "Posted Gate Entry Header_B2B";
        PostedGateEntryLine: Record "Posted Gate Entry Line_B2B";
        Text16500: Label 'There is nothing to post.';
        Text16501: Label 'Posting Lines #2######\';
        Text16502: Label 'Gate Entry.';
        Text16503: Label 'Gate Entry %1 -> Posted Gate Entry %2.';
        GateEntryLocSetup: Record "Gate Entry Location Setup_B2B";
        //GateEntryCommentLine: Record "Gate Entry Comment Line";
        //GateEntryCommentLine2: Record "Gate Entry Comment Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Window: Dialog;
        ModifyHeader: Boolean;
        LineCount: Integer;
        Mailmng: Codeunit "Mail Management";
        PurchLine: Record "Purchase Line"; //B2BMSOn04Nov2022
        indentLine: Record "Indent Line";
        indentHeader: Record "Indent Header";
        FixedAsset: Record "Fixed Asset";
        PurchLineGRec: Record "Purchase Line";

    procedure CopyCommentLines(FromEntryType: Integer; ToEntryType: Integer; FromNumber: Code[20]; ToNumber: Code[20]);
    begin
        /* GateEntryCommentLine.SETRANGE("Gate Entry Type", FromEntryType);
         GateEntryCommentLine.SETRANGE("No.", FromNumber);
         if GateEntryCommentLine.FINDSET then
             repeat
                 GateEntryCommentLine2 := GateEntryCommentLine;
                 GateEntryCommentLine2."Gate Entry Type" := ToEntryType;
                 GateEntryCommentLine2."No." := ToNumber;
                 GateEntryCommentLine2.INSERT;
             until GateEntryCommentLine.NEXT = 0;*/
    end;




}

