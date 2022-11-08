codeunit 50019 "Gate Entry- Post"
{
    // version NAVIN7.00

    TableNo = "Gate Entry Header_B2B";
    //Permissions = tabledata "E-mail Log" = rimd;

    trigger OnRun();
    var
        InvSetUp: Record "Inventory Setup";
        Location: Record Location;
    begin
        GateEntryHeader := Rec;
        with GateEntryHeader do begin
            TESTFIELD("Posting Date");
            TESTFIELD("Document Date");
            TestField("Approval Status", "Approval Status"::Released);

            GateEntryLine.RESET;
            GateEntryLine.SETRANGE("Entry Type", "Entry Type");
            GateEntryLine.SETRANGE("Gate Entry No.", "No.");
            if not GateEntryLine.FIND('-') then
                ERROR(Text16500);

            if GateEntryLine.FINDSET then
                repeat
                    if GateEntryLine."Source Type" <> 0 then
                        GateEntryLine.TESTFIELD("Source No.");
                    if GateEntryLine."Source Type" = 0 then
                        GateEntryLine.TESTFIELD(Description);
                until GateEntryLine.NEXT = 0;

            if GUIALLOWED then
                Window.OPEN(
                  '#1###########################\\' +
                  Text16501);
            if GUIALLOWED then
                Window.UPDATE(1, STRSUBSTNO('%1 %2', Text16502, "No."));

            if "Posting No. Series" = '' then begin
                IF GateEntryLocSetup.GET("Entry Type", "Type", "Location Code") and (GateEntryLocSetup."Posting No. Series" <> '') then begin
                    "Posting No. Series" := GateEntryLocSetup."Posting No. Series";
                    MODIFY;
                    COMMIT;
                    //B2B FIX 19Apr2021>>
                end else begin
                    Location.Get(GateEntryHeader."Location Code");
                    if "Entry Type" = "Entry Type"::Inward then
                        if Type = Type::RGP then begin
                            Location.TestField("Inward RGP No. Series_B2B");
                            "Posting No. Series" := Location."Inward RGP No. Series_B2B";
                        end else
                            if Type = Type::NRGP then begin
                                Location.TestField("Inward NRGP No. Series_B2B");
                                "Posting No. Series" := Location."Inward NRGP No. Series_B2B";
                            end;
                    if "Entry Type" = "Entry Type"::Outward then
                        if Type = Type::RGP then begin
                            Location.TestField("Outward RGP No. Series_B2B");
                            "Posting No. Series" := Location."Outward RGP No. Series_B2B";
                        end else
                            if Type = Type::NRGP then begin
                                Location.TestField("Outward NRGP No. Series_B2B");
                                "Posting No. Series" := Location."Outward NRGP No. Series_B2B";
                            end;
                    MODIFY;
                    COMMIT;
                end;
                //B2B FIX 19Apr2021<<
            end;
            if "Posting No." = '' then begin
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", true);
                ModifyHeader := true;
            end;
            if ModifyHeader then begin
                MODIFY;
                COMMIT;
            end;

            GateEntryLine.LOCKTABLE;

            PostedGateEntryHeader.INIT;
            PostedGateEntryHeader.TRANSFERFIELDS(GateEntryHeader);
            PostedGateEntryHeader."Entry Type" := "Entry Type";
            PostedGateEntryHeader.Type := Type;
            PostedGateEntryHeader."No." := "Posting No.";
            PostedGateEntryHeader."No. Series" := "Posting No. Series";
            PostedGateEntryHeader."Gate Entry No." := "No.";

            if GUIALLOWED then
                Window.UPDATE(1, STRSUBSTNO(Text16503, "No.", PostedGateEntryHeader."No."));
            PostedGateEntryHeader.INSERT;

            // Posting Comments to posted tables.
            //CopyCommentLines("Entry Type", "Entry Type", "No.", PostedGateEntryHeader."No.");

            Clear(PostdLoadSlpNoGVar);

            GateEntryLine.RESET;
            GateEntryLine.SETRANGE("Entry Type", "Entry Type");
            GateEntryLine.SetRange(Type, Type);
            GateEntryLine.SETRANGE("Gate Entry No.", "No.");
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
            DELETE;
            GateEntryLine.DELETEALL;
        end;
        if GUIALLOWED then
            Window.CLOSE;
        Rec := GateEntryHeader;
        Commit();//PK-Added
        //SendMailAlerts(GateEntryHeader);//PK-Added                       
    end;

    var
        PostdLoadSlpNoGVar: Code[20];
        GateEntType: integer;
        GateEntryHeader: Record "Gate Entry Header_B2B";
        GateEntryLine: Record "Gate Entry Line_B2B";
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

