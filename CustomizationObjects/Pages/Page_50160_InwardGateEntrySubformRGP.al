page 50160 "Inward Gate Entry SubFrm-RGP"
{
    Caption = 'RGP-INWARD Subform';
    AutoSplitKey = true;
    DelayedInsert = TRUE;
    PageType = ListPart;
    SourceTable = "Gate Entry Line_B2B";
    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Challan No."; "Challan No.")
                {
                    ApplicationArea = ALL;
                }
                field("Challan Date"; "Challan Date")
                {
                    ApplicationArea = ALL;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = ALL;
                    OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Item,Fixed Asset,Others';//Baluonoct112022

                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = ALL;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                        SalesShipHeader: record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        GateEntryLneLRec: Record "Gate Entry Line_B2B";
                        GateEntLneLRec: Record "Gate Entry Line_B2B";
                        LineNoLVar: Integer;
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                        //TraVeh: record "Transporter Vehicle";
                        SourName: text[100];
                    begin
                        GateEntryHeader.GET("Entry Type", "Type", "Gate Entry No.");
                        case "Source Type" of
                            "Source Type"::"Sales Shipment":
                                begin
                                    SalesShipHeader.RESET;
                                    SalesShipHeader.FILTERGROUP(2);
                                    SalesShipHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    SalesShipHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, SalesShipHeader) = ACTION::LookupOK then begin
                                        "Source No." := SalesShipHeader."No.";
                                        "Source Name" := SalesShipHeader."Bill-to Name";
                                    end;
                                end;

                            "Source Type"::"Sales Return Order":
                                begin
                                    SalesHeader.RESET;
                                    SalesHeader.FILTERGROUP(2);
                                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Return Order");
                                    SalesHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    SalesHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, SalesHeader) = ACTION::LookupOK then
                                        VALIDATE("Source No.", SalesHeader."No.");
                                end;

                            "Source Type"::"Purchase Order":
                                begin
                                    PurchHeader.RESET;
                                    PurchHeader.FILTERGROUP(2);
                                    PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                                    PurchHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    PurchHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, PurchHeader) = ACTION::LookupOK then
                                        VALIDATE("Source No.", PurchHeader."No.");
                                end;
                            "Source Type"::"Purchase Return Shipment":
                                begin
                                    ReturnShipHeader.RESET;
                                    ReturnShipHeader.FILTERGROUP(2);
                                    ReturnShipHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    ReturnShipHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, ReturnShipHeader) = ACTION::LookupOK then begin
                                        "Source No." := ReturnShipHeader."No.";
                                        "Source Name" := ReturnShipHeader."Pay-to Name";
                                    end;
                                end;

                            "Source Type"::"Transfer Receipt":
                                begin
                                    TransHeader.RESET;
                                    TransHeader.FILTERGROUP(2);
                                    TransHeader.SETRANGE("Transfer-to Code", GateEntryHeader."Location Code");
                                    TransHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, TransHeader) = ACTION::LookupOK then
                                        VALIDATE("Source No.", TransHeader."No.");
                                end;
                            "Source Type"::"Transfer Shipment":
                                begin
                                    TransShptHeader.RESET;
                                    TransShptHeader.FILTERGROUP(2);
                                    TransShptHeader.SETRANGE("Transfer-from Code", GateEntryHeader."Location Code");
                                    TransShptHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, TransShptHeader) = ACTION::LookupOK then begin
                                        "Source No." := TransShptHeader."No.";
                                        "Source Name" := TransShptHeader."Transfer-to Name";
                                    end;
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        SalesShipHeader: Record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        Text16500: Label 'Source Type must not be blank in %1 %2.';

                    begin

                        if "Source Type" = 0 then
                            ERROR(Text16500, FIELDCAPTION("Line No."), "Line No.");

                        if "Source No." <> xRec."Source No." then
                            "Source Name" := '';
                        if "Source No." = '' then begin
                            "Source Name" := '';
                            exit;
                        end;
                        case "Source Type" of
                            "Source Type"::"Purchase Order":
                                begin
                                    PurchHeader.GET(PurchHeader."Document Type"::Order, "Source No.");
                                    "Source Name" := PurchHeader."Pay-to Name";
                                end;
                            "Source Type"::"Purchase Return Shipment":
                                begin
                                    ReturnShipHeader.GET("Source No.");
                                    "Source Name" := ReturnShipHeader."Pay-to Name";
                                end;
                            "Source Type"::"Transfer Shipment":
                                begin
                                    TransShptHeader.GET("Source No.");
                                    "Source Name" := TransShptHeader."Transfer-to Name";
                                end;
                        end;

                    end;
                }
                field("Source Name"; "Source Name")
                {
                    ApplicationArea = ALL;
                    Editable = false;
                }
                field("Posted RGP OUT NO."; "Posted RGP OUT NO.")
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PRGPLineRec: Record "Posted Gate Entry Line_B2B";
                    begin
                        PRGPLineRec.Reset();
                        PRGPLineRec.SetRange("Entry Type", PRGPLineRec."Entry Type"::Outward);
                        PRGPLineRec.SetRange(Type, PRGPLineRec.Type::RGP);
                        PRGPLineRec.SetRange("Source Type", "Source Type");
                        PRGPLineRec.SetRange("Source No.", "Source No.");
                        IF PRGPLineRec.FINDFIRST THEN
                            if PAGE.RUNMODAL(0, PRGPLineRec) = ACTION::LookupOK then begin
                                "Posted RGP OUT NO." := PRGPLineRec."Gate Entry No.";
                                "Posted RGP OUT NO. Line" := PRGPLineRec."Line No.";
                            end;

                    end;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        PRGPLineRec: Record "Posted Gate Entry Line_B2B";

                    begin
                        PRGPLineRec.Reset();
                        PRGPLineRec.SetRange("Entry Type", PRGPLineRec."Entry Type"::Outward);
                        PRGPLineRec.SetRange(Type, PRGPLineRec.Type::RGP);
                        PRGPLineRec.SetRange("Gate Entry No.", "Posted RGP OUT NO.");
                        PRGPLineRec.SetRange("Line No.", "Posted RGP OUT NO. Line");
                        PRGPLineRec.SetRange("Source Type", "Source Type");
                        PRGPLineRec.SetRange("Source No.", "Source No.");
                        IF PRGPLineRec.FINDFIRST THEN bEGIN
                            PRGPLineRec.CALCFIELDS("Quantity Received");
                            IF (Quantity + PRGPLineRec."Quantity Received") > PRGPLineRec.Quantity THEN
                                Error('Total Quantity should be less than sent quantity.');
                        end;
                    end;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = all;

                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;

                }
                field("Source Line No."; "Source Line No.")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                //BaluonNov82022>>
                field(Variant; rec.Variant)
                {
                    ApplicationArea = all;
                }
                field(ModelNo; rec.ModelNo)
                {
                    ApplicationArea = all;
                }
                field(SerialNo; rec.SerialNo)
                {
                    ApplicationArea = all;
                }
                //BaluonNov82022<<
            }
        }


    }
    actions
    {
        area(processing)
        {
            action("Get Posted RGP")
            {
                Image = GetLines;
                trigger OnAction()
                begin
                    GetRGPOutLines();
                end;
            }

        }
    }


    trigger OnModifyRecord(): Boolean
    var
        GatEntHdrLRec: Record "Gate Entry Header_B2B";
    BEGIN
        IF GatEntHdrLRec.get("Entry Type", "Type", "Gate Entry No.") then
            GatEntHdrLRec.TestField("Approval Status", GatEntHdrLRec."Approval Status"::Open);
    END;


    /*procedure GetRGPOutLines()
    var
        RGPLineRec: Record "Posted Gate Entry Line";
        GatePassLines: page "Posted Gate Entry Line List";
        RGPLineRec2: Record "Posted Gate Entry Line";
        GateLine: Record "Gate Entry Line";
        LineNo: Integer;
    begin
        RGPLineRec.RESET;
        RGPLineRec.SETRANGE("Entry Type", RGPLineRec."Entry Type"::Outward);
        RGPLineRec.SETRANGE(Type, RGPLineRec.Type::RGP);
        RGPLineRec.SETFILTER(Quantity, '>%1', 0);
        IF RGPLineRec.FINDFIRST THEN
            REPEAT
                RGPLineRec.CALCFIELDS("Quantity Received");
                IF (RGPLineRec.Quantity - RGPLineRec."Quantity Received") > 0 THEN
                    RGPLineRec.MARK(TRUE);
            UNTIL RGPLineRec.NEXT = 0;


        RGPLineRec.MARKEDONLY(TRUE);
        clear(LineNo);
        CLEAR(GatePassLines);
        GatePassLines.SETTABLEVIEW(RGPLineRec);
        GatePassLines.LOOKUPMODE := TRUE;
        IF GatePassLines.RUNMODAL = ACTION::LookupOK THEN begin
            GatePassLines.SetSelection(RGPLineRec2);
            if RGPLineRec2.FINDSET then BEGIN
                GateLine.Reset();
                GateLine.SetRange(Type, Type);
                GateLine.SetRange("Entry Type", "Entry Type");
                GateLine.SetRange("Gate Entry No.", "Gate Entry No.");
                IF GateLine.FINDLAST THEN
                    LineNo := GateLine."Line No.";
                repeat
                    GateLine.INIT();
                    GateLine."Entry Type" := "Entry Type";
                    GateLine.Type := Type;
                    GateLine."Gate Entry No." := "Gate Entry No.";
                    LineNo := LineNo + 10000;
                    GateLine."Line No." := LineNo;
                    GateLine.Insert();
                    GateLine."Source Type" := RGPLineRec2."Source Type";
                    GateLine."Source No." := RGPLineRec2."Source No.";
                    GateLine."Source Name" := RGPLineRec2."Source Name";
                    RGPLineRec2.CALCFIELDS("Quantity Received");
                    GateLine.Quantity := RGPLineRec2.Quantity - RGPLineRec2."Quantity Received";
                    GateLine."Unit of Measure" := RGPLineRec2."Unit of Measure";
                    GateLine."Posted RGP OUT NO." := RGPLineRec2."Gate Entry No.";
                    GateLine."Posted RGP OUT NO. Line" := RGPLineRec2."Line No.";
                    GateLine.Modify();
                Until RGPLineRec2.NEXT = 0;
                Message('Lines Inserted.');
            end;
        end;

    end;*/


    procedure GetRGPOutLines()
    var
        RGPLineRec: Record "Posted Gate Entry Line_B2B";
        GatePassLines: page "Posted Gate Entry Line List";
        RGPLineRec2: Record "Posted Gate Entry Line_B2B";
        GateLine: Record "Gate Entry Line_B2B";
        LineNo: Integer;
        EntriesExist: Boolean;
        GateLne: Record "Gate Entry Line_B2B";
    begin
        RGPLineRec.RESET;
        RGPLineRec.SETRANGE("Entry Type", RGPLineRec."Entry Type"::Outward);
        RGPLineRec.SETRANGE(Type, RGPLineRec.Type::RGP);
        RGPLineRec.SETFILTER(Quantity, '>%1', 0);
        IF RGPLineRec.FINDFIRST THEN
            REPEAT
                RGPLineRec.CALCFIELDS("Quantity Received");
                IF (RGPLineRec.Quantity - RGPLineRec."Quantity Received") > 0 THEN
                    RGPLineRec.MARK(TRUE);
            UNTIL RGPLineRec.NEXT = 0;


        RGPLineRec.MARKEDONLY(TRUE);

        CLEAR(GatePassLines);
        clear(LineNo);

        GatePassLines.SETTABLEVIEW(RGPLineRec);
        GatePassLines.LOOKUPMODE := TRUE;
        IF GatePassLines.RUNMODAL = ACTION::LookupOK THEN begin
            GatePassLines.SetSelection(RGPLineRec2);
            if RGPLineRec2.FINDSET then BEGIN
                repeat
                    clear(EntriesExist);

                    GateLine.Reset();
                    GateLine.SetRange("Entry Type", "Entry Type");
                    GateLine.SetRange("Gate Entry No.", "Gate Entry No.");
                    GateLine.SetFilter("Challan No.", '<>%1', '');
                    GateLine.SetFilter("Challan Date", '<>%1', 0D);
                    GateLine.SetFilter("Posted RGP OUT NO.", '%1', '');
                    IF GateLine.FindFirst() THEN BEGIN
                        LineNo := GateLine."Line No.";
                        EntriesExist := true;
                    end
                    else BEGIN
                        LineNo += 10000;
                        EntriesExist := FALSE;
                    end;
                    IF EntriesExist = FALSE THEN BEGIN
                        GateLine.INIT();
                        GateLine."Entry Type" := "Entry Type";
                        GateLine.Type := Type;
                        GateLine."Gate Entry No." := "Gate Entry No.";
                        //LineNo := LineNo + 10000;
                        GateLine."Line No." := LineNo;
                        GateLine.Insert();
                        GateLine."Source Type" := RGPLineRec2."Source Type";
                        GateLine."Source No." := RGPLineRec2."Source No.";
                        GateLine."Source Name" := RGPLineRec2."Source Name";
                        RGPLineRec2.CALCFIELDS("Quantity Received");
                        GateLine.Quantity := RGPLineRec2.Quantity - RGPLineRec2."Quantity Received";
                        GateLine."Unit of Measure" := RGPLineRec2."Unit of Measure";
                        GateLine."Posted RGP OUT NO." := RGPLineRec2."Gate Entry No.";
                        GateLine."Posted RGP OUT NO. Line" := RGPLineRec2."Line No.";
                        GateLine.Modify();
                    END ELSE BEGIN
                        GateLne.reset;
                        GateLne.SetRange("Entry Type", "Entry Type");
                        GateLne.SetRange(Type, Type);
                        GateLne.SetRange("Gate Entry No.", "Gate Entry No.");
                        GateLne.SetRange("Line No.", LineNo);
                        IF GateLne.findfirst then begin
                            GateLine."Source Type" := RGPLineRec2."Source Type";
                            GateLine."Source No." := RGPLineRec2."Source No.";
                            GateLine."Source Name" := RGPLineRec2."Source Name";
                            RGPLineRec2.CALCFIELDS("Quantity Received");
                            GateLine.Quantity := RGPLineRec2.Quantity - RGPLineRec2."Quantity Received";
                            GateLine."Unit of Measure" := RGPLineRec2."Unit of Measure";
                            GateLine."Posted RGP OUT NO." := RGPLineRec2."Gate Entry No.";
                            GateLine."Posted RGP OUT NO. Line" := RGPLineRec2."Line No.";
                            GateLine.Modify();
                        end;
                    END;
                Until RGPLineRec2.NEXT = 0;
                Message('Lines Inserted.');
            end;
        end;

    end;




    var
        GatEntHdrGRec: REcord "Gate Entry Header_B2B";
}

