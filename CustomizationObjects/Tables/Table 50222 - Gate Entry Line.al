table 50222 "Gate Entry Line_B2B"
{
    // version NAVIN7.00

    DataClassification = CustomerContent;
    LookupPageId = "Inward Gate Entry SubFrm-NRGP";
    DrillDownPageId = "Inward Gate Entry SubFrm-NRGP";

    fields
    {
        field(1; "Entry Type"; Enum GateEntryInOutWard)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Gate Entry No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gate Entry Header_B2B"."No." WHERE("Entry Type" = FIELD("Entry Type"));
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Source Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Sales Shipment","Sales Return Order","Purchase Order","Purchase Return Shipment","Transfer Receipt","Transfer Shipment","Item","Fixed Asset",Others,Indent,Description;
            trigger OnValidate();
            begin
                if "Source Type" <> xRec."Source Type" then begin
                    "Source No." := '';
                    "Source Name" := '';
                end;
            end;
        }
        field(5; "Source No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Item)) Item
            ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset"
            else
            if ("Source Type" = const("Purchase Order")) "Purchase Header";//B2BSSD03MAY2023
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                FALRec: Record "Fixed Asset";
                Item: Record Item;
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                //B2BSSD06APR2023<<
                case "Source Type" of
                    Rec."Source Type"::"Fixed Asset":
                        IF FALRec.GET("Source No.") THEN BEGIN
                            "Source No." := FALRec."No.";
                            Description := FALRec.Description;
                            Variant := FALRec.Make_B2B;
                            "Source Name" := FALRec.Description;
                            Description := FALRec."Description";
                            ModelNo := FALRec."Model No.";
                            SerialNo := FALRec."Serial No.";
                            "Avail/UnAvail" := FALRec."available/Unavailable";//B2BSSD07JUN2023
                        END;
                    Rec."Source Type"::Item:
                        if Item.Get("Source No.") then begin
                            "Source No." := Item."No.";
                            "Source Name" := Item.Description;
                            Description := Item.Description;
                            "Unit of Measure" := Item."Base Unit of Measure";
                        end;
                end;
                if (StrPos("Source No.", ',')) > 1 then begin
                    if SelectStr(2, Rec."Source No.") = 'FIXED ASSET' then
                        Rec."Source Type" := Rec."Source Type"::"Fixed Asset"
                    else
                        Rec."Source Type" := Rec."Source Type"::Item;
                    IF SelectStr(1, Rec."Source No.") <> '' then begin
                        Rec."Source No." := SelectStr(1, Rec."Source No.");
                        if Rec."Source Type" = Rec."Source Type"::"Fixed Asset" then
                            Validate(Quantity, 1);
                        if FALRec.Get(Rec."Source No.") then
                            Rec.ModelNo := FALRec."Model No.";
                        Rec.SerialNo := FALRec."Serial No.";
                        Rec."Source Name" := FALRec."Description";
                        Rec.Description := FALRec."Description";
                        Rec.Variant := FALRec.Make_B2B;
                    END;
                end;
                //B2BSSD06APR2023>>

                //B2BSSD25APR2023<<
                ItemLedgEntry.Reset();
                ItemLedgEntry.SetRange("Item No.", "Source No.");
                itemLedgEntry.SetRange("Variant Code", Variant);
                if itemLedgEntry.FindLast then
                    repeat
                        "Avail Qty" += ItemLedgEntry."Remaining Quantity";
                    until ItemLedgEntry.Next() = 0;
                //B2BSSD25APR2023>>
            end;


        }
        field(6; "Source Name"; Text[200])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Close;
        }
        field(8; Description; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Source Line No."; integer)
        {
            Editable = false;
        }
        field(23; "Type"; Enum GateEntryType)
        {
            DataClassification = CustomerContent;
        }

        field(24; "Posted RGP OUT NO."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(26; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            //B2BSSD25APR2023<<
            // trigger OnValidate()
            // begin
            //     if "Source Type" = "Source Type"::Item then begin
            //         if "Quantity" > "Avail Qty" then
            //             Error('Quantity should not be greater than available quantity');
            //     end;
            // end;
            //B2BSSD25APR2023>>
        }
        field(27; "Unit of Measure"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Item)) "Item Unit of Measure".Code ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Unit of Measure".Code else
            if ("Source Type" = const(Description)) "Unit of Measure".Code;
        }
        field(29; "Posted RGP OUT NO. Line"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Expected Receipt Date"; Date)
        {
            DataClassification = CustomerContent;//Pk-N on 14.05.2021
        }
        //BaluonNov82022>>
        field(31; Variant; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(32; ModelNo; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Model No.';
        }
        field(33; SerialNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';
        }
        field(34; Make; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Make';
        }
        //BaluonNov82022<<
        field(50000; "Avail Qty"; Integer)//B2BSSD03APR2023
        {
            DataClassification = CustomerContent;
        }
        field(35; "Avail/UnAvail"; Boolean)//B2BSSD07JUN2023
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Type", "Gate Entry No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnDelete()
    var

        PostedLnesCount: integer;
        GateEntLRec: Record "Gate Entry Line_B2B";
        GateLocSetup: Record "Gate Entry Location Setup_B2B";
        GateENtHdrLRec: Record "Gate Entry Header_B2B";
    BEGIN
        /*
        IF GateENtHdrLRec.get("Entry Type", "type", "Gate Entry No.") then;
        GateLocSetup.RESET;
        IF "Entry Type" = "Entry Type"::Inward then
            GateLocSetup.SetRange("Entry Type", GateLocSetup."Entry Type"::Inward)
        else
            GateLocSetup.SetRange("Entry Type", GateLocSetup."Entry Type"::Outward);
        IF GateENtHdrLRec."Location Code" <> '' then
            GateLocSetup.SetRange("Location Code", GateENtHdrLRec."Location Code");
        IF GateLocSetup.findfirst then;
        PostdLneLRec.reset;
        PostdLneLRec.SetRange("Document No.", "Source No.");
        IF PostdLneLRec.findset then;
        PostedLnesCount := PostdLneLRec.Count;
        IF (PostedLnesCount > 1) AND (NOT GateLocSetup."Allow GateEntry Lines Delete") then BEGIN
            IF Confirm('If you delete record corresponding Gate Entry Lines with Source No. will be deleted do you want to continue?', true, false) then begin
                GateEntLRec.Reset();
                GateEntLRec.SetRange("Gate Entry No.", "Gate Entry No.");
                GateEntLRec.SetRange("Source No.", "Source No.");
                IF gateEntLRec.findset then
                    GateEntLRec.DeleteAll();
            end;
        error('You cannot delete Gate entry Lines.');
    end else begin
            */
    END;

    trigger OnInsert()
    begin
        //"Source Line No." := "Line No.";
    end;

    var
        PurchHeader: Record "Purchase Header";
        SalesShipHeader: Record "Sales Shipment Header";
        TransHeader: Record "Transfer Header";
        SalesHeader: Record "Sales Header";
        ReturnShipHeader: Record "Return Shipment Header";
        TransShptHeader: Record "Transfer Shipment Header";
        GateEntryHeader: Record "Gate Entry Header_B2B";
        Text16500: Label 'Source Type must not be blank in %1 %2.';
}

