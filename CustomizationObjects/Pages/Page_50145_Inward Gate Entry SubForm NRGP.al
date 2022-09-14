page 50145 "Inward Gate Entry SubFrm-NRGP"
{
    // version NAVIN7.00
    Caption = 'NRGP-INWARD Subform';
    AutoSplitKey = true;
    UsageCategory = Tasks;
    ApplicationArea = all;
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
                    OptionCaption = ',,,Sales Return Order,Purchase Order,,Transfer Receipt,,,';


                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = ALL;
                    trigger OnValidate()
                    var
                        SalesShipHeader: Record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                    BEGIN
                        if "Source Type" = 0 then
                            ERROR(Text16500, FIELDCAPTION("Line No."), "Line No.");
                        if "Source No." <> xRec."Source No." then
                            "Source Name" := '';
                        if "Source No." = '' then begin
                            "Source Name" := '';
                            exit;
                        end;

                        case "Source Type" of
                            "Source Type"::"Sales Return Order":
                                begin
                                    SalesHeader.GET(SalesHeader."Document Type"::"Return Order", "Source No.");
                                    "Source Name" := SalesHeader."Bill-to Name";
                                end;
                            "Source Type"::"Purchase Order":
                                begin
                                    PurchHeader.GET(PurchHeader."Document Type"::Order, "Source No.");
                                    "Source Name" := PurchHeader."Pay-to Name";
                                end;
                            "Source Type"::"Transfer Receipt":
                                begin
                                    TransHeader.GET("Source No.");
                                    "Source Name" := TransHeader."Transfer-from Name";
                                end;
                        end;

                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                        SalesShipHeader: record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        // PostdLoadngSLip: Record "Posted Loading SLip Header";

                        //PostdLoadSlpLRec: Record "Posted Loading Slip Line";
                        GateEntryLneLRec: Record "Gate Entry Line_B2B";
                        GateEntLneLRec: Record "Gate Entry Line_B2B";
                        LineNoLVar: Integer;
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                    begin
                        GateEntryHeader.GET("Entry Type", "Type", "Gate Entry No.");
                        case "Source Type" of
                            "Source Type"::"Sales Return Order":
                                begin
                                    SalesHeader.RESET;
                                    SalesHeader.FILTERGROUP(2);
                                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Return Order");
                                    SalesHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    SalesHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, SalesHeader) = ACTION::LookupOK then begin
                                        "Source No." := SalesHeader."No.";
                                        "Source Name" := SalesHeader."Bill-to Name";
                                    end;
                                end;
                            "Source Type"::"Purchase Order":
                                begin
                                    PurchHeader.RESET;
                                    PurchHeader.FILTERGROUP(2);
                                    PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                                    PurchHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                    PurchHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, PurchHeader) = ACTION::LookupOK then begin
                                        "Source No." := PurchHeader."No.";
                                        "Source Name" := PurchHeader."Pay-to Name";
                                    end;
                                end;
                            /*
                        "Source Type"::"Purchase Return Shipment":
                            begin
                                ReturnShipHeader.RESET;
                                ReturnShipHeader.FILTERGROUP(2);
                                ReturnShipHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                ReturnShipHeader.FILTERGROUP(0);
                                if PAGE.RUNMODAL(0, ReturnShipHeader) = ACTION::LookupOK then
                                    VALIDATE("Source No.", ReturnShipHeader."No.");
                            end;*/
                            "Source Type"::"Transfer Receipt":
                                begin
                                    TransHeader.RESET;
                                    TransHeader.FILTERGROUP(2);
                                    TransHeader.SETRANGE("Transfer-to Code", GateEntryHeader."Location Code");
                                    TransHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, TransHeader) = ACTION::LookupOK then begin
                                        "Source No." := TransHeader."No.";
                                        "Source Name" := TransHeader."Transfer-from Name";
                                    end;
                                end;
                        /*
                    "Source Type"::"Transfer Shipment":
                        begin
                            TransShptHeader.RESET;
                            TransShptHeader.FILTERGROUP(2);
                            TransShptHeader.SETRANGE("Transfer-from Code", GateEntryHeader."Location Code");
                            TransShptHeader.FILTERGROUP(0);
                            if PAGE.RUNMODAL(0, TransShptHeader) = ACTION::LookupOK then
                                VALIDATE("Source No.", TransShptHeader."No.");
                        end;*/
                        /*
                    "Source Type"::"Posted Loading Slip":
                        begin
                            PostdLoadngSLip.RESET;
                            IF PAGE.RunModal(0, PostdLoadngSLip) = Action::LookupOK then BEGIN
                                "Source No." := PostdLoadngSLip."No.";
                                GatEntHdrGRec.reset;
                                GatEntHdrGRec.SetRange("Entry Type", "Entry Type");
                                GatEntHdrGRec.SetRange("No.", "Gate Entry No.");
                                IF GatEntHdrGRec.findfirst then BEGIN
                                    GatEntHdrGRec."Vehicle No." := PostdLoadngSLip."Vehicle No.";
                                    GatEntHdrGRec.modify;
                                END;

                                CurrPage.update();
                                PostdLoadSlpLRec.Reset();
                                PostdLoadSlpLRec.SetRange("Document No.", "Source No.");
                                IF PostdLoadSlpLRec.findset then
                                    repeat
                                        GateEntryLneLRec.reset;
                                        GateEntryLneLRec.SetRange("Gate Entry No.", "Gate Entry No.");
                                        GateEntryLneLRec.SetFilter("Source Line No.", '=%1', 0);
                                        IF GateEntryLneLRec.FindFirst() then begin
                                            GateEntryLneLRec."Source Line No." := PostdLoadSlpLRec."Line No.";
                                            GateEntryLneLRec.Description := PostdLoadSlpLRec.Description;
                                            GateEntryLneLRec.modify;
                                        end ELSE BEGIN
                                            GateEntLneLRec.reset;
                                            GateEntLneLRec.SetRange("Gate Entry No.", "Gate Entry No.");
                                            IF GateEntLneLRec.findlast then
                                                LineNoLVar := GateEntLneLRec."Line No."
                                            else
                                                LineNoLVar := 0;

                                            GateEntLneLRec.Init();
                                            GateEntLneLRec."Gate Entry No." := "Gate Entry No.";
                                            GateEntLneLRec."Line No." := (LineNoLVar + 10000);

                                            GateEntLneLRec."Source No." := "Source No.";
                                            GateEntLneLRec."Source Type" := GateEntLneLRec."Source Type"::"Posted Loading Slip";
                                            GateEntLneLRec.Description := PostdLoadSlpLRec.Description;
                                            GateEntLneLRec."Source Line No." := PostdLoadSlpLRec."Line No.";
                                            GateEntLneLRec.Insert();


                                        END;
                                    until PostdLoadSlpLRec.next = 0;
                            end;
                        end;*/
                        end;
                    end;


                }
                field("Source Name"; "Source Name")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;
                }
                field("Source Line No."; "Source Line No.")
                {
                    ApplicationArea = ALL;
                }
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

    var
        GatEntHdrGRec: REcord "Gate Entry Header_B2B";
}

