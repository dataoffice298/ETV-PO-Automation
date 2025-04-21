table 50209 "Indent Req Header"
{
    // version PH1.0,PO1.0

    LookupPageID = "Indent Requisition List";

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchaseSetup.GET;
                    NoSeriesMgt.TestManual(PurchaseSetup."Indent Req No.");
                    "No.Series" := '';
                END;
            end;
        }
        field(10; "Document Date"; Date)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(11; "Resposibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,Release,"Pending Approval";
        }
        field(13; "No.Series"; Code[20])
        {
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                PurchaseSetup.GET;
                IF Type = Type::Enquiry THEN
                    Noseries.SETRANGE(Code, PurchaseSetup."Enquiry Nos.")
                ELSE
                    IF Type = Type::Quote THEN
                        Noseries.SETRANGE(Code, PurchaseSetup."Quote Nos.")
                    ELSE
                        Noseries.SETRANGE(Code, PurchaseSetup."Order Nos.");
                IF PAGE.RUNMODAL(458, Noseries) = ACTION::LookupOK THEN
                    "No.Series" := Noseries."Series Code";
            end;
        }
        field(14; Type; Option)
        {
            OptionMembers = Enquiry,Quote,"Order";
        }
        field(15; "Indent Type"; Option)
        {
            Caption = 'Indent Type';
            Description = 'B2BESGOn02Jun2022';
            Editable = false;
            OptionCaption = ' ,IT,Non-IT';
            OptionMembers = " ",IT,"Non-IT";
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Description = 'B2BESGOn02Jun2022';
            TableRelation = Currency;
        }
        field(17; "RFQ No."; code[20])
        {
            Caption = 'RFQ No.';
            Description = 'B2BESGOn02Jun2022';
            trigger OnValidate()
            begin
                if "RFQ No." <> xRec."RFQ No." then begin
                    PurchaseSetup.GET;
                    NoSeriesMgt.TestManual(PurchaseSetup."RFQ Nos.");
                    "No.Series" := '';
                end;
            end;
        }
        field(18; "Indent No."; Code[100])
        {

            TableRelation = "Indent Header";
        }
        field(50001; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));

            trigger OnValidate()
            begin
                IndentHdr.Reset();
                IndentHdr.SetRange("No.", "No.");
                IF IndentHdr.FIND('-') THEN BEGIN
                    repeat
                        IndentHdr."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                        IndentHdr.Modify();
                    until IndentHdr.Next = 0;
                end;
            END;
        }
        field(50002; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));
        }
        //B2BSSD20Feb2023<<
        field(50003; "Shortcut Dimension 9 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(9), Blocked = CONST(false));
        }
        //B2BSSD20Feb2023>>

        field(50004; "programme Name"; Code[50])//B2BSSD20MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50005; Purpose; Text[250])//B2BSSD21MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50006; "Create Purchase Order"; Boolean)//B2BSSD09MAY2023
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
            Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(50008; "Req Status"; Option)
        {
            OptionCaption = ' ,Pending,Completed';
            OptionMembers = "",Pending,Completed;
            Caption = 'Req Status';
        }
        field(50009; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50010; Note; Text[250]) //B2BVCOn29Aug2024
        {
            DataClassification = CustomerContent;
        }
        field(50011; Cancel; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Document Date", "Last Modified Date")
        { }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnInsert();
    begin
        PurchaseSetup.GET;
        IF "No." = '' THEN BEGIN
            PurchaseSetup.TESTFIELD("Indent Req No.");
            PurchaseSetup.TestField("RFQ Nos.");
            NoSeriesMgt.InitSeries(PurchaseSetup."Indent Req No.", xRec."No.Series", 0D, "No.", "No.Series");
            NoSeriesMgt.InitSeries(PurchaseSetup."RFQ Nos.", xRec."No.Series", 0D, "RFQ No.", "No.Series");
            "No.Series" := ''
        END;
        "Document Date" := TODAY;
    end;

    var
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IndentReq: Record "Indent Req Header";
        OldIndentReq: Record "Indent Req Header";
        Noseries: Record 310;
        IndentHdr: Record "Indent Header";
        IndentLine: Record "Indent Line";

    procedure AssistEdit(OldIndentReq: Record "Indent Req Header"): Boolean;
    begin
        IndentReq := Rec;
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("Indent Req No.");
        IF NoSeriesMgt.SelectSeries(PurchaseSetup."Indent Req No.", OldIndentReq."No.", IndentReq."No.") THEN BEGIN
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD("Indent Req No.");
            NoSeriesMgt.SetSeries(IndentReq."No.");
            Rec := IndentReq;
            EXIT(TRUE);
        END;
    end;

    procedure AssistEditRFQ(OldIndentReq: Record "Indent Req Header"): Boolean;
    begin
        IndentReq := Rec;
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("RFQ Nos.");
        IF NoSeriesMgt.SelectSeries(PurchaseSetup."RFQ Nos.", OldIndentReq."RFQ No.", IndentReq."RFQ No.") THEN BEGIN
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD("RFQ Nos.");
            NoSeriesMgt.SetSeries(IndentReq."RFQ No.");
            Rec := IndentReq;
            EXIT(TRUE);
        END;
    end;

    procedure TestStatusOpen();
    begin
        TESTFIELD(Status, Status::Open);
    end;

    procedure SetStyle(): Text
    begin
        if Rec."Req Status" = Rec."Req Status"::Completed then
            exit('favorable')
        else
            exit('Unfavorable');
        exit('');
    end;
}

