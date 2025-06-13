table 50221 "Gate Entry Header_B2B"
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
                //InvSetUp: Record "Inventory Setup";
                Location: Record Location;
                UserWiseLocation: Record "Location Wise User";//B2BSSD30MAR2023
                Userwisesetup: Codeunit UserWiseSecuritySetup;//B2BSSD30MAR2023
            begin

                Location.Get(Rec."Location Code");
                case "Entry Type" of
                    "Entry Type"::Inward:
                        if GateEntryLocSetup.GET("Entry Type", "Type", "Location Code") and (GateEntryLocSetup."Posting No. Series" <> '') then
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GateEntryLocSetup."Posting No. Series")
                        else begin

                            if Type = Type::RGP then begin
                                Location.TestField("Inward RGP No. Series_B2B");
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", Location."Inward RGP No. Series_B2B")
                            end else
                                if Type = Type::NRGP then begin
                                    Location.TestField("Inward NRGP No. Series_B2B");
                                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", Location."Inward NRGP No. Series_B2B")
                                end;
                        end;
                    "Entry Type"::Outward:
                        if GateEntryLocSetup.GET("Entry Type", "Type", "Location Code") and (GateEntryLocSetup."Posting No. Series" <> '') then
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GateEntryLocSetup."Posting No. Series")
                        else begin
                            if Type = Type::RGP then begin
                                Location.TestField("Outward RGP No. Series_B2B");
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", Location."Outward RGP No. Series_B2B")
                            end else
                                if Type = Type::NRGP then begin
                                    Location.TestField("Outward NRGP No. Series_B2B");
                                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", Location."Outward NRGP No. Series_B2B")
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
        /*field(9; "Item Description"; Text[120])
        {
            DataClassification = CustomerContent;
        }*/

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
        field(53; "User Name"; Code[50])
        {
            DataClassification = CustomerContent;
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
        // field(24; "Transporter No."; Code[20])
        // {
        //     DataClassification = CustomerContent;


        // }
        // field(25; "Transporter Name"; text[100])
        // {
        //     DataClassification = CustomerContent;
        // }
        // field(26; StaffNo; code[20])
        // {
        //     DataClassification = CustomerContent;
        //     TableRelation = Employee;
        //     trigger OnValidate()
        //     Var
        //         EmpGRec: Record Employee;
        //     begin
        //         IF EmpGRec.GET(StaffNo) THEN
        //             "Staff Name" := EmpGRec.FullName();
        //     end;
        // }
        // field(27; "Staff Name"; code[250])
        // {
        //     DataClassification = CustomerContent;
        //     Editable = false;
        // }
        // field(28; "Global Dimension 1 Code"; Code[20])
        // {
        //     CaptionClass = '1,1,1';
        //     Caption = 'Global Dimension 1 Code';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

        //     trigger OnValidate()
        //     begin
        //         //ValidateShortcutDimCode(1, "Global Dimension 1 Code");
        //     end;
        // }
        // field(29; "Global Dimension 2 Code"; Code[20])
        // {
        //     CaptionClass = '1,1,2';
        //     Caption = 'Global Dimension 2 Code';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

        //     trigger OnValidate()
        //     begin
        //         //ValidateShortcutDimCode(1, "Global Dimension 1 Code");
        //     end;
        // }
        // field(30; "Comments"; Text[250])
        // {
        //     DataClassification = CustomerContent;
        // }
        field(31; "Vendor No"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        // field(32; "Vendor Name"; Text[100])
        // {
        //     DataClassification = CustomerContent;
        //     Editable = false;
        // }
        // field(33; "Vend Type"; enum PurchaseType)
        // {
        //     DataClassification = CustomerContent;
        //     Editable = false;
        // }
        Field(34; "Driver Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        Field(35; "No. Printed"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        //BaluonNov82022>>
        field(37; Purpose; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(38; InstallationFromDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Installation From Date';
        }
        field(39; InstallationToDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Installation To Date';
        }
        field(40; ShootingStartDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shooting Start Date';
        }
        field(41; ShootingEndDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shooting End Date';
        }
        field(42; ExpectedDateofReturn; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Expected Date of Return';
        }
        field(43; SubLocation; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Location';
            TableRelation = Location;
        }
        field(44; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));
        }
        field(45; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));
        }
        field(46; Designation; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(47; Program; Text[100])
        {
            DataClassification = CustomerContent;
        }
        //BaluonNov82022<<

        //B2BMSOn14Nov2022>>
        field(48; "Purchase Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(49; "Purchase Order Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        //B2BSSD16Dec2022<<
        field(50; "Posted RGP Outward NO."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Posted Gate Entry Header_B2B"."No." where("Entry Type" = const(Outward), Type = const(RGP));//B2BSSD21MAR2023
            trigger OnValidate()

            var
                PostedRgpOutward: Record "Posted Gate Entry Header_B2B";
            begin
                //B2BSSD27Dec2022<<
                PostedRgpOutward.reset();
                PostedRgpOutward.SetRange("No.", "Posted RGP Outward NO.");
                if PostedRgpOutward.FindFirst() then
                    "Posted RGP Outward Date" := PostedRgpOutward."Posting Date";
                //B2BSSD27Dec2022>>
            end;
        }
        field(51; "Posted RGP Outward Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "LR/RR No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(11; "LR/RR Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        /*field(55; "Department Code"; Code[20])
        {
            //B2BSSD20Jan2023<<
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));
            //B2BSSD20Jan2023>>
            DataClassification = CustomerContent;
        }
        field(56; "Channel  Code"; Code[20])
        {
            //B2BSSD20Jan2023<<
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));
            //B2BSSD20Jan2023>>
            DataClassification = CustomerContent;
        }*/
        //B2BSSD16Dec2022>>

        //B2BSSD22Dec2022<<
        field(57; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        //B2BSSD22Dec2022>>

        //B2BSSD20FEB2023<<
        field(50001; "Challan No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Challan No.';
        }
        field(50002; "Challan Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //B2BSSD20FEB2023>>

        //B2BSSD21FEB2023<<
        field(50003; "Shortcut Dimension 9 Code"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(9),
            Blocked = CONST(false));
        }
        //B2BSSD21FEB2023>>
        field(50004; "Indent Document No"; Code[30])//B2BSSD02MAR2023
        {
            DataClassification = CustomerContent;
            Caption = 'Indent Document No';
            Editable = false;
        }
        field(50005; "Indent Line No"; Integer)//B2BSSD02MAR2023
        {
            DataClassification = CustomerContent;
            Caption = 'Indent Line No';
        }
        field(50006; "To Location"; Text[50])//B2BSSD31MAR2023
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(50007; "Purch Cr.Memo No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch Cr. Memo No.';
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
    var
        Location: Record Location;
        user: Record User;//B2BSSD25APR2023
        RgpOutward: Record "Gate Entry Header_B2B";
    begin
        "Document Date" := WORKDATE;
        "Document Time" := TIME;
        "Posting Date" := WORKDATE;
        "Posting Time" := TIME;
        "User ID" := USERID;


        Location.Get(Rec."Location Code");
        case "Entry Type" of
            "Entry Type"::Inward:
                case Type of
                    type::RGP:
                        if "No." = '' then begin
                            Location.TESTFIELD("Inward Gate Entry Nos.-RGP_B2B");
                            NoSeriesMgt.InitSeries(Location."Inward Gate Entry Nos.-RGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        end;
                    Type::NRGP:
                        if "No." = '' then begin
                            Location.TESTFIELD("Inward Gate Entry Nos.NRGP_B2B");
                            NoSeriesMgt.InitSeries(Location."Inward Gate Entry Nos.NRGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        end;
                end;
            "Entry Type"::Outward:
                case Type of
                    type::RGP:
                        if "No." = '' then begin
                            Location.TESTFIELD("Outward Gate Entry Nos.RGP_B2B");
                            NoSeriesMgt.InitSeries(Location."Outward Gate Entry Nos.RGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
                        end;
                    Type::NRGP:
                        if "No." = '' then begin
                            Location.TESTFIELD("Outward Gate EntryNos.NRGP_B2B");
                            NoSeriesMgt.InitSeries(Location."Outward Gate EntryNos.NRGP_B2B", xRec."No. Series", "Posting Date", "No.", "No. Series");
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
    var
        Location: Record Location;
    begin
        Location.Get(Rec."Location Code");
        case "Entry Type" of
            "Entry Type"::Inward:
                case Type of
                    type::RGP:
                        begin
                            Location.TESTFIELD("Inward Gate Entry Nos.-RGP_B2B");
                            if NoSeriesMgt.SelectSeries(Location."Inward Gate Entry Nos.-RGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
                                NoSeriesMgt.SetSeries("No.");
                                exit(true);
                            end;
                        end;
                    Type::NRGP:
                        begin
                            Location.TESTFIELD("Inward Gate Entry Nos.NRGP_B2B");
                            if NoSeriesMgt.SelectSeries(Location."Inward Gate Entry Nos.NRGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
                                NoSeriesMgt.SetSeries("No.");
                                exit(true);
                            end;
                        end;
                end;
            "Entry Type"::Outward:
                case Type of
                    type::RGP:
                        begin
                            Location.TESTFIELD("Outward Gate Entry Nos.RGP_B2B");
                            if NoSeriesMgt.SelectSeries(Location."Outward Gate Entry Nos.RGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
                                NoSeriesMgt.SetSeries("No.");
                                exit(true);
                            end;
                        end;
                    Type::NRGP:
                        begin
                            Location.TESTFIELD("Outward Gate EntryNos.NRGP_B2B");
                            if NoSeriesMgt.SelectSeries(Location."Outward Gate EntryNos.NRGP_B2B", OldGateEntryHeader."No. Series", "No. Series") then begin
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
                    //B2BSSD23MAR2023<<
                    if GAteENtLines."Source Type" = GAteENtLines."Source Type"::Item then
                        GAteENtLines.TestField("Source No.")
                    else
                        if GAteENtLines."Source Type" = GAteENtLines."Source Type"::"Fixed Asset" then
                            GAteENtLines.TestField("Source No.")
                        else
                            if GAteENtLines."Source Type" = GAteENtLines."Source Type"::"Purchase Order" then
                                GAteENtLines.TestField("Source No.")
                            else
                                if GAteENtLines."Source Type" = GAteENtLines."Source Type"::"Transfer Receipt" then
                                    GAteENtLines.TestField("Source No.")
                                else
                                    if GAteENtLines."Source Type" = GAteENtLines."Source Type"::Description then
                                        GAteENtLines."Source No." := '';
                    //B2BSSD23MAR2023>>

                    //GAteENtLines.TestField("Challan No.");
                    //GAteENtLines.TestField("Challan Date");
                    IF GAteENtLines.Type = GAteENtLines.Type::RGP THEN begin
                        GAteENtLines.TestField(Quantity);
                        GAteENtLines.TestField("Unit of Measure");
                    end;
                until GAteENtLines.Next = 0;
    end;
}

