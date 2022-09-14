page 50147 "Outward Gate Entry SubFrm-NRGP"
{
    Caption = 'NRGP-OUTWARD Subform';
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Gate Entry Line_B2B";
    UsageCategory = Tasks;
    ApplicationArea = ALL;
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
                    OptionCaption = ',Posted Loading Slip,Sales Shipment,,,Purchase Return Shipment,,Transfer Shipment,,';
                    trigger OnValidate()
                    begin
                        //PKON22JA5>>CR220003
                        If "Source Type" = "Source Type"::"Posted Loading Slip" THEN
                            Error('you cannot select posted loading slip');
                        //PKON22JA5<<CR220003
                    end;
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
                        //PostdLoadngSLip: Record "Posted Loading SLip Header";

                        //PostdLoadSlpLRec: Record "Posted Loading Slip Line";
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
                            /*
                        "Source Types"::"Sales Return Order":
                            begin
                                SalesHeader.RESET;
                                SalesHeader.FILTERGROUP(2);
                                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Return Order");
                                SalesHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                SalesHeader.FILTERGROUP(0);
                                if PAGE.RUNMODAL(0, SalesHeader) = ACTION::LookupOK then
                                    VALIDATE("Source No.", SalesHeader."No.");
                            end;*/
                            /*
                        "Source Types"::"Purchase Order":
                            begin
                                PurchHeader.RESET;
                                PurchHeader.FILTERGROUP(2);
                                PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                                PurchHeader.SETRANGE("Location Code", GateEntryHeader."Location Code");
                                PurchHeader.FILTERGROUP(0);
                                if PAGE.RUNMODAL(0, PurchHeader) = ACTION::LookupOK then
                                    VALIDATE("Source No.", PurchHeader."No.");
                            end;*/
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
                            /*   
                           "Source Types"::"Transfer Receipt":
                               begin
                                   TransHeader.RESET;
                                   TransHeader.FILTERGROUP(2);
                                   TransHeader.SETRANGE("Transfer-to Code", GateEntryHeader."Location Code");
                                   TransHeader.FILTERGROUP(0);
                                   if PAGE.RUNMODAL(0, TransHeader) = ACTION::LookupOK then
                                       VALIDATE("Source No.", TransHeader."No.");
                               end;
                               */
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
                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;
                }
                field("Source Line No."; "Source Line No.")
                {

                }
            }
        }
    }

    actions
    {
    }
    //PKON22JA5>>CR220003
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GatePassHdr: Record "Gate Entry Header_B2B";
    begin
        GatePassHdr.reset;
        GatePassHdr.SetRange("Entry Type", "Entry Type");
        GatePassHdr.SetRange("No.", "Gate Entry No.");
        IF GatePassHdr.findfirst then
            If GatePassHdr."LR/RR No." <> '' then
                Error('You can not insert the lines manually');
    end;

    trigger OnModifyRecord(): Boolean
    var
        GatePassHdr: Record "Gate Entry Header_B2B";
    begin
        GatePassHdr.reset;
        GatePassHdr.SetRange("Entry Type", "Entry Type");
        GatePassHdr.SetRange("No.", "Gate Entry No.");
        IF GatePassHdr.findfirst then
            If GatePassHdr."LR/RR No." <> '' then
                Error('You can not Modify the lines manually');
    end;

    trigger OnDeleteRecord(): Boolean
    var
        GatePassHdr: Record "Gate Entry Header_B2B";
    begin
        GatePassHdr.reset;
        GatePassHdr.SetRange("Entry Type", "Entry Type");
        GatePassHdr.SetRange("No.", "Gate Entry No.");
        IF GatePassHdr.findfirst then
            If GatePassHdr."LR/RR No." <> '' then
                Error('You can not Delete the lines');
    end;
    //PKON22JA5<<CR220003
    var
        GatEntHdrGRec: Record "Gate Entry Header_B2B";
}

