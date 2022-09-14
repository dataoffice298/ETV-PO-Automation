table 50059 "Gate Entry Header_B2B"
{
    // version NAVIN9.00.00.45778
    DataCaptionFields = "No.";
    LookupPageID = "Gate Entry List";

    fields
    {
        field(1; "Entry Type"; Enum GateEntryInOutWard)
        {
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = FALSE;

            trigger OnValidate();
            begin
                "Posting Date" := "Document Date";
            end;
        }
        field(5; "Document Time"; Time)
        {
            DataClassification = CustomerContent;
            Editable = FALSE;

            trigger OnValidate();
            begin
                "Posting Time" := "Document Time";
            end;
        }
        field(7; "Location Code"; Code[10])
        {

            TableRelation = Location;
            trigger OnValidate();
            var
                InvSetUp: Record "Inventory Setup";
            begin
                InvSetUp.Get();
                case "Entry Type" of
                    "Entry Type"::Inward:
                        if GateEntryLocSetup.GET("Entry Type", "Type", "Location Code") and (GateEntryLocSetup."Posting No. Series" <> '') then
                            /*if ("No. Series" <> '') and (InventSetup."Inward Gate Entry Nos. - RGP" = GateEntryLocSetup."Posting No. Series") then
                                "Posting No. Series" := "No. Series"
                            else*/
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", GateEntryLocSetup."Posting No. Series")
                        else begin
                            InvSetUp.Get();
                            if Type = Type::RGP then begin
                                InvSetUp.TestField("Inward RGP No. Series_B2B");
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", InvSetUp."Inward RGP No. Series_B2B")
                            end else
                                if Type = Type::NRGP then begin
                                    InvSetUp.TestField("Inward NRGP No. Series_B2B");
                                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", InvSetUp."Inward NRGP No. Series_B2B")
                                end;
                        end;
                    "Entry Type"::Outward:
                        if GateEntryLocSetup.GET("Entry Type", "Type", "Location Code") and (GateEntryLocSetup."Posting No. Series" <> '') then
                            /*if ("No. Series" <> '') and (InventSetup."Outward Gate Entry Nos.-RGP" = GateEntryLocSetup."Posting No. Series") then
                                "Posting No. Series" := "No. Series"
                            else*/
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", GateEntryLocSetup."Posting No. Series")
                        else begin
                            if Type = Type::RGP then begin
                                InvSetUp.TestField("Outward RGP No. Series_B2B");
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", InvSetUp."Outward RGP No. Series_B2B")
                            end else
                                if Type = Type::NRGP then begin
                                    InvSetUp.TestField("Outward NRGP No. Series_B2B");
                                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", InvSetUp."Outward NRGP No. Series_B2B")
                                end;
                        end;
                //B2B FIX 19Apr2021<<
                end;
            end;
        }
        field(8; Description; Text[120])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Item Description"; Text[120])
        {
            DataClassification = CustomerContent;
        }
        field(10; "LR/RR No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Loading Slip No.';
            Editable = false;//b2bpksalecorr12
        }
        field(11; "LR/RR Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Loading Slip Date';
            Editable = false;//b2bpksalecorr12
        }
        field(12; "Vehicle No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
            //vehicle: record "Transporter Vehicle";
            begin
                /* vehicle.Reset();
                 vehicle.SetRange("Vehicle Reg No.", "Vehicle No.");
                 if vehicle.FindFirst() then begin
                     //if vehicle.get("Vehicle No.") then begin
                     "Transporter No." := vehicle."Vendor No.";
                     "Transporter Name" := vehicle."Vendor Name";
                 end;*/


            end;

        }
        field(13; "Station From/To"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; Comment; Boolean)
        {
            /*CalcFormula = Exist ("Gate Entry Comment Line" WHERE("Gate Entry Type" = FIELD("Entry Type"),
                                                                  "No." = FIELD("No.")));

           //  FieldClass = FlowField;*/
        }
        field(16; "Posting No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(17; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Posting Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Posting No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");TEST
            end;
        }
        field(21; "Approval Status"; enum ApprovalStatus)
        {
            DataClassification = CustomerContent;
            Editable = FALSE;
        }
        field(22; "Gate No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Type"; Enum GateEntryType)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Transporter No."; Code[20])
        {
            DataClassification = CustomerContent;


        }
        field(25; "Transporter Name"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(26; StaffNo; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
            trigger OnValidate()
            Var
                EmpGRec: Record Employee;
            begin
                IF EmpGRec.GET(StaffNo) THEN
                    "Staff Name" := EmpGRec.FullName();
            end;
        }
        field(27; "Staff Name"; code[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(28; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(29; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(30; "Comments"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(31; "Vendor No"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            trigger OnValidate()
            Var
                VendRec: Record Vendor;
            begin
                IF VendRec.GET("Vendor No") THEN
                    "Vendor Name" := VendRec.Name;
                //"Vend Type" := VendRec."Vendor Type";

            end;
        }
        field(32; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33; "Vend Type"; enum PurchaseType)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(34; "Driver Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        Field(35; "No. Printed"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;//b2bpksalecorr12
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Type", "No.")
        {
        }
        key(Key2; "Location Code", "Posting Date", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        GateEntryLine.RESET;
        GateEntryLine.SETRANGE("Entry Type", "Entry Type");
        GateEntryLine.SETRANGE("Gate Entry No.", "No.");
        GateEntryLine.DELETEALL;

        /* GateEntryCommentLine.SETRANGE("Gate Entry Type", "Entry Type");
         GateEntryCommentLine.SETRANGE("No.", "No.");
         GateEntryCommentLine.DELETEALL;*/
    end;

    trigger OnInsert();
    begin
        "Document Date" := WORKDATE;
        "Document Time" := TIME;
        "Posting Date" := WORKDATE;
        "Posting Time" := TIME;
        "User ID" := USERID;
        InventSetup.GET;
        case "Entry Type" of
            "Entry Type"::Inward:
                case Type of
                    type::RGP:
                        if "No." = '' then begin
                            InventSetup.TESTFIELD("Inward Gate Entry Nos.-RGP_B2B");
                            NoSeriesMgt.InitSeries(InventSetup."Inward Gate Entry Nos.-RGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        end;
                    Type::NRGP:
                        if "No." = '' then begin
                            InventSetup.TESTFIELD("Inward Gate Entry Nos.NRGP_B2B");
                            NoSeriesMgt.InitSeries(InventSetup."Inward Gate Entry Nos.NRGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        end;
                end;
            "Entry Type"::Outward:
                case Type of
                    type::RGP:
                        if "No." = '' then begin
                            InventSetup.TESTFIELD("Outward Gate Entry Nos.RGP_B2B");
                            NoSeriesMgt.InitSeries(InventSetup."Outward Gate Entry Nos.RGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        end;
                    Type::NRGP:
                        if "No." = '' then begin
                            InventSetup.TESTFIELD("Outward Gate EntryNos.NRGP_B2B");
                            NoSeriesMgt.InitSeries(InventSetup."Outward Gate EntryNos.NRGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        end;
                end;

        end;

    end;

    var
        GateEntryLine: Record "Gate Entry Line_B2B";
        InventSetup: Record "Inventory Setup";
        GateEntryLocSetup: Record "Gate Entry Location Setup_B2B";
        //GateEntryCommentLine: Record "Gate Entry Comment Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(OldGateEntryHeader: Record "Gate Entry Header_B2B"): Boolean;
    begin
        InventSetup.GET;
        case "Entry Type" of
            "Entry Type"::Inward:
                case Type of
                    type::RGP:
                        begin
                            InventSetup.TESTFIELD("Inward Gate Entry Nos.-RGP_B2B");
                            if NoSeriesMgt.SelectSeries(InventSetup."Inward Gate Entry Nos.-RGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
                                NoSeriesMgt.SetSeries("No.");
                                exit(true);
                            end;
                        end;
                    Type::NRGP:
                        begin
                            InventSetup.TESTFIELD("Inward Gate Entry Nos.NRGP_B2B");
                            if NoSeriesMgt.SelectSeries(InventSetup."Inward Gate Entry Nos.NRGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
                                NoSeriesMgt.SetSeries("No.");
                                exit(true);
                            end;
                        end;
                end;
            "Entry Type"::Outward:
                case Type of
                    type::RGP:
                        begin
                            InventSetup.TESTFIELD("Outward Gate Entry Nos.RGP_B2B");
                            if NoSeriesMgt.SelectSeries(InventSetup."Outward Gate Entry Nos.RGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
                                NoSeriesMgt.SetSeries("No.");
                                exit(true);
                            end;
                        end;
                    Type::NRGP:
                        begin
                            InventSetup.TESTFIELD("Outward Gate EntryNos.NRGP_B2B");
                            if NoSeriesMgt.SelectSeries(InventSetup."Outward Gate EntryNos.NRGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
                                NoSeriesMgt.SetSeries("No.");
                                exit(true);
                            end;
                        end;
                end;
        end;
    end;

    procedure CHECKMAND()
    var
        GAteENtLines: Record "Gate Entry Line_B2B";
        Pwhrrcplin: Record "Posted Whse. Shipment Line"; ////b2bpksalecorr10
    begin
        GAteENtLines.RESET();
        GAteENtLines.SetRange(Type, Type);
        GAteENtLines.SetRange("Entry Type", "Entry Type");
        GAteENtLines.SetRange("Gate Entry No.", "No.");
        IF GAteENtLines.IsEmpty then
            ERROR('No lines are available for this gate entry.')
        else
            IF GAteENtLines.FINDSET then
                repeat
                    /*
                        //b2bpksalecorr9 start
                        if GAteENtLines."Source Type" = GAteENtLines."Source Type"::"Posted Loading Slip" then begin
                            Pwhrrcplin.Reset();
                            Pwhrrcplin.SetRange("Posted Loading Slip No.", GAteENtLines."Source No.");
                            Pwhrrcplin.SetRange("Posted Loading Slip Line No.", GAteENtLines."Source Line No.");
                            /* IF not Pwhrrcplin.FindFirst() then
                                 Error('warehouse shipment for Loading Slip %1 is not yet posted', Pwhrrcplin."Source No.");*/
                    //Commented on 06.05.2021 by PK-Nyoung
                    //end;

                    //b2bpksalecorr9 end
                    GAteENtLines.TestField("Source No.");
                    GAteENtLines.TestField("Challan No.");
                    GAteENtLines.TestField("Challan Date");
                    IF GAteENtLines.Type = GAteENtLines.Type::RGP THEN begin
                        GAteENtLines.TestField(Quantity);
                        GAteENtLines.TestField("Unit of Measure");
                    end;
                until GAteENtLines.Next = 0;
    end;
}

